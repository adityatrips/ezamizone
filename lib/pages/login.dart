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
        print(value.toString());
        if (value) {
          usernameController.clear();
          passwordController.clear();
          if (rememberMe) {
            storage.write("username", usernameController.text);
            storage.write("password", passwordController.text);
          }
          Get.toNamed("/attendance");
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
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Username"),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: isHidden,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    child: Icon(
                      isHidden ? Icons.visibility : Icons.visibility_off,
                    ),
                    onTap: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                  ),
                  label: const Text("Password"),
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
                    const Text("Remember this account?"),
                    Checkbox(
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

                    print("____SAVED____");
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

                      Get.toNamed("/attendance");
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
                child: const Text("Login"),
              ),
              const Spacer(),
              const Text(
                "Made with ❤️ by Aditya Tripathi",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
