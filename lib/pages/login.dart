import 'package:ezamizone/banner_ad_widget.dart';
import 'package:ezamizone/globals.dart';
import 'package:ezamizone/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController =
      TextEditingController(text: "11330339");
  TextEditingController passwordController =
      TextEditingController(text: "pratham@0510");

  bool isHidden = true;
  bool rememberMe = false;

  final GetStorage storage = GetStorage();

  @override
  void initState() {
    if (storage.hasData("username") && storage.hasData("password")) {
      Provider.of<ApiProvider>(context, listen: false)
          .getIsCredsValid(
        storage.read("username"),
        storage.read("password"),
      )
          .then((value) {
        if (value) {
          usernameController.clear();
          passwordController.clear();
          if (rememberMe) {
            storage.write("username", usernameController.text);
            storage.write("password", passwordController.text);
          }
          Get.offNamedUntil("/attendance", (route) {
            if (route.settings.name == "/attendance") {
              return true;
            }
            return false;
          });
        } else {
          Get.snackbar(
            "Invalid Credentials",
            "Please check your username and password",
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
          );
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, api, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              TextField(
                style: TextStyle(
                  color: Get.isDarkMode ? Globals.onPrimary : Globals.primary,
                ),
                controller: usernameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Globals.onPrimary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Globals.onPrimary,
                    ),
                  ),
                  label: Text(
                    "Username",
                    style: TextStyle(
                      color:
                          Get.isDarkMode ? Globals.onPrimary : Globals.primary,
                    ),
                  ),
                ),
                cursorColor:
                    Get.isDarkMode ? Globals.onPrimary : Globals.primary,
              ),
              const SizedBox(height: 16),
              TextField(
                style: TextStyle(
                  color: Get.isDarkMode ? Globals.onPrimary : Globals.primary,
                ),
                controller: passwordController,
                obscureText: isHidden,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Globals.onPrimary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Globals.onPrimary,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    child: Icon(
                      isHidden ? Icons.visibility : Icons.visibility_off,
                      color:
                          Get.isDarkMode ? Globals.onPrimary : Globals.primary,
                    ),
                    onTap: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                  ),
                  label: Text(
                    "Password",
                    style: TextStyle(
                      color:
                          Get.isDarkMode ? Globals.onPrimary : Globals.primary,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    rememberMe = !rememberMe;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Remember this account?",
                      style: TextStyle(
                        color: Get.isDarkMode
                            ? Globals.onPrimary
                            : Globals.primary,
                      ),
                    ),
                    Checkbox(
                      checkColor:
                          Get.isDarkMode ? Globals.onPrimary : Globals.primary,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Get.isDarkMode
                              ? Globals.onPrimary
                              : Globals.primary,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      overlayColor: WidgetStatePropertyAll(
                        Get.isDarkMode ? Globals.onPrimary : Globals.primary,
                      ),
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = !rememberMe;
                        });
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  fixedSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  if (rememberMe) {
                    storage.writeInMemory(
                      "username",
                      usernameController.text,
                    );
                    storage.writeInMemory(
                      "password",
                      passwordController.text,
                    );
                  }

                  api
                      .getIsCredsValid(
                    usernameController.text,
                    passwordController.text,
                  )
                      .then((value) {
                    if (value) {
                      usernameController.clear();
                      passwordController.clear();

                      Get.offNamedUntil("/attendance", (route) {
                        if (route.settings.name == "/attendance") {
                          return true;
                        }
                        return false;
                      });
                    } else {
                      Get.snackbar(
                        "Invalid Credentials",
                        "Please check your username and password",
                        snackPosition: SnackPosition.TOP,
                        margin: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        backgroundColor: Colors.red[100],
                        colorText: Colors.red[900],
                      );
                    }
                  });
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Get.isDarkMode ? Globals.onPrimary : Globals.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "Made with ❤️ by Aditya Tripathi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Get.isDarkMode ? Globals.onPrimary : Globals.primary,
                ),
              ),
              const SizedBox(height: 20),
              const MyBannerAdWidget(),
            ],
          ),
        );
      },
    );
  }
}
