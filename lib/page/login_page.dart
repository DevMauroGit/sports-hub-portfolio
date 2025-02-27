import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/auth_controller.dart';
import 'package:sports_hub_ios/page/reset_password_page.dart';
import 'package:sports_hub_ios/page/signup_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool isLoading = false;

class _LoginPageState extends State<LoginPage> {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            body: _page(context),
            //Stack(children: [
            //  Positioned(top: 80, child: _buildTop()),
            //  Positioned(bottom: 0, child: _buildBottom()),
          ),
        ));
  }

  Widget _page(context) {
    //Size size = MediaQuery.of(context).size;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Stack(children: [
      Positioned(
        bottom: 0,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              width: w,
              height: h > 700 ? h * 0.70 : h * 0.85,
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Colors.white),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: h * 1.2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: h * 0.04),
                        Text(
                          "BENTORNATO",
                          style: TextStyle(
                            fontSize: w > 385 ? 30 : 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: h * 0.02),
                        Text(
                          "accedi al tuo account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: w > 385 ? 25 : 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: h * 0.06),
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
                                fontSize: w > 385 ? 16 : 13),
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
                        SizedBox(height: h * 0.02),
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
                        SizedBox(height: h * 0.03),
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
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: w > 385 ? 16 : 13),
                            decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: const Icon(Icons.password_outlined,
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
                            validator: (value) => value != null &&
                                    value.length < 6
                                ? 'Inserisci una password di almeno 6 caratteri'
                                : null,
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBackgroundColor2,
                            textStyle: const TextStyle(fontSize: 15),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });

                            final String email = emailController.text.trim();
                            final String password =
                                passwordController.text.trim();

                            AuthController.instance
                                .login(email, password, context, w);
                          },
                          child: isLoading
                              ? Container(
                                  height: 25,
                                  width: 75,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      )))
                              : Container(
                                  height: 25,
                                  width: 85,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ACCEDI",
                                    style: TextStyle(
                                        color: kBackgroundColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: w > 385 ? 12 : 10,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                            onTap: () {
                              Get.to(() => ResetPasswordPage(),
                                  transition: Transition.downToUp);
                            },
                            child: Container(
                                margin: EdgeInsets.only(bottom: h * 0.01),
                                alignment: Alignment.center,
                                child: const Text('Password Dimenticata?',
                                    style: TextStyle(
                                      color: kBackgroundColor2,
                                      fontSize: 17,
                                    )))),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SignUpPage(),
                                transition: Transition.downToUp);
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
}
