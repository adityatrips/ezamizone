import 'dart:async';
import 'package:ezamizone/globals.dart';
import 'package:ezamizone/pages/attendance.dart';
import 'package:ezamizone/pages/courses.dart';
import 'package:ezamizone/pages/login.dart';
import 'package:ezamizone/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(
    "ezamizone",
  );
  unawaited(MobileAds.instance.initialize());
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    Future.delayed(
      const Duration(
        seconds: 2,
      ),
      () => FlutterNativeSplash.remove(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApiProvider()),
      ],
      child: GetMaterialApp(
        themeMode: ThemeMode.system,
        theme: ThemeData(
          scaffoldBackgroundColor: Globals.lightBackground,
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Globals.primary,
            onPrimary: Globals.onPrimary,
            secondary: Globals.primary,
            onSecondary: Globals.onPrimary,
            error: const Color(0xFFFFCDD2),
            onError: const Color(0xFFB71C1C),
            surface: Globals.lightBackground,
            onSurface: Globals.onLightBackground,
          ),
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Globals.darkBackground,
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: Globals.primary,
            onPrimary: Globals.onPrimary,
            secondary: Globals.primary,
            onSecondary: Globals.onPrimary,
            error: const Color(0xFFFFCDD2),
            onError: const Color(0xFFB71C1C),
            surface: Globals.lightBackground,
            onSurface: Globals.onLightBackground,
          ),
        ),
        initialRoute: "/",
        routes: {
          "/attendance": (context) => _getScaffold(
                child: const AttendancePage(),
              ),
          "/courses": (context) => _getScaffold(
                child: const CoursesPage(),
              ),
          "/": (context) => const SafeArea(
                child: Scaffold(
                  body: LoginPage(),
                ),
              ),
        },
      ),
    );
  }

  Widget _getScaffold({
    required Widget child,
  }) {
    return Consumer<ApiProvider>(builder: (context, api, _) {
      if (!api.isCredentialsValid) {
        return const SafeArea(
          child: Scaffold(
            body: LoginPage(),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Globals.primary,
            foregroundColor: Globals.onPrimary,
            title: Text(
              'Hello ${api.username}',
            ),
          ),
          drawer: Drawer(
            backgroundColor: Get.isDarkMode
                ? Globals.darkBackground
                : Globals.lightBackground,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  height: 200,
                  child: Center(
                    child: Text(
                      "EzAmizone",
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Toggle theme",
                    style: TextStyle(
                      color: Get.isDarkMode
                          ? Globals.onPrimary
                          : Globals.onLightBackground,
                    ),
                  ),
                  leading: Icon(
                    Get.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: Get.isDarkMode
                        ? Globals.onPrimary
                        : Globals.onLightBackground,
                  ),
                  onTap: () {
                    Get.changeThemeMode(
                      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Attendance",
                    style: TextStyle(
                      color: Get.isDarkMode
                          ? Globals.onPrimary
                          : Globals.onLightBackground,
                    ),
                  ),
                  leading: Icon(
                    Icons.calendar_today_rounded,
                    color: Get.isDarkMode
                        ? Globals.onPrimary
                        : Globals.onLightBackground,
                  ),
                  onTap: () {
                    Get.offNamedUntil("/attendance", (route) {
                      if (route.settings.name == "/attendance") {
                        return true;
                      }
                      return false;
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    "Courses",
                    style: TextStyle(
                      color: Get.isDarkMode
                          ? Globals.onPrimary
                          : Globals.onLightBackground,
                    ),
                  ),
                  leading: Icon(
                    Icons.menu_book_rounded,
                    color: Get.isDarkMode
                        ? Globals.onPrimary
                        : Globals.onLightBackground,
                  ),
                  onTap: () => Get.offNamedUntil("/courses", (route) {
                    if (route.settings.name == "/attendance") {
                      return true;
                    }
                    return false;
                  }),
                ),
              ],
            ),
          ),
          body: SafeArea(child: child),
        );
      }
    });
  }
}
