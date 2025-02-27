import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/page/comment_page.dart';
import 'package:sports_hub_ios/page/offer_to_play_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Results_Games/score_card.dart';

int counter1 = 0;

class OfferToPlayScreen extends StatefulWidget {
  const OfferToPlayScreen(
      {super.key,
      required this.h,
      required this.w,
      required this.appointment,
      required this.list1});

  final double h;
  final double w;

  final Map appointment;

  final List list1;

  @override
  State<OfferToPlayScreen> createState() => _OfferToPlayScreenState();
}

class _OfferToPlayScreenState extends State<OfferToPlayScreen> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  CollectionReference user = FirebaseFirestore.instance.collection('User');
  final String utente = FirebaseAuth.instance.currentUser!.email.toString();
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  UserController userController = Get.put(UserController());

  var chatController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Map appointmentData = {};
  //List list1 = widget.list1;

  @override
  Widget build(BuildContext context) {
    //Future.delayed(const Duration(milliseconds: 380));

    //   widget.appointment['playerCount1Tot'] == null
    //   ? WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (context) => FootballCreateResultsPage(
    //     appointment: widget.appointment)
    //   )
    //        );
    //      })
    //    : null;

    counter1 = 0;

    return Column(children: [
      Center(
          child: Container(
              height: widget.h > 800
                  ? widget.h * 0.75
                  : widget.h > 700
                      ? widget.h * 0.73
                      : widget.h * 0.72,
              width: widget.w * 0.9,
              margin: const EdgeInsets.only(
                  bottom: kDefaultPadding, top: kDefaultPadding),
              //padding: const EdgeInsets.only(bottom: kDefaultPadding),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: kBackgroundColor2,
              ),
              child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.transparent,
                  body: Column(children: [
                    SizedBox(height: widget.h * 0.02),
                    SizedBox(
                      child: Image.asset("assets/images/tabellone.png"),
                    ),
                    SizedBox(height: widget.h * 0.01),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: widget.w > 605 ? 0 : widget.w * 0.01),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(widget.appointment['club'].toString(),
                                  style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 25
                                          : widget.w > 380
                                              ? 16
                                              : 11,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500)),
                              Text(widget.appointment['campo'].toString(),
                                  style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 25
                                          : widget.w > 380
                                              ? 16
                                              : 11,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          SizedBox(height: widget.h * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(widget.appointment['date'].toString(),
                                  style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 25
                                          : widget.w > 380
                                              ? 16
                                              : 11,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500)),
                              Text(widget.appointment['time'].toString(),
                                  style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 25
                                          : widget.w > 380
                                              ? 16
                                              : 11,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          SizedBox(height: widget.h * 0.015),
                          Container(
                            height: widget.h > 700
                                ? widget.h * 0.5
                                : widget.h * 0.45,
                            width: widget.w * 0.85,
                            color: kBackgroundColor2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    ScoreSearchCardP1(
                                      user: widget.appointment['email'],
                                      team: 1,
                                    ),
                                    if (widget.appointment['playerCount1Tot'] >
                                        1)
                                      Container(
                                        height: widget.appointment[
                                                    'playerCount1Tot'] ==
                                                1
                                            ? 0
                                            : widget.appointment[
                                                        'playerCount1Tot'] ==
                                                    2
                                                ? widget.h * 0.1
                                                : widget.appointment[
                                                            'playerCount1Tot'] ==
                                                        3
                                                    ? widget.h * 0.1 * (2)
                                                    : widget.h * 0.1 * (3),
                                        width: widget.w > 385
                                            ? widget.w * 0.35
                                            : widget.w * 0.38,
                                        child: ListView.builder(
                                            itemCount: widget.appointment[
                                                    'playerCount1Tot'] -
                                                1,
                                            itemBuilder: (
                                              BuildContext context,
                                              index,
                                            ) =>
                                                ScoreSearchCard1(
                                                  user: widget.appointment[
                                                      'team1_P${index + 2}'],
                                                  appointment:
                                                      widget.appointment,
                                                )),
                                      ),
                                  ],
                                ),
                                Container(
                                  height: widget.h > 800
                                      ? widget.h * 0.6
                                      : widget.h > 700
                                          ? widget.h * 0.63
                                          : widget.h * 0.65,
                                  width: 1,
                                  color: Colors.white,
                                ),
                                Column(
                                  children: [
                                    if (widget.appointment['playerCount2Tot'] !=
                                        0)
                                      Container(
                                        height: widget.appointment[
                                                    'playerCount2Tot'] ==
                                                1
                                            ? widget.h * 0.1
                                            : widget.appointment[
                                                        'playerCount2Tot'] ==
                                                    2
                                                ? widget.h * 0.1 * 2
                                                : widget.appointment[
                                                            'playerCount2Tot'] ==
                                                        3
                                                    ? widget.h * 0.1 * (3)
                                                    : widget.h * 0.1 * (4),
                                        width: widget.w > 385
                                            ? widget.w * 0.35
                                            : widget.w * 0.38,
                                        child: ListView.builder(
                                            itemCount: widget
                                                .appointment['playerCount2Tot'],
                                            itemBuilder: (
                                              BuildContext context,
                                              index,
                                            ) =>
                                                Column(
                                                  children: [
                                                    ScoreSearchCard(
                                                      user: widget.appointment[
                                                          'team2_P${index + 1}'],
                                                      appointment:
                                                          widget.appointment,
                                                    ),
                                                  ],
                                                )),
                                      )
                                    else
                                      Container(
                                        width: widget.w * 0.35,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: widget.h * 0.02),
                          AnimatedButton(
                              isFixedHeight: false,
                              height: widget.h > 800
                                  ? widget.h * 0.035
                                  : widget.h * 0.04,
                              width: widget.w * 0.33,
                              text: "Candidati",
                              buttonTextStyle: TextStyle(
                                  fontSize: widget.w > 605
                                      ? 25
                                      : widget.w > 390
                                          ? 15
                                          : 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              color: kPrimaryColor,
                              pressEvent: () {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.topSlide,
                                        showCloseIcon: true,
                                        title: "Vuoi offrirti come giocatore?",
                                        titleTextStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: widget.w > 605
                                                ? 40
                                                : widget.w > 385
                                                    ? 25
                                                    : 20),
                                        desc:
                                            "La tua richiesta sarà inviata all'organizzatore",
                                        descTextStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: widget.w > 605
                                                ? 30
                                                : widget.w > 385
                                                    ? 18
                                                    : 14),
                                        btnOkOnPress: () async {
                                          if (widget.list1.isEmpty) {
                                            widget.list1.add(utente);

                                            await FirebaseDatabase.instanceFor(
                                                    app: Firebase.app(),
                                                    databaseURL:
                                                        dbPrenotazioniURL)
                                                .ref()
                                                .child('Prenotazioni')
                                                .child(widget.appointment['id'])
                                                .child('football')
                                                .child('Crea_Match')
                                                .child(widget
                                                    .appointment['dateURL'])
                                                .child('candidati')
                                                .update({
                                              'c${widget.appointment['candidatiTot']}':
                                                  utente
                                            });

                                            await FirebaseDatabase.instanceFor(
                                                    app: Firebase.app(),
                                                    databaseURL:
                                                        dbPrenotazioniURL)
                                                .ref()
                                                .child('Prenotazioni')
                                                .child(widget.appointment['id'])
                                                .child('football')
                                                .child('Crea_Match')
                                                .child(widget
                                                    .appointment['dateURL'])
                                                .update({
                                              'candidatiTot':
                                                  widget.appointment[
                                                          'candidatiTot'] +
                                                      1
                                            });

                                            await FirebaseDatabase.instanceFor(
                                                    app: Firebase.app(),
                                                    databaseURL: dbCreaMatchURL)
                                                .ref()
                                                .child('Prenotazioni')
                                                .child('Crea_Match')
                                                .child(
                                                    widget.appointment['city'])
                                                .child('football')
                                                .child(widget
                                                    .appointment['dateURL'])
                                                .child('candidati')
                                                .update({
                                              'c${widget.appointment['candidatiTot']}':
                                                  utente
                                            });

                                            await FirebaseDatabase.instanceFor(
                                                    app: Firebase.app(),
                                                    databaseURL: dbCreaMatchURL)
                                                .ref()
                                                .child('Prenotazioni')
                                                .child('Crea_Match')
                                                .child(
                                                    widget.appointment['city'])
                                                .child('football')
                                                .child(widget
                                                    .appointment['dateURL'])
                                                .update({
                                              'candidatiTot':
                                                  widget.appointment[
                                                          'candidatiTot'] +
                                                      1
                                            });

                                            Get.to(
                                                () => OfferToPlay(
                                                      appointment:
                                                          widget.appointment,
                                                      h: widget.h,
                                                      w: widget.w,
                                                    ),
                                                transition: Transition.fade);
                                          }

                                          for (int i = 0;
                                              i < (widget.list1.length);
                                              i++) {
                                            if (utente != widget.list1[i]) {
                                              counter1 = counter1 + 1;
                                            }
                                          }

                                          print(widget.list1);
                                          print(counter1);

                                          if (counter1 == widget.list1.length) {
                                            await FirebaseDatabase.instanceFor(
                                                    app: Firebase.app(),
                                                    databaseURL:
                                                        dbPrenotazioniURL)
                                                .ref()
                                                .child('Prenotazioni')
                                                .child(widget.appointment['id'])
                                                .child('football')
                                                .child('Crea_Match')
                                                .child(widget
                                                    .appointment['dateURL'])
                                                .child('candidati')
                                                .update({
                                              'c${widget.appointment['candidatiTot']}':
                                                  utente
                                            });

                                            await FirebaseDatabase.instanceFor(
                                                    app: Firebase.app(),
                                                    databaseURL:
                                                        dbPrenotazioniURL)
                                                .ref()
                                                .child('Prenotazioni')
                                                .child(widget.appointment['id'])
                                                .child('football')
                                                .child('Crea_Match')
                                                .child(widget
                                                    .appointment['dateURL'])
                                                .update({
                                              'candidatiTot':
                                                  widget.appointment[
                                                          'candidatiTot'] +
                                                      1
                                            });

                                            await FirebaseDatabase.instanceFor(
                                                    app: Firebase.app(),
                                                    databaseURL: dbCreaMatchURL)
                                                .ref()
                                                .child('Prenotazioni')
                                                .child('Crea_Match')
                                                .child(
                                                    widget.appointment['city'])
                                                .child('football')
                                                .child(widget
                                                    .appointment['dateURL'])
                                                .child('candidati')
                                                .update({
                                              'c${widget.appointment['candidatiTot']}':
                                                  utente
                                            });

                                            await FirebaseDatabase.instanceFor(
                                                    app: Firebase.app(),
                                                    databaseURL: dbCreaMatchURL)
                                                .ref()
                                                .child('Prenotazioni')
                                                .child('Crea_Match')
                                                .child(
                                                    widget.appointment['city'])
                                                .child('football')
                                                .child(widget
                                                    .appointment['dateURL'])
                                                .update({
                                              'candidatiTot':
                                                  widget.appointment[
                                                          'candidatiTot'] +
                                                      1
                                            });

                                            Get.to(
                                                () => OfferToPlay(
                                                      appointment:
                                                          widget.appointment,
                                                      h: widget.h,
                                                      w: widget.w,
                                                    ),
                                                transition: Transition.fade);

                                            counter1 = 0;
                                          }
                                        },
                                        btnOkIcon: Icons.thumb_up,
                                        btnOkText: "Proponiti",
                                        btnOkColor: Colors.green[800],
                                        buttonsTextStyle: TextStyle(
                                            fontSize: widget.w > 605 ? 30 : 15,
                                            color: Colors.white))
                                    .show();
                              }),
                        ],
                      ),
                    ),
                  ])))),
      Center(
        child: GestureDetector(
          onTap: () {
            Get.to(() => CommentPage(
                h: widget.h,
                w: widget.w,
                appointment: widget.appointment,
                list1: widget.list1));
          },
          child: Container(
            height: widget.h * 0.09,
            width: widget.w * 0.9,

            padding: const EdgeInsets.only(
                bottom: kDefaultPadding, top: kDefaultPadding),
            //padding: const EdgeInsets.only(bottom: kDefaultPadding),
            decoration: const BoxDecoration(
              color: kBackgroundColor2,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Text(
              'Apri sezione info e commenti',
              style: TextStyle(
                  fontSize: widget.w > 385 ? 18 : 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20)
    ]);
  }
}

void sendPushMessage(String token) async {
  try {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAF7K1p_g:APA91bEmcWt3BsUkuQVdz3fwpQ5Z64JPlyqJHlHQZu3DDrscPdhonZOc0Ck8zKedfMTEezCCarEm4TmNMbO5JJ4MVQaSEgCHu7lJwFeCogjXX3Cc4fsC0MLnARnLl3xpS21LVCarNuav',
        },
        body: jsonEncode({
          'priority': 'high',
          //     'data': {
          //       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          //       'status': 'done',
          //       'body': 'Controlla il calendario, nuovi campi sono stati prenotati.',
          //       'title': 'Nuova Prenotazione!',
          //       'android_channel_id': 'sportshub'
          //     },

          'notification': {
            'title': 'Conferma Disponibile!',
            'body': 'Ora puoi confermare i risultati della tua partita.',
            'android_channel_id': 'sportshub',
            'collapse_key': 'Sports Hub',
            'tag': 'Sports Hub'
          },
          'to': token,
        }));
    print('caricato');
  } catch (e) {
    if (kDebugMode) {
      print('error push notification');
      print(e);
    }
  }
}
