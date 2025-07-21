import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sports_hub_ios/cubit/auth_cubit.dart';
import 'package:sports_hub_ios/page/admin_page.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/login_page.dart';
import 'package:sports_hub_ios/utils/app_icon.dart';
import 'package:sports_hub_ios/widgets/header.dart';

import '../Utils/constants.dart';

/// Displays a screen prompting the user to verify their email address.
/// If the user is an admin or already verified, they are redirected.
class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Could optionally trigger email verification on init
  }

  /// Reloads current user and checks if email is verified
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }

  /// Sends a verification email to the current user
  Future sendVerificationEmail() async {
    setState(() {
      isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseAuth.instance.setLanguageCode("it");
    await user.sendEmailVerification().whenComplete(() => setState(() {
          isLoading = false;
        }));
  }

  /// Holds phone verification ID used for OTP authentication
  var verificationId = ''.obs;

  /// Sends phone number verification message (SMS)
  Future sendVerificationMessage(w) async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseAuth.instance.setLanguageCode("it");
    await FirebaseAuth.instance.verifyPhoneNumber(
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        if (e.code == 'Invalid-phone-number') {
          Get.snackbar(
            '',
            "",
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
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
    );
  }

  /// Verifies OTP code entered by the user
  Future verifyOTP(String otp) async {
    var credentials = await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      ),
    );
    return credentials.user != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double w = size.width;
    double h = size.height;
    final user = FirebaseAuth.instance.currentUser!;

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: user.email!.contains('admin')
          ? AdminPage(day: DateTime.now())
          : isEmailVerified
              ? const HomePage()
              : PopScope(
                  canPop: false,
                  child: Scaffold(
                    appBar: buildAppBar(context),
                    body: SizedBox(
                      height: h,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Header(
                              size: size,
                              phone: false,
                              mail: true,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 30, right: 30, top: 20),
                              width: w,
                              height: h * 0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clicca qui per ricevere la richiesta di verifica a: ${user.email}",
                                    style: TextStyle(
                                      fontSize: w > 355 ? 23 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: w > 355 ? 15 : 10),
                                  Text(
                                    "Conferma la registrazione e accedi al tuo nuovo account!",
                                    style: TextStyle(
                                      fontSize: w > 355 ? 18 : 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: w > 355 ? 25 : 15),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kSecondaryColor,
                                      minimumSize: const Size.fromHeight(50),
                                    ),
                                    icon: const Icon(
                                      Icons.email,
                                      size: 32,
                                      color: kPrimaryColor,
                                    ),
                                    label: isLoading
                                        ? Container(
                                            padding: const EdgeInsets.all(10),
                                            child:
                                                const CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            'Invia mail di verifica',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: w > 355 ? 24 : 15,
                                            ),
                                          ),
                                    onPressed: sendVerificationEmail,
                                  ),
                                  SizedBox(height: w > 355 ? 25 : 15),
                                  Text(
                                    "Se una volta cliccato non trovi la mail prova a cercarla nella casella di posta indesiderata. Le mail più datate potrebbero non essere supportate.",
                                    style: TextStyle(
                                      fontSize: w > 355 ? 16 : 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 15),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kBackgroundColor2,
                                        textStyle: TextStyle(
                                            fontSize: w > 355 ? 20 : 16),
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed: () async =>
                                          context.go('/login'),
                                      child: Text(
                                        "\n     Torna al Login     \n",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: w > 355 ? 20 : 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}

/// Builds a custom app bar with a back button leading to login page
AppBar buildAppBar(context) {
  return AppBar(
    elevation: 0,
    backgroundColor: kBackgroundColor2,
    leading: Builder(
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const AppIcon(icon: Icons.arrow_back_ios),
            ),
          ],
        );
      },
    ),
  );
}
