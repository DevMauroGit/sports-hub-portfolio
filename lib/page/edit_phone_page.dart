import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/profile_controller.dart';
import 'package:sports_hub_ios/models/phone_model.dart';
import 'package:sports_hub_ios/models/user_model.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/signup_page.dart';
import 'package:sports_hub_ios/page/verify_phone_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class EditNumberPage extends StatefulWidget {
  const EditNumberPage(
      {super.key, required this.h, required this.w, required this.size});

  final double h;
  final double w;
  final Size size;

  @override
  State<EditNumberPage> createState() => _EditNumberPageState();
}

final formKey = GlobalKey<FormState>();
bool isLoading = false;

class _EditNumberPageState extends State<EditNumberPage> {
  var phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection(('User'));
    final controller = Get.put(ProfileController());

    return PopScope(
        canPop: true,
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.2)),
            child: Scaffold(
                appBar: TopBar(),
                body: Stack(children: [
                  SingleChildScrollView(
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          //height: h*0.8,
                          width: widget.w * 0.95,
                          child: Column(children: [
                            SizedBox(
                                width: widget.w * 0.8,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Nuovo Numero di Telefono',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize:
                                                  widget.w > 380 ? 19 : 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      SizedBox(height: widget.h * 0.01),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: phoneNumberController,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                            hintText: '',
                                            prefixIcon: const Icon(Icons.phone,
                                                color: kPrimaryColor),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1.0)),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1.0)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (phoneNumber) =>
                                            phoneNumber != null &&
                                                    phoneNumber.length < 9
                                                ? 'Inserisci un numero valido'
                                                : phoneNumber != null &&
                                                        phoneNumber.length > 11
                                                    ? 'Inserisci un numero valido'
                                                    : null,
                                      ),
                                      const SizedBox(height: 20),
                                      FutureBuilder<DocumentSnapshot>(
                                          future: user.doc(docIds.first).get(),
                                          builder: (((context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              Map<String, dynamic> profile =
                                                  snapshot.data!.data()
                                                      as Map<String, dynamic>;

                                              return Center(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          widget.w * 0.2),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          kBackgroundColor2,
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15),
                                                      shape:
                                                          const StadiumBorder(),
                                                    ),
                                                    onPressed: () async {
                                                      getAllPhone();

                                                      String phoneNumber =
                                                          phoneNumberController
                                                              .text
                                                              .trim();

                                                      int c = 0;
                                                      for (int i = 0;
                                                          i < allPhone.length;
                                                          i++) {
                                                        //print(allPhone[i].phoneNumber.toString());
                                                        phoneNumber !=
                                                                allPhone[i]
                                                                    .phoneNumber
                                                            ? c++
                                                            : null;
                                                      }

                                                      if (phoneNumberController
                                                                  .text
                                                                  .trim()
                                                                  .length >
                                                              8 &&
                                                          phoneNumberController
                                                                  .text
                                                                  .trim()
                                                                  .length <
                                                              12) {
                                                        phoneNumber =
                                                            phoneNumberController
                                                                .text
                                                                .trim();
                                                      } else {
                                                        phoneNumber = profile[
                                                            'phoneNumber'];
                                                      }

                                                      UserModel userData =
                                                          UserModel(
                                                        username:
                                                            profile['username'],
                                                        id: profile['id'],
                                                        email: profile['email'],
                                                        phoneNumber:
                                                            phoneNumber,
                                                        city: profile['city'],
                                                        password:
                                                            profile['password'],
                                                        profile_pic:
                                                            'https://firebasestorage.googleapis.com/v0/b/sports-hub-2710.appspot.com/o/utility_images%2Ffootballer.png?alt=media&token=9339bbc1-047c-4309-9509-9d643554daca',
                                                        cover_pic:
                                                            'https://firebasestorage.googleapis.com/v0/b/sports-hub-2710.appspot.com/o/utility_images%2Fstadium_black.jpg?alt=media&token=ac177528-62f5-4c35-a823-78d106364583',
                                                        isEmailVerified: true,
                                                        games: profile['games'],
                                                        goals: profile['goals'],
                                                        win: profile['win'],
                                                        games_tennis: profile[
                                                            'games_tennis'],
                                                        set_vinti: profile[
                                                            'set_vinti'],
                                                        win_tennis: profile[
                                                            'win_tennis'],
                                                        prenotazioni: profile[
                                                            'prenotazioni'],
                                                        prenotazioniPremium:
                                                            profile[
                                                                'prenotazioniPremium'],
                                                        token: profile['token'],
                                                      );
                                                      //print('final: $profile_pic');
                                                      if (8 <
                                                              phoneNumberController
                                                                  .text
                                                                  .trim()
                                                                  .length &&
                                                          phoneNumberController
                                                                  .text
                                                                  .trim()
                                                                  .length <
                                                              12) {
                                                        //print(c);
                                                        //print(allPhone.length);

                                                        if (c ==
                                                            allPhone.length) {
                                                          setState(() {
                                                            isLoading = true;
                                                          });

                                                          await controller
                                                              .updateUser(
                                                                  userData);

                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          VerifyPhonePage(
                                                                            h: widget.h,
                                                                            w: widget.w,
                                                                            size:
                                                                                widget.size,
                                                                          )));
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        } else {
                                                          Get.snackbar('', "",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .TOP,
                                                              titleText: Text(
                                                                'Numero di telefono già registrato',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize: widget
                                                                              .w <
                                                                          380
                                                                      ? 13
                                                                      : widget.w >
                                                                              605
                                                                          ? 18
                                                                          : 15,
                                                                ),
                                                              ),
                                                              messageText: Text(
                                                                'Prova ad accedere',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize: widget
                                                                              .w <
                                                                          380
                                                                      ? 13
                                                                      : widget.w >
                                                                              605
                                                                          ? 18
                                                                          : 15,
                                                                ),
                                                              ),
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          4),
                                                              backgroundColor:
                                                                  Colors
                                                                      .redAccent
                                                                      .withOpacity(
                                                                          0.6),
                                                              colorText:
                                                                  Colors.black);
                                                          setState(() {
                                                            isLoadingS = false;
                                                          });
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        }
                                                      } else {
                                                        Get.snackbar('', "",
                                                            snackPosition:
                                                                SnackPosition
                                                                    .TOP,
                                                            titleText: Text(
                                                              'Inserisci un numero di telefono valido',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: widget
                                                                            .w <
                                                                        380
                                                                    ? 13
                                                                    : widget.w >
                                                                            605
                                                                        ? 18
                                                                        : 15,
                                                              ),
                                                            ),
                                                            messageText: Text(
                                                              '',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: widget
                                                                            .w <
                                                                        380
                                                                    ? 13
                                                                    : widget.w >
                                                                            605
                                                                        ? 18
                                                                        : 15,
                                                              ),
                                                            ),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 4),
                                                            backgroundColor:
                                                                Colors.redAccent
                                                                    .withOpacity(
                                                                        0.6),
                                                            colorText:
                                                                Colors.black);
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      }
                                                    },
                                                    child: isLoading
                                                        ? Container(
                                                            height: 15,
                                                            width: 80,
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            child: const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                                strokeWidth:
                                                                    1.5,
                                                              ),
                                                            ),
                                                          )
                                                        : const Text(
                                                            "SALVA",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container();
                                          }))),
                                    ]))
                          ])))
                ]))));
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

Future<void> getAllPhone() async {
  try {
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection('Phone').get();
    final teammateList =
        data.docs.map((friends) => PhoneModel.fromSnapshot(friends)).toList();
    allPhone.assignAll(teammateList);
  } catch (e) {}
}
