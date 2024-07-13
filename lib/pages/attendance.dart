import 'package:ezamizone/providers/auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          stops: const [0.3, 1],
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            maxRadius: 50,
            child: Text(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
              "${api.attendance["records"][index]["attendance"]["attended"]}/${api.attendance["records"][index]["attendance"]["held"]}\n${api.attendance["records"][index]["attendance"]["attended"] / api.attendance["records"][index]["attendance"]["held"] * 100}%",
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
            stops: const [0.2, 1],
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
              style: TextStyle(
                fontSize: 24,
                color: Get.isDarkMode
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              api.attendance["records"][index]['course']['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Get.isDarkMode
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Tap to view attendance.",
              style: TextStyle(
                fontSize: 14,
                color: Get.isDarkMode
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
