import 'package:crud_app/app/screens/auth/controller/controller_auth.dart';
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
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          labelText: "Mobile Number",
                          suffixIcon: IconButton(
                            onPressed: () =>
                                authController.internationalCodeEdit.toggle(),
                            icon: const Icon(Icons.phone_outlined),
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            // padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            width: 15,
                            decoration: const BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            child: TextField(
                              cursorColor: Colors.white,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              controller: authController.internationalCode,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              readOnly:
                                  authController.internationalCodeEdit.value,
                            ),
                          ),
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
                          RegExp pattern =
                              RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');

                          if (value != null && value.isNotEmpty) {
                            if (value.length != 10 &&
                                !pattern.hasMatch(value)) {
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
                  Obx(
                    () => Align(
                      child: ElevatedButton(
                        onPressed: authController.verifyPhone,
                        child: authController.verifyPhoneLoader.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text("CONTINUE"),
                        style: ElevatedButton.styleFrom(
                          shape: authController.verifyPhoneLoader.value
                              ? const CircleBorder()
                              : RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                          fixedSize: authController.verifyCodeLoader.value
                              ? const Size.fromRadius(22)
                              : Size.fromWidth(Get.width / 3),
                        ),
                      ),
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () => Get.to(() => const HomePage()),
                  //   child: const Text('Skip'),
                  // ),
                ],
              ),
            ),
          );
        });
  }
}
