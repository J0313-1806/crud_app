import 'package:crud_app/app/screens/auth/controller/controller_auth.dart';
import 'package:crud_app/app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authController) {
          return Scaffold(
            backgroundColor: Colors.deepPurple.shade50,
            body: Form(
              key: authController.formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 150, 10, 50),
                    child: const Text(
                      "Continue with Phone",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    child: SizedBox(
                      width: Get.width - 40,
                      child: TextFormField(
                        controller: authController.phone,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter(
                        //     RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)'),
                        //     allow: true,
                        //   ),
                        // ],
                        decoration: InputDecoration(
                          labelText: "Mobile Number",
                          suffixIcon: const Icon(Icons.phone_outlined),
                          prefixIcon: IconButton(
                              onPressed: () {}, icon: const Text('+91')),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black54,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (value.length != 10) {
                              return "Incorrect Number";
                            } else {
                              return null;
                            }
                          } else {
                            return "Field cannot be Empty!";
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    child: ElevatedButton(
                      onPressed: authController.verifyPhone,
                      child: const Text("CONTINUE"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fixedSize: Size.fromWidth(Get.width / 3),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => const HomePage()),
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
