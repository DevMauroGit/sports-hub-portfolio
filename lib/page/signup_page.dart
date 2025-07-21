import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/auth_controller.dart';
import 'package:sports_hub_ios/models/phone_model.dart';
import 'package:sports_hub_ios/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:sports_hub_ios/utils/constants.dart';

const List<String> list = <String>[
  'Città o provincia',
  'Pavia',
  'Milano',
  'Lodi'
];

String newPassword = '';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

final formKey = GlobalKey<FormState>();

bool isLoadingS = false;

final allPhone = <PhoneModel>[].obs;
final allUser = <UserModel>[].obs;

class _SignUpPageState extends State<SignUpPage> {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cityController = TextEditingController();
  var phoneController = TextEditingController();

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  Future<void> getAllPhone() async {
    try {
      QuerySnapshot<Map<String, dynamic>> data =
          await FirebaseFirestore.instance.collection('Phone').get();
      final teammateList =
          data.docs.map((friends) => PhoneModel.fromSnapshot(friends)).toList();
      allPhone.assignAll(teammateList);
    } catch (e) {}
  }

  Future<void> getAllUser() async {
    try {
      QuerySnapshot<Map<String, dynamic>> data =
          await FirebaseFirestore.instance.collection('User').get();
      final teammateList =
          data.docs.map((friends) => UserModel.fromSnapshot(friends)).toList();
      allUser.assignAll(teammateList);
    } catch (e) {}
  }

  String dropdownValue = 'Città o provincia';

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.1)),
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
            resizeToAvoidBottomInset: false,
            body: Stack(children: [
      Positioned(
        bottom: 0,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              width: w,
              height: h > 700 ? h * 0.80 : h * 0.90,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                        SizedBox(
                          height: h * 0.01,
                        ),
                        Text(
                          "Inserisci i tuoi dati",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: w > 355 ? 25 : 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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
                            inputFormatters: <TextInputFormatter>[
                              UpperCaseTextFormatter()
                            ],
                            controller: usernameController,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: w > 355 ? 16 : 13),
                            decoration: InputDecoration(
                                hintText: "Username",
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.deepOrangeAccent),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 1.0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (username) => username != null &&
                                    username.length < 4
                                ? 'Il tuo Username deve essere di almeno 4 lettere'
                                : username != null && username.length > 10
                                    ? 'Il tuo Username deve essere di massimo 10 lettere'
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                fontSize: w > 355 ? 16 : 13),
                            decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon: const Icon(Icons.email,
                                    color: Colors.deepOrangeAccent),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 1.0)),
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
                        const SizedBox(height: 20),
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
                            inputFormatters: <TextInputFormatter>[
                              UpperCaseTextFormatter()
                            ],
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: w > 355 ? 16 : 13),
                            decoration: InputDecoration(
                                hintText: "Numero di telefono",
                                prefixIcon: const Icon(Icons.phone,
                                    color: Colors.deepOrangeAccent),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 1.0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null &&
                                    value.length < 9 &&
                                    value.length > 11
                                ? 'Inserisci una numero di telefono valido'
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 300,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_city,
                                color: Colors.deepOrangeAccent,
                                size: 30,
                              ),
                              Container(
                                width: w * 0.55,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 8,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: w > 355 ? 16 : 13),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                fontSize: w > 355 ? 16 : 13),
                            decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: const Icon(Icons.password_outlined,
                                    color: Colors.deepOrangeAccent),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 1.0)),
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
                        SizedBox(height: h > 700 ? 30 : 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBackgroundColor2,
                            textStyle: const TextStyle(fontSize: 15),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            setState(() {
                              isLoadingS = true;
                            });

                            getAllPhone();

                            int c = 0;
                            final String username =
                                usernameController.text.trim();
                            final String email = emailController.text.trim();
                            final String password =
                                passwordController.text.trim();
                            final String city = dropdownValue;
                            final String phoneNumber =
                                phoneController.text.trim();

                            for (int i = 0; i < allPhone.length; i++) {
                              phoneNumber != allPhone[i].phoneNumber
                                  ? c++
                                  : null;
                            }
                            newPassword = password;

                            //      for(int i=0; i<allUser.length; i++){
                            //      email != allUser[i].email ? k++ : null;
                            //  }

                            if (3 < username.length && username.length < 11) {
                              if (EmailValidator.validate(email)) {
                                if (dropdownValue.toString().length < 10) {
                                  if (9 <= phoneNumber.toString().length &&
                                      phoneNumber.toString().length <= 11) {
                                    if (c == allPhone.length) {

                                      AuthController.instance.signUp(
                                          email,
                                          password,
                                          username,
                                          phoneNumber,
                                          city,
                                          w);

                                      Future.delayed(Duration(seconds: 5))
                                          .whenComplete(
                                              () => isLoadingS = false);
                                    } else {
                                      Get.snackbar('', "",
                                          snackPosition: SnackPosition.TOP,
                                          titleText: Text(
                                            'Numero di telefono già registrato',
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
                                          messageText: Text(
                                            'Prova ad accedere',
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
                                          backgroundColor:
                                              Colors.redAccent.withOpacity(0.6),
                                          colorText: Colors.black);
                                      setState(() {
                                        isLoadingS = false;
                                      });
                                    }
                                  } else {
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
                                        backgroundColor:
                                            Colors.redAccent.withOpacity(0.6),
                                        colorText: Colors.black);
                                    setState(() {
                                      isLoadingS = false;
                                    });
                                  }
                                } else {
                                  Get.snackbar('', "",
                                      snackPosition: SnackPosition.TOP,
                                      titleText: Text(
                                        'Seleziona la tua Città o provincia',
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
                                      backgroundColor:
                                          Colors.redAccent.withOpacity(0.6),
                                      colorText: Colors.black);
                                  setState(() {
                                    isLoadingS = false;
                                  });
                                }
                              } else {
                                Get.snackbar('', "",
                                    snackPosition: SnackPosition.TOP,
                                    titleText: Text(
                                      'Inserisci un Email valida',
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
                                    backgroundColor:
                                        Colors.redAccent.withOpacity(0.6),
                                    colorText: Colors.black);
                                setState(() {
                                  isLoadingS = false;
                                });
                              }
                            } else {
                              Get.snackbar('', "",
                                  snackPosition: SnackPosition.TOP,
                                  titleText: Text(
                                    'Inserisci un Username valido',
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
                                  backgroundColor:
                                      Colors.redAccent.withOpacity(0.6),
                                  colorText: Colors.black);
                              setState(() {
                                isLoadingS = false;
                              });
                            }
                          },
                          child: isLoadingS
                              ? Container(
                                  height: 25,
                                  width: 120,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5),
                                  child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      )))
                              : Container(
                                  height: 25,
                                  width: 120,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "REGISTRATI",
                                    style: TextStyle(
                                        color: kBackgroundColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: w > 355 ? 12 : 10,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.go('/login');
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: h * 0.02),
                            alignment: Alignment.center,
                            child: RichText(
                                text: const TextSpan(
                                    text: "Hai già un account?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                    children: [
                                  TextSpan(
                                      text: " ACCEDI",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                ])),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            context.go(
                              '/ospite',
                              extra: {
                                'city': 'Pavia',
                                'h': h,
                                'w': w,
                                'page': 'games',
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: h * 0.01),
                            alignment: Alignment.center,
                            child: RichText(
                                text: const TextSpan(
                                    text: "oppure visita come OSPITE",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                    children: [
                                  TextSpan(
                                      text: "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                ])),
                          ),
                        )
                      ]),
                ),
              )),
        ),
      ),
    ]),
          ),
        ));
  }
}



class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
