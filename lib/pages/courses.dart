import 'package:ezamizone/banner_ad_widget.dart';
import 'package:ezamizone/globals.dart';
import 'package:ezamizone/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool loading = true;

  @override
  void initState() {
    Provider.of<ApiProvider>(context, listen: false).getAllCourses().then(
      (value) {
        Provider.of<ApiProvider>(context, listen: false).getSemesters().then(
          (value) {
            setState(() {
              loading = false;
            });
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, api, child) {
        return loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  ListView(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: api.allCourses["courses"].length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          if (index == api.allCourses["courses"].length - 1) {
                            return getCourseCard(
                              index,
                              isLast: true,
                            );
                          } else if (index == 0) {
                            return getCourseCard(
                              index,
                              isFirst: true,
                            );
                          }
                          return getCourseCard(
                            index,
                          );
                        },
                      ),
                      const MyBannerAdWidget(),
                    ],
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: MyBannerAdWidget(),
                  )
                ],
              );
      },
    );
  }

  Widget getCourseCard(
    int index, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    Map<String, dynamic> semesters =
        Provider.of<ApiProvider>(context).semesters;

    List<DropdownMenuItem> getSemesters() {
      List<DropdownMenuItem<dynamic>> data = [];

      for (var i = 0; i < semesters["semesters"].length; i++) {
        data.add(
          DropdownMenuItem(
            value: semesters["semesters"][i]["name"],
            child: Text(
              semesters["semesters"][i]["name"],
            ),
          ),
        );
      }
      return data;
    }

    return Consumer<ApiProvider>(builder: (context, api, child) {
      return api.allCourses.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ).copyWith(
                bottom: isLast ? 16 : 0,
              ),
              child: Column(
                children: [
                  isFirst
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Select Semester:",
                              style: TextStyle(
                                color: Get.isDarkMode
                                    ? Globals.onPrimary
                                    : Globals.onLightBackground,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton(
                              style: TextStyle(
                                color: Get.isDarkMode
                                    ? Globals.onPrimary
                                    : Globals.primary,
                              ),
                              value: api.dropdownValue,
                              items: getSemesters(),
                              onChanged: (value) {
                                api.dropdownValue = value;
                                setState(() {
                                  loading = true;
                                });
                                api.getAllCourses(ref: value!.toString()).then((
                                  value,
                                ) {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              },
                            )
                          ],
                        )
                      : Container(),
                  Container(
                    height: 125,
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        stops: const [0.3, 1],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          api.allCourses["courses"][index]['type'],
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${api.allCourses["courses"][index]['ref']['code']}\n${api.allCourses["courses"][index]['ref']['name']}",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(
                                  Uri.parse(
                                    api.allCourses["courses"][index]
                                        ['syllabusDoc'],
                                  ),
                                );
                              },
                              child: InkResponse(
                                child: Icon(
                                  Icons.file_download_rounded,
                                  color: Globals.onPrimary,
                                ),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }
}
