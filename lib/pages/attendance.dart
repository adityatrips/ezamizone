import 'package:ezamizone/providers/auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  FlipCardController flipCardController = FlipCardController();
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, api, child) {
        api.getAttendance().then((value) {
          setState(() {
            loading = false;
          });
        });
        return loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Scaffold(
                  body: ListView.separated(
                    itemCount: api.attendance['records'].length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8.0);
                    },
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return FlipCard(
                        controller: flipCardController,
                        front: _subjectInformation(index, api, context),
                        back: _attendanceInformation(api, index),
                      );
                    },
                  ),
                ),
              );
      },
    );
  }

  Container _attendanceInformation(ApiProvider api, int index) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            api.getBgColor(
              api.attendance["records"][index]["attendance"]["attended"],
              api.attendance["records"][index]["attendance"]["held"],
            ),
            api
                .getBgColor(
                  api.attendance["records"][index]["attendance"]["attended"],
                  api.attendance["records"][index]["attendance"]["held"],
                )
                .withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.5, 1],
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 50,
            child: Text(
              textAlign: TextAlign.center,
              "${api.attendance["records"][index]["attendance"]["held"]}/${api.attendance["records"][index]["attendance"]["held"]}\n%",
            ),
          ),
        ],
      ),
    );
  }

  Padding _subjectInformation(
      int index, ApiProvider api, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: index == api.attendance["records"].length - 1 ? 16 : 0,
      ),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.3, 1],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              api.attendance["records"][index]['course']['code'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              api.attendance["records"][index]['course']['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Tap to view attendance.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _attendanceInformation(
  //   BuildContext context,
  //   Map<String, dynamic>? attendance,
  //   bool isLast,
  // ) {
  //   String getPercentage() {
  //     int total = attendance!["attendance"]["held"];
  //     int attended = attendance["attendance"]["attended"];
  //     return ((attended / total) * 100).toStringAsFixed(2);
  //   }

  //   Color getBgColor() {
  //     double percent = double.parse(getPercentage().split(" ")[0]);

  //     if (percent < 75) {
  //       return const Color.fromRGBO(239, 83, 80, 1);
  //     } else if (percent >= 75 && percent < 85) {
  //       return const Color.fromRGBO(255, 167, 38, 1);
  //     }
  //     return const Color.fromRGBO(102, 187, 106, 1);
  //   }

  //   return }
}
