import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_close_app/flutter_close_app.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sports_hub_ios/Autentication_repository/authentication_repository.dart';
import 'package:sports_hub_ios/controllers/auth_controller.dart';
import 'package:sports_hub_ios/controllers/otp_controller.dart';
import 'package:sports_hub_ios/cubit/auth_cubit.dart';
import 'package:sports_hub_ios/page/admin_page.dart';
import 'package:sports_hub_ios/page/edit_phone_page.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/login_page.dart';
import 'package:sports_hub_ios/utils/app_icon.dart';
import 'package:sports_hub_ios/widgets/header.dart';

import '../Utils/constants.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  const VerifyPhoneNumberPage({
    super.key,
    required this.profile,
    required this.h,
    required this.w,
    required this.size,
  });

  final Map profile;
  final double h;
  final double w;
  final Size size;

  @override
  State<VerifyPhoneNumberPage> createState() => _VerifyPhoneNumberPageState();
}

class _VerifyPhoneNumberPageState extends State<VerifyPhoneNumberPage> {
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isEmailVerified = false;

  final formKey = GlobalKey<FormState>();

  var verificationId = 'test'.obs;

  bool isLoading = false;
  bool isVerifing = false;
  bool isVerified = false;

  Future sendVerificationMessage(w, phoneNumber) async {
    await FirebaseAuth.instance.setLanguageCode("it");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+1 $phoneNumber',
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
          Navigator.pop(context);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        });
  }

  Future verifyOTP(String otp, profile, double w) async {
    print(verificationId);

    try {
      // ignore: unused_local_variable
      var credentials = await FirebaseAuth.instance.currentUser!
          .linkWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationId.value, smsCode: otp))
          .whenComplete(() async {
        await AuthController.instance
            .createPhoneVerified(profile)
            .whenComplete(() {
          setState(() {
            isVerifing == false;
          });

          if (FirebaseAuth.instance.currentUser!.phoneNumber.toString().length >
              7) {
            Get.offAll(() => HomePage());
          } else {
            Get.snackbar('', "",
                snackPosition: SnackPosition.TOP,
                titleText: Text(
                  'Codice inserito non corretto o scaduto',
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
        });
      });
      //credentials.user != null ?  true : false;
    } catch (e) {}
  }

  Widget buildEditIcon(Color color, double w) => CircleAvatar(
        radius: w > 605 ? 18 : 14,
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.edit,
          size: w > 605 ? 25 : 20,
          color: color,
        ),
      );

  String text = "";

  onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  @override
  Widget build(BuildContext context) {
    //sendVerificationEmail();

    Get.lazyPut(() => OTPController());

    Get.put(AuthenticationRepository());

    var otp;
    final user = FirebaseAuth.instance.currentUser!;

    print('verify phone number');
    
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: user.email!.contains('admin')
            ? AdminPage(
                day: DateTime.now(),
              )
            : Scaffold(
                //appBar: buildAppBar(context),
                body: SizedBox(
                    child: SingleChildScrollView(
                controller: scrollController,
                child: Column(children: <Widget>[
                  Header(
                    size: widget.size,
                    phone: true,
                    mail: false,
                  ),
                  Container(
                      margin:
                          const EdgeInsets.only(left: 30, right: 30, top: 20),
                      width: widget.w,
                      height: widget.h > 705 ? widget.h * 1.3 : widget.h * 1.5,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Clicca qui per ricevere un\nSMS di verifica a:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 20
                                    : widget.w > 385
                                        ? 16
                                        : 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${widget.profile['phoneNumber']}",
                                    style: TextStyle(
                                      fontSize: widget.w > 385 ? 23 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                      onTap: () {},
                                      child: GestureDetector(
                                          onTap: () {
                                            context.go('/edit-number',
                                            extra: {
                                              'h': widget.h,
                                              'w': widget.w,
                                              'size': widget.size,
                                            }
                                            );
                                          },
                                          child: buildEditIcon(
                                              kBackgroundColor2, widget.w)))
                                ],
                              ),
                            ),

                            SizedBox(height: widget.w > 385 ? 25 : 15),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kSecondaryColor,
                                  minimumSize: const Size.fromHeight(50)),
                              icon: const Icon(
                                Icons.email,
                                size: 32,
                                color: kPrimaryColor,
                              ),
                              label: isLoading
                                  ? Container(
                                      height: 32,
                                      width: 32,
                                      padding: EdgeInsets.all(5),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ))
                                  : Text(
                                      'Richiedi SMS di verifica',
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: widget.w > 605
                                              ? 16
                                              : widget.w > 385
                                                  ? 14
                                                  : 10),
                                    ),
                              onPressed: (() async {
                                setState(() {
                                  isLoading = true;
                                });

                                //sendVerificationMessage(w, widget.profile['phoneNumber']);

                                await FirebaseAuth.instance
                                    .setLanguageCode("it");
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber:
                                      '+39 ${widget.profile['phoneNumber']}',
                                  verificationCompleted: (credential) async {
                                    setState(() {
                                      //this.verificationId = verificationId;
                                      isLoading = false;
                                    });

                                    //await FirebaseAuth.instance.signInWithCredential(credential);
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
                                              fontSize: widget.w < 380
                                                  ? 13
                                                  : widget.w > 605
                                                      ? 18
                                                      : 15,
                                            ),
                                          ),
                                          duration: const Duration(seconds: 4),
                                          backgroundColor:
                                              Colors.redAccent.withOpacity(0.6),
                                          colorText: Colors.black);
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });

                                    print('${e.credential}${e.phoneNumber}');

                                    Get.snackbar('', "",
                                        snackPosition: SnackPosition.TOP,
                                        titleText: Text(
                                          e.code,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1,
                                            fontSize: widget.w < 380
                                                ? 13
                                                : widget.w > 605
                                                    ? 18
                                                    : 15,
                                          ),
                                        ),
                                        duration: const Duration(seconds: 4),
                                        backgroundColor:
                                            Colors.redAccent.withOpacity(0.6),
                                        colorText: Colors.black);
                                  },
                                  codeSent: (verificationId, resendToken) {
                                    setState(() {
                                      this.verificationId.value =
                                          verificationId;
                                      isLoading = false;
                                    });
                                  },
                                  codeAutoRetrievalTimeout: (verificationId) {
                                    this.verificationId.value = verificationId;
                                  },
                                );
                              }),
                            ),
                            SizedBox(height: widget.w > 385 ? 15 : 10),
                            Text(
                              "Inserisci il codice e verifica il tuo numero",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 18
                                    : widget.w > 385
                                        ? 18
                                        : 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: widget.w > 385 ? 25 : 15),
                            Text(text,
            style: const TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
        SizedBox(height: widget.h * 0.02),
        NumericKeyboard(
            onKeyboardTap: onKeyboardTap,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
            rightButtonFn: () {
              if (text.isEmpty) return;
              setState(() {
                text = text.substring(0, text.length - 1);
              });
            },
            rightButtonLongPressFn: () {
              if (text.isEmpty) return;
              setState(() {
                text = '';
              });
            },
            rightIcon: const Icon(
              Icons.backspace_outlined,
              color: Colors.blueGrey,
            ),
            mainAxisAlignment: MainAxisAlignment.spaceBetween),

                            SizedBox(height: 15),

                            Container(
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kBackgroundColor2,
                                  textStyle: TextStyle(
                                      fontSize: widget.w > 385 ? 20 : 16),
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isVerifing = true;
                                    otp = text;
                                  });

                                  verifyOTP(otp, widget.profile, widget.w)
                                      .whenComplete(() => setState(() {
                                            isVerifing = false;
                                          }));
                                },
                                child: isVerifing
                                    ? Container(
                                        height: 50,
                                        width: 100,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ))
                                    : Container(
                                        height: 50,
                                        width: 100,
                                        padding: EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Verifica",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.w > 605
                                                ? 16
                                                : widget.w > 385
                                                    ? 14
                                                    : 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 50),
                            AnimatedButton(
                              isFixedHeight: false,
                              height: 50,
                              width: 150,
                              text: "LogOut",
                              buttonTextStyle: TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.black,
                                  fontSize: widget.w > 605
                                      ? 16
                                      : widget.w > 385
                                          ? 14
                                          : 10,
                                  fontWeight: FontWeight.bold),
                              color: kPrimaryColor,
                              pressEvent: () {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.topSlide,
                                        showCloseIcon: true,
                                        title: "Attento",
                                        titleTextStyle: TextStyle(
                                            fontSize: widget.w > 605
                                                ? 20
                                                : widget.w > 385
                                                    ? 18
                                                    : 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                        desc: "Sei sicuro di voler uscire?",
                                        descTextStyle: TextStyle(
                                            fontSize: widget.w > 605
                                                ? 20
                                                : widget.w > 385
                                                    ? 18
                                                    : 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                        btnOkOnPress: () async {
                                          FirebaseAuth.instance.signOut();
                                          //                FlutterExitApp.exitApp(iosForceExit: true);
                                          Future.delayed(const Duration(
                                                  milliseconds: 355))
                                              .then((value) =>
                                                      FlutterCloseApp.close()
                                                  //SystemNavigator.pop()
                                                  );
                                        },
                                        btnOkIcon: Icons.thumb_up,
                                        btnOkText: "DISCONNETTITI",
                                        btnOkColor: kBackgroundColor2)
                                    .show();
                              },
                            ),

                            Container(
                              height: widget.h > 700
                                  ? widget.h * 0.04
                                  : widget.h * 0.06,
                            ),

                            //       Text('id:${verificationId.value}'),
                            //    Text('cred user: $isVerified')
                          ])),
                ]),
              ))));
  }
}

AppBar buildAppBar(context) {
  return AppBar(
      elevation: 0,
      backgroundColor: kBackgroundColor2,
      leading: Builder(builder: (BuildContext context) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const AppIcon(icon: Icons.arrow_back_ios)),
        ]);
      }));
}
