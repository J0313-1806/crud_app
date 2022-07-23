import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crud_app/app/screens/auth/otp.dart';
import 'package:crud_app/app/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  @override
  onReady() async {
    super.onReady();
    phone.text = "";
    otp.text = "";
    connectionStatus.value = await fetchConnectionStatus();
  }

  final formKey = GlobalKey<FormState>();
  RxBool connectionStatus = RxBool(false);
  TextEditingController phone = TextEditingController();
  TextEditingController otp = TextEditingController();
  RxString verId = RxString('');

  Future<void> verifyPhone() async {
    if (connectionStatus.value) {
      if (formKey.currentState!.validate()) {
        log('phone: ' + phone.text);
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+91' + phone.text,
            verificationCompleted: (PhoneAuthCredential credential) {
              Get.snackbar("Done", "Verification complete!");
            },
            verificationFailed: (FirebaseAuthException e) {
              Get.snackbar("oops!", "Verification Failed!");
            },
            codeSent: (String verficationId, int? resendToken) {
              verId(verficationId);
              Get.snackbar("Code Sent", "Check your SMS");
              Get.to(() => const OtpPage());
            },
            codeAutoRetrievalTimeout: (String codeAutoRetrievalTimeout) {});
      } else {
        Get.snackbar("oops!", "Wrong validation try again");
      }
    } else {
      Get.snackbar("oops!", "No Internet connection");
    }
  }

  Future<void> verifyOtp(String value) async {
    await FirebaseAuth.instance
        .signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verId.value,
        smsCode: value,
      ),
    )
        .whenComplete(() {
      otp.clear();
      Get.off(() => const HomePage());
    });
  }

  static Future<bool> fetchConnectionStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
