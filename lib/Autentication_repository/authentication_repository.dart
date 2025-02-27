import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  var verificationId = ''.obs;

  Future sendVerificationMessage(w, phoneNumber) async {
    await FirebaseAuth.instance.setLanguageCode("it");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+39 $phoneNumber',
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          if (e.code == 'Invalid-phone-number') {
            Get.snackbar('', "",
                snackPosition: SnackPosition.TOP,
                titleText: Text(
                  'Inserisci un Numero di telefono valido',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    fontSize: w < 380
                        ? 13
                        : w > 605
                            ? 18
                            : 15,
                  ),
                ),
                duration: const Duration(seconds: 4),
                backgroundColor: Colors.redAccent.withOpacity(0.6),
                colorText: Colors.black);
          }
        },
        codeSent: (verificationId, resendToken) {
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        });
  }

  Future verifyOTP(String otp) async {
    print(verificationId.value);
    var credentials = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }
}
