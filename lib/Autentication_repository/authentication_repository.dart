import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Repository responsible for handling phone number authentication
/// using Firebase Authentication and GetX for state management and UI feedback.
class AuthenticationRepository extends GetxController {
  /// Singleton access to the repository instance using GetX
  static AuthenticationRepository get instance => Get.find();

  /// Stores the verification ID needed for OTP confirmation
  var verificationId = ''.obs;

  /// Sends a verification code (OTP) to the given phone number
  ///
  /// [w] is the screen width, used for responsive text sizing in the snackbar
  /// [phoneNumber] should be a string without the country code (Italian numbers assumed)
  Future sendVerificationMessage(w, phoneNumber) async {
    await FirebaseAuth.instance.setLanguageCode("it");

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+39 $phoneNumber',

      // Automatically called if verification is completed (e.g., auto-read SMS on Android)
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },

      // Called if verification fails (e.g., invalid phone number)
      verificationFailed: (e) {
        if (e.code == 'Invalid-phone-number') {
          Get.snackbar(
            '',
            '',
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
            colorText: Colors.black,
          );
        }
      },

      // Called when the verification code has been successfully sent
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },

      // Called if the automatic code retrieval times out
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
    );
  }

  /// Verifies the OTP entered by the user
  ///
  /// Returns `true` if authentication succeeds, otherwise `false`
  Future verifyOTP(String otp) async {
    print(verificationId.value);

    var credentials = await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      ),
    );

    return credentials.user != null ? true : false;
  }
}
