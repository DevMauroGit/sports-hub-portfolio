// ignore_for_file: unused_catch_clause

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/page/signup_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Container(
          decoration: BoxDecoration(
            color: kBackgroundColor2,
            image: DecorationImage(
              image: const AssetImage("assets/images/sports_background1.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  kBackgroundColor2.withOpacity(0.3), BlendMode.dstATop),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _page(context, h, w),
          ),
        ));
  }

  Widget _page(context, h, w) {
    //Size size = MediaQuery.of(context).size;

    var emailController = TextEditingController();

    return Stack(children: [
      Positioned(
        bottom: 0,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              width: w,
              height: h > 700 ? h * 0.70 : h * 0.85,
              //height: h > 700 ? h * 0.65 : h * 0.78,
              margin: EdgeInsets.only(top: h * 0.15),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Colors.white),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: h,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          "Inserisci la tua email per resettare la password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: w > 405 ? 30 : 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Controlla la tua casella di posta, ti invieremo i link necesari",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: w > 405 ? 30 : 12,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 7,
                                    offset: const Offset(1, 1),
                                    color: Colors.grey.withOpacity(0.2))
                              ]),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: w > 405 ? 28 : 13),
                            decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon: const Icon(Icons.email,
                                    color: Colors.deepOrangeAccent),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? 'Inserisci una Email valida'
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 7,
                                    offset: const Offset(1, 1),
                                    color: Colors.grey.withOpacity(0.2))
                              ]),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBackgroundColor2,
                            textStyle: const TextStyle(fontSize: 15),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            final String email = emailController.text.trim();

                            if (email.isNotEmpty &&
                                EmailValidator.validate(email)) {
                              resetPassword(email);
                            } else {
                              Get.snackbar('', "",
                                  snackPosition: SnackPosition.TOP,
                                  titleText: Text(
                                    'Email inserita non corretta',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                        fontSize: w > 405 ? 15 : 11),
                                  ),
                                  messageText: Text(
                                    'questa email non è registrata',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                        fontSize: w > 405 ? 15 : 11),
                                  ),
                                  duration: const Duration(seconds: 4),
                                  backgroundColor:
                                      Colors.redAccent.withOpacity(0.6),
                                  colorText: Colors.black);
                            }
                          },
                          child: Text(
                            "Cambia Password",
                            style: TextStyle(
                                color: kBackgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: w > 405 ? 18 : 15,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const SignUpPage())));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: h * 0.01),
                            alignment: Alignment.center,
                            child: RichText(
                                text: const TextSpan(
                                    text: "Non hai un account?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                    children: [
                                  TextSpan(
                                      text: " REGISTRATI",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                ])),
                          ),
                        ),
                      ]),
                ),
              )),
        ),
      ),
    ]);
  }

  Future resetPassword(String emailController) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController)
          .catchError((error, StackTrace) {
        Get.snackbar('', "",
            snackPosition: SnackPosition.TOP,
            titleText: const Text(
              'Accesso non riuscito',
              style: TextStyle(
                  fontWeight: FontWeight.w800, letterSpacing: 1, fontSize: 15),
            ),
            messageText: const Text(
              'credenziali errate',
              style: TextStyle(
                  fontWeight: FontWeight.w800, letterSpacing: 1, fontSize: 15),
            ),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.redAccent.withOpacity(0.6),
            colorText: Colors.black);
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar('', "",
          snackPosition: SnackPosition.TOP,
          titleText: const Text(
            'Email non Registrata',
            style: TextStyle(
                fontWeight: FontWeight.w800, letterSpacing: 1, fontSize: 15),
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.redAccent.withOpacity(0.6),
          colorText: Colors.black);
    }
    Navigator.pop(context);
  }
}
