import 'dart:convert';
import 'package:dio/dio.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: "http://amizone.fly.dev",
    headers: {
      "Authorization": "Basic ${base64Encode(
        utf8.encode('11330339:pratham@0510'),
      )}",
    },
    validateStatus: (status) {
      return status! < 500;
    },
  ),
);

class ApiService {
  ApiService({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  Future<Map<String, dynamic>> getAttendance() async {
    try {
      final response = await dio.get("/api/v1/attendance");
      if (response.statusCode == 200) {
        return jsonDecode(jsonEncode(response.data));
      }
      throw Exception("Failed to load attendance");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await dio.get("/api/v1/user_profile");
      if (response.statusCode == 200) {
        print(jsonDecode(jsonEncode(response.data)));
        return jsonDecode(jsonEncode(response.data));
      }
      throw Exception("Failed to load profile");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getCourses() async {
    try {
      final response = await dio.get("/api/v1/courses");
      if (response.statusCode == 200) {
        return jsonDecode(jsonEncode(response.data));
      }
      throw Exception("Failed to load courses");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getCoursesFromRef(String ref) async {
    try {
      final response = await dio.get("/api/v1/courses/$ref");
      if (response.statusCode == 200) {
        return jsonDecode(jsonEncode(response.data));
      }
      throw Exception("Failed to load courses");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getSemesters() async {
    try {
      final response = await dio.get("/api/v1/semesters");
      if (response.statusCode == 200) {
        return jsonDecode(jsonEncode(response.data));
      }
      throw Exception("Failed to load courses");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
