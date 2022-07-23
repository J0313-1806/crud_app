// ignore_for_file: avoid_print

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
    internationalCode.text = '+91';
    connectionStatus.value = await fetchConnectionStatus();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      alreadyAuthenticated(true);
    }
  }

  final formKey = GlobalKey<FormState>();
  RxBool connectionStatus = RxBool(false);
  RxBool alreadyAuthenticated = RxBool(false);
  TextEditingController phone = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController internationalCode = TextEditingController();
  RxBool internationalCodeEdit = RxBool(false);
  RxString verId = RxString('');

  RxBool verifyPhoneLoader = RxBool(false);
  Future<void> verifyPhone() async {
    try {
      verifyPhoneLoader(true);
      if (connectionStatus.value) {
        if (formKey.currentState!.validate()) {
          log('phone: ' + phone.text);
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+' + internationalCode.text + phone.text,
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
            codeAutoRetrievalTimeout: (String codeAutoRetrievalTimeout) {},
          );
        } else {
          Get.snackbar("oops!", "Wrong validation try again");
        }
      } else {
        Get.snackbar("oops!", "No Internet connection");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      verifyPhoneLoader(false);
    }
  }

  RxBool verifyCodeLoader = RxBool(false);
  Future<void> verifyOtp(String value) async {
    try {
      verifyCodeLoader(true);
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
    } catch (e) {
      print(e.toString());
    } finally {
      verifyCodeLoader(true);
    }
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
