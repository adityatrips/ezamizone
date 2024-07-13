import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Dio? dio;

class ApiProvider extends ChangeNotifier {
  Map<String, dynamic> attendance = {};
  Map<String, dynamic> timetable = {};
  Map<String, dynamic> allCourses = {};
  Map<String, dynamic> allResults = {};
  Map<String, dynamic> examSchedule = {};
  Map<String, dynamic> semesters = {};
  Map<String, dynamic> profile = {};
  String username = "";
  bool isCredentialsValid = false;
  dynamic dropdownValue;

  Color getBgColor(int attended, int held) {
    double percent = (attended / held) * 100;

    if (percent < 75) {
      return const Color.fromRGBO(239, 83, 80, 1);
    } else if (percent >= 75 && percent < 85) {
      return const Color.fromRGBO(255, 167, 38, 1);
    }
    return const Color.fromRGBO(102, 187, 106, 1);
  }

  Future<bool> getIsCredsValid(
    String formUsername,
    String formPassword,
  ) async {
    try {
      dio = Dio(
        BaseOptions(
          baseUrl: "http://amizone.fly.dev/api/v1",
          headers: {
            "Authorization": "Basic ${base64Encode(
              // utf8.encode('11330339:pratham@0510'),
              utf8.encode('$formUsername:$formPassword'),
            )}",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      final response = await dio!.get("/user_profile");

      if (response.statusCode == 200) {
        profile = jsonDecode(jsonEncode(response.data));
        isCredentialsValid = true;
        username = response.data["name"].toString().split(' ')[0];
      }
    } catch (e) {
      isCredentialsValid = false;
      profile = {};
      username = "EzAmizone";
    } finally {
      notifyListeners();
    }

    return isCredentialsValid;
  }

  Future<void> getAttendance() async {
    try {
      final response = await dio!.get("/attendance");
      if (response.statusCode == 200) {
        attendance = jsonDecode(jsonEncode(response.data));
      }
    } catch (e) {
      attendance = {};
    } finally {
      notifyListeners();
    }
  }

  Future<void> getTimetable(
    String year,
    String month,
    String day,
  ) async {
    try {
      final response = await dio!.get("/class_schedule/$year/$month/$day");
      if (response.statusCode == 200) {
        timetable = jsonDecode(jsonEncode(response.data));
      }
    } catch (e) {
      timetable = {};
    } finally {
      notifyListeners();
    }
  }

  Future<void> getAllCourses({String? ref}) async {
    try {
      final response = await dio!.get(
        ref == null ? "/courses" : "/courses/$ref",
      );

      if (response.statusCode == 200) {
        allCourses = jsonDecode(jsonEncode(response.data));
      }
    } catch (e) {
      allCourses = {};
    } finally {
      notifyListeners();
    }
  }

  Future<void> getExamResults({String? ref}) async {
    try {
      final response = await dio!.get(
        ref == null ? "/exam_result" : "/exam_result/$ref",
      );

      if (response.statusCode == 200) {
        allResults = jsonDecode(jsonEncode(response.data));
      }
    } catch (e) {
      allResults = {};
    } finally {
      notifyListeners();
    }
  }

  Future<void> getExamSchedule() async {
    try {
      final response = await dio!.get("/exam_schedule");

      if (response.statusCode == 200) {
        examSchedule = jsonDecode(jsonEncode(response.data));
      }
    } catch (e) {
      examSchedule = {};
    } finally {
      notifyListeners();
    }
  }

  Future<void> getSemesters() async {
    try {
      final response = await dio!.get("/semesters");

      if (response.statusCode == 200) {
        semesters = jsonDecode(jsonEncode(response.data));
        dropdownValue = semesters["semesters"][0]["name"];
      }
    } catch (e) {
      semesters = {};
    } finally {
      notifyListeners();
    }
  }
}
