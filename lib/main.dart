import 'package:ezamizone/globals.dart';
import 'package:ezamizone/pages/attendance.dart';
import 'package:ezamizone/pages/courses.dart';
import 'package:ezamizone/pages/login.dart';
import 'package:ezamizone/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(
    "ezamizone",
  );
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
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          colorScheme: Globals.lightTheme,
        ),
        darkTheme: ThemeData(
          colorScheme: Globals.darkTheme,
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
            title: Text(
              'Hello ${api.username}',
            ),
          ),
          drawer: Drawer(
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
                  title: Text("Toggle theme"),
                  leading: Icon(
                    Get.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  onTap: () {
                    Get.changeThemeMode(
                      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                    );
                  },
                ),
                ListTile(
                  title: const Text("Attendance"),
                  leading: const Icon(Icons.calendar_today_rounded),
                  onTap: () {
                    Get.toNamed("/attendance");
                  },
                ),
                ListTile(
                  title: const Text("Courses"),
                  leading: const Icon(Icons.menu_book_rounded),
                  onTap: () => Get.toNamed("/courses"),
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
