import 'package:ezamizone/globals.dart';
import 'package:ezamizone/pages/attendance.dart';
import 'package:ezamizone/pages/courses.dart';
import 'package:ezamizone/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();
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

  void fetchUserData() {
    api.getProfile().then((value) {
      setState(() {
        data = value;
      });
    });
  }

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
    fetchUserData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApiProvider()),
      ],
      child: GetMaterialApp(
        initialRoute: "/",
        routes: {
          "/": (context) => _getScaffold(const AttendancePage()),
          "/courses": (context) => _getScaffold(const CoursesPage()),
        },
      ),
    );
  }

  Scaffold _getScaffold(
    Widget child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hello ${data['name'].toString().split(" ")[0]}!",
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
              title: const Text("Attendance"),
              leading: const Icon(Icons.calendar_today_rounded),
              onTap: () {
                Get.toNamed("/");
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
      body: child,
    );
  }
}
