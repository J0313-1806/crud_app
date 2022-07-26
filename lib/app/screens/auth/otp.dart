import 'package:crud_app/app/screens/auth/controller/controller_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: Colors.deepPurple.shade50,
        body: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(20, 150, 10, 50),
              child: const Text(
                "Verify your Phone",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Pinput(
              controller: authController.otp,
              keyboardType: TextInputType.number,
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsRetrieverApi,
              length: 6,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              onSubmitted: authController.verifyOtp,
              onCompleted: authController.verifyOtp,
              defaultPinTheme: PinTheme(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      // color: Colors.black,
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Obx(
              () => Align(
                child: ElevatedButton(
                  onPressed: () =>
                      authController.verifyOtp(authController.otp.text),
                  child: authController.verifyCodeLoader.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text("VERIFY"),
                  style: ElevatedButton.styleFrom(
                    shape: authController.verifyCodeLoader.value
                        ? const CircleBorder()
                        : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                    fixedSize: authController.verifyCodeLoader.value
                        ? const Size.fromRadius(22)
                        : Size.fromWidth(Get.width / 3.3),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
