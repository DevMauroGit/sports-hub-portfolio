import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:go_router/go_router.dart';
import 'package:sports_hub_ios/page/football_results_page.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/page/tennis_result_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Crea_Match/football_create_results_page.dart';

Widget AppointmentCreateCard(
    {required Map appointment, h, w, context, profile, sport}) {
  String b_hour = '';
  String a_hour = '';
  String hour = appointment['hour'];
  String b_minutes = '30';
  String minutes = '00';

  List calendar1 = [];
  List calendar2 = [];

  String uid = FirebaseAuth.instance.currentUser!.uid.toString();

  if (appointment['hour'].length == 1) {
    hour = '0${appointment['hour']}';
  }

  if (appointment['minutes'].toString().length == 1) {
    minutes = '0${appointment['minutes']}';
  } else {
    minutes = appointment['minutes'];
  }

  for (int i = 0; i < 24; i++) {
    if (appointment['hour'] == '$i') {
      a_hour = '${i + 1}';
      b_hour = '${i - 1}';
    }
  }

  for (int i = 10; i < 24; i++) {
    if (appointment['hour'] == '$i') {
      a_hour = '${i + 1}';
      b_hour = '${i - 1}';
    }
  }
  for (int i = 8; i > 0; i--) {
    if (appointment['hour'] == '0$i') {
      a_hour = '0${i + 1}';
      b_hour = '0${i - 1}';
    }
  }
  if (appointment['hour'] == '09') {
    a_hour = '10';
    b_hour = '08';
  }

  String day = appointment['day'].toString();
  //print(next_hour);

  if (appointment['caricato'] == false) {
    return Column(children: [
      SizedBox(height: h * 0.02),
      Center(
          child: Container(
              height: h > 800
                  ? h * 0.35
                  : h > 900
                      ? h * 0.3
                      : h * 0.35,
              width: w * 0.8,
              padding: const EdgeInsets.all(0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: kBackgroundColor2,
              ),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Column(children: [
                    SizedBox(height: h * 0.02),
                    SizedBox(
                      child: Image.asset("assets/images/tabellone.png"),
                    ),
                    SizedBox(height: h * 0.01),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: w * 0.365,
                                child: Text(appointment['club'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: w > 605
                                            ? 25
                                            : w > 385
                                                ? 16
                                                : 10,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic)),
                              ),
                              appointment['sport'] == 'football'
                                  ? Container(
                                      width: w * 0.07,
                                      height: h * 0.035,
                                      decoration: const BoxDecoration(
                                          color: kBackgroundColor2,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Icon(
                                            Icons.sports_soccer,
                                            size: h * 0.025,
                                          )))
                                  : Container(
                                      width: w * 0.07,
                                      height: h * 0.035,
                                      decoration: const BoxDecoration(
                                          color: kBackgroundColor2,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Icon(
                                            Icons.sports_tennis,
                                            size: h * 0.025,
                                          ))),
                              SizedBox(
                                width: w * 0.365,
                                child: Text(appointment['campo'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: w > 605
                                            ? 25
                                            : w > 385
                                                ? 16
                                                : 10,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic)),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(appointment['date'].toString(),
                                  style: TextStyle(
                                      fontSize: w > 605
                                          ? 25
                                          : w > 385
                                              ? 16
                                              : 10,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic)),
                              Text(appointment['time'].toString(),
                                  style: TextStyle(
                                      fontSize: w > 605
                                          ? 25
                                          : w > 385
                                              ? 16
                                              : 10,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                          SizedBox(height: h * 0.015),
                          SizedBox(
                            height: 0,
                            width: 0,
                            child: FirebaseAnimatedList(
                                query: FirebaseDatabase.instanceFor(
                                        app: Firebase.app(),
                                        databaseURL: appointment['dbURL'])
                                    .ref()
                                    .child('Calendario')
                                    .child(appointment['month'])
                                    .child(day)
                                    .child(appointment['campo']),
                                itemBuilder: (BuildContext context,
                                    DataSnapshot snapshot,
                                    Animation<double> animation,
                                    int index) {
                                  (calendar1).add(snapshot.child('user').value);
                                  (calendar2)
                                      .add(snapshot.child('user_half').value);

                                  return Container();
                                }),
                          ),

                          AnimatedButton(
                            isFixedHeight: false,
                            height: h > 900 ? h * 0.035 : h * 0.04,
                            width: w > 390 ? w * 0.4 : w * 0.5,
                            text: "Aggiungi giocatori",
                            buttonTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: w > 605
                                    ? 25
                                    : w > 385
                                        ? 18
                                        : 13,
                                fontWeight: FontWeight.bold),
                            color: DateTime.parse(
                                        '2024-${appointment['meseN']}-${appointment['dayN']} $hour:$minutes:00')
                                    .isAfter(DateTime.now())
                                ? kPrimaryColor
                                : kPrimaryColor.withOpacity(0.5),
                            pressEvent: () {
                              DateTime.parse(
                                          '2024-${appointment['meseN']}-${appointment['dayN']} $hour:$minutes:00')
                                      .isAfter(DateTime.now())
                                  ?
                                  sport == 'football'
                                      ? Get.to(
                                          () => FootballCreateResultsPage(
                                                appointment: appointment,
                                              ),
                                          transition: Transition.fadeIn)
                                      : Get.to(
                                          () => TennisResultsPage(
                                                appointment: appointment,
                                              ),
                                          transition: Transition.fadeIn)
                                  : Get.snackbar('', "",
                                      snackPosition: SnackPosition.TOP,
                                      titleText: Text(
                                        'Fuori tempo massimo',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                          fontSize: w > 605
                                              ? 18
                                              : w > 385
                                                  ? 15
                                                  : 13,
                                        ),
                                      ),
                                      duration: const Duration(seconds: 4),
                                      backgroundColor:
                                          Colors.redAccent.withOpacity(0.6),
                                      colorText: Colors.black);
                            },
                          ),
                          SizedBox(height: h * 0.01),

                          AnimatedButton(
                            isFixedHeight: false,
                            height: h > 900 ? h * 0.035 : h * 0.04,
                            width: w > 390 ? w * 0.4 : w * 0.5,
                            text: "Inserisci Risultato",
                            buttonTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: w > 605
                                    ? 25
                                    : w > 385
                                        ? 18
                                        : 13,
                                fontWeight: FontWeight.bold),
                            color: DateTime.parse(
                                        '2024-${appointment['meseN']}-${appointment['dayN']} $a_hour:$minutes:00')
                                    .isBefore(DateTime.now())
                                ? kPrimaryColor
                                : kPrimaryColor.withOpacity(0.5),
                            pressEvent: () {
                              DateTime.parse(
                                          '2024-${appointment['meseN']}-${appointment['dayN']} $a_hour:$minutes:00')
                                      .isBefore(DateTime.now())
                                  ?
                                  sport == 'football'
                                      ? GoRouter.of(context).go('/football-results', extra: {
                                        'appointment': appointment,
                                        })
                                      
                                      
                                      : GoRouter.of(context).go('/tennis-results', extra: {
                                        'appointment': appointment,
                                        })
                                      
                                  : Get.snackbar('', "",
                                      snackPosition: SnackPosition.TOP,
                                      titleText: Text(
                                        'La partita non è ancora stata giocata',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                          fontSize: w > 605
                                              ? 18
                                              : w > 385
                                                  ? 15
                                                  : 13,
                                        ),
                                      ),
                                      duration: const Duration(seconds: 4),
                                      backgroundColor:
                                          Colors.redAccent.withOpacity(0.6),
                                      colorText: Colors.black);

                            },
                          ),
                          SizedBox(height: h * 0.01),
                          FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(FirebaseAuth.instance.currentUser!.email
                                      .toString())
                                  .get(),
                              builder: (((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  // ignore: unused_local_variable
                                  Map<String, dynamic> utente = snapshot.data!
                                      .data() as Map<String, dynamic>;

                                  return
                                      AnimatedButton(
                                    isFixedHeight: false,
                                    height: h > 900 ? h * 0.035 : h * 0.04,
                                    width: w > 390 ? w * 0.4 : w * 0.5,
                                    text: (DateTime.parse(
                                                '2024-${appointment['meseN']}-${appointment['dayN']} $a_hour:$minutes:00')
                                            .isAfter(DateTime.now()))
                                        ? "Cancella Partita"
                                        : "Archivia Partita",
                                    buttonTextStyle: TextStyle(
                                        fontSize: w > 605
                                            ? 25
                                            : w > 390
                                                ? 15
                                                : 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    color: (DateTime.now().isAfter(DateTime.parse(
                                            '2024-${appointment['meseN']}-${appointment['dayN']} $a_hour:$minutes:00')))
                                        ? Colors.red
                                        : (DateTime.now().isAfter(DateTime.parse(
                                                '2024-${appointment['meseN']}-${appointment['dayN']} $b_hour:$b_minutes:00')))
                                            ? Colors.red.withOpacity(0.5)
                                            : Colors.red,
                                    pressEvent: () {
                                      (DateTime.parse('2024-${appointment['meseN']}-${appointment['dayN']} $b_hour:$b_minutes:00')
                                              .isAfter(DateTime.now()))
                                          ? AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.warning,
                                                  animType: AnimType.topSlide,
                                                  showCloseIcon: true,
                                                  title: "Attento",
                                                  titleTextStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: w > 605
                                                          ? 40
                                                          : w > 385
                                                              ? 25
                                                              : 20),
                                                  desc:
                                                      "Vuoi cancellare la tua prenotazione?\nRicordati di avvisare il campo se lo hai prenotato!",
                                                  descTextStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: w > 605
                                                          ? 30
                                                          : w > 385
                                                              ? 18
                                                              : 14),
                                                  btnOkOnPress: () async {
                                                    FirebaseDatabase.instanceFor(
                                                            app: Firebase.app(),
                                                            databaseURL:
                                                                dbCreaMatchURL)
                                                        .ref()
                                                        .child('Prenotazioni')
                                                        .child('Crea_Match')
                                                        .child(
                                                            appointment['city'])
                                                        .child(sport)
                                                        .child(
                                                            '${appointment['month']}-$day-${appointment['time']}')
                                                        .remove();

                                                    FirebaseDatabase.instanceFor(
                                                            app: Firebase.app(),
                                                            databaseURL:
                                                                dbPrenotazioniURL)
                                                        .ref()
                                                        .child('Prenotazioni')
                                                        .child(uid)
                                                        .child(sport)
                                                        .child('Crea_Match')
                                                        .child(
                                                            '${appointment['month']}-$day-${appointment['time']}')
                                                        .remove();

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("User")
                                                        .doc(profile)
                                                        .update({
                                                      'prenotazioni': utente[
                                                              'prenotazioni'] -
                                                          1
                                                    });

                                                    Get.to(
                                                        () => ProfilePage(
                                                              docIds: profile,
                                                              avviso: false,
                                                              sport: 'football',
                                                            ),
                                                        transition:
                                                            Transition.fade);
                                                  },
                                                  btnOkIcon: Icons.delete,
                                                  btnOkText: "Cancella",
                                                  btnOkColor: Colors.red,
                                                  buttonsTextStyle: TextStyle(
                                                      fontSize: w > 605
                                                          ? 30
                                                          : w > 385
                                                              ? 18
                                                              : 14,
                                                      color: Colors.white))
                                              .show()
                                          : (DateTime.parse(
                                                      '2024-${appointment['meseN']}-${appointment['dayN']} $a_hour:$minutes:00')
                                                  .isAfter(DateTime.now()))
                                              ? Get.snackbar('', "",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  titleText: Text(
                                                    'Impossibile cancellare prenotazione',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      letterSpacing: 1,
                                                      fontSize: w > 605
                                                          ? 18
                                                          : w > 385
                                                              ? 15
                                                              : 13,
                                                    ),
                                                  ),
                                                  messageText: Text(
                                                    "E' scaduto il tempo limite",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 1,
                                                      fontSize: w > 605
                                                          ? 18
                                                          : w > 385
                                                              ? 15
                                                              : 13,
                                                    ),
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 4),
                                                  backgroundColor: Colors
                                                      .redAccent
                                                      .withOpacity(0.6),
                                                  colorText: Colors.black)
                                              : AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.warning,
                                                      animType:
                                                          AnimType.topSlide,
                                                      showCloseIcon: true,
                                                      title: "Attento",
                                                      titleTextStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: w > 605
                                                              ? 40
                                                              : w > 385
                                                                  ? 25
                                                                  : 20),
                                                      desc:
                                                          "Vuoi Archiviare la partita?\nSe archivi la partita non potrai inserire il risultato",
                                                      descTextStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: w > 605
                                                              ? 30
                                                              : w > 385
                                                                  ? 18
                                                                  : 14),
                                                      btnOkOnPress: () async {
                                                        await FirebaseDatabase
                                                                .instanceFor(
                                                                    app: Firebase
                                                                        .app(),
                                                                    databaseURL:
                                                                        dbPrenotazioniURL)
                                                            .ref()
                                                            .child(
                                                                'Prenotazioni')
                                                            .child(uid)
                                                            .child(sport)
                                                            .child('Crea_Match')
                                                            .child(
                                                                '${appointment['month']}-$day-${appointment['time']}')
                                                            .update({
                                                          'caricato': true
                                                        });

                                                        await FirebaseDatabase
                                                                .instanceFor(
                                                                    app: Firebase
                                                                        .app(),
                                                                    databaseURL:
                                                                        dbPrenotazioniURL)
                                                            .ref()
                                                            .child(
                                                                'Prenotazioni')
                                                            .child('Crea_Match')
                                                            .child(appointment[
                                                                'city'])
                                                            .child(sport)
                                                            .child(
                                                                '${appointment['month']}-$day-${appointment['time']}')
                                                            .update({
                                                          'caricato': true
                                                        });

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection("User")
                                                            .doc(profile)
                                                            .update({
                                                          'prenotazioni': utente[
                                                                  'prenotazioni'] -
                                                              1
                                                        });

                                                        Get.to(
                                                            () => ProfilePage(
                                                                  docIds:
                                                                      profile,
                                                                  avviso: false,
                                                                  sport:
                                                                      'football',
                                                                ),
                                                            transition:
                                                                Transition
                                                                    .fade);
                                                      },
                                                      btnOkIcon: Icons.delete,
                                                      btnOkText: "Archivia",
                                                      btnOkColor: Colors.red,
                                                      buttonsTextStyle:
                                                          TextStyle(
                                                              fontSize: w > 605
                                                                  ? 30
                                                                  : 18,
                                                              color:
                                                                  Colors.white))
                                                  .show();
                                    },
                                  );
                                }
                                return Container();
                              })))
                        ],
                      ),
                    ),
                  ]))))
    ]);
  }
  return Container();
}

Future<void> updateToServer(
    String sport,
    String id,
    String day,
    String time,
    String month,
    String pitch,
    String hour,
    int minutes,
    List list1,
    List list2,
    int firstHour,
    int lastHour,
    String club,
    String dbURL) async {
  int hourInt = 09;
  String prevHour = '';
  String nextHour = '';

  for (int i = 0; i < 10; i++) {
    if (hour == '0$i') {
      hourInt = i;
    }
  }

  for (int i = 10; i < 24; i++) {
    if (hour == '$i') {
      hourInt = i;
    }
  }

  if (hourInt <= 10) {
    prevHour = '0${hourInt - 1}';
  } else {
    prevHour = '${hourInt - 1}';
  }
  if (hourInt < 9) {
    nextHour = '0${hourInt + 1}';
  } else {
    nextHour = '${hourInt + 1}';
  }

  if (minutes == 0) {
    FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
        .ref()
        .child('Calendario')
        .child(month)
        .child(day)
        .child(pitch)
        .child(hour)
        .update({
      'isTimeAvailable': true,
      'user': '',
    });

    if (sport == 'football') {
      if (hourInt < lastHour) {
        if (list1[hourInt - firstHour + 1] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(hour)
              .update({
            'half_hour': true,
          });
        }
      }

      if (hourInt > firstHour) {
        if (list1[hourInt - (firstHour + 1)] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(prevHour)
              .update({
            'half_hour': true,
          });
        }
      }
    } else if (sport == 'tennis') {
      if (hourInt < lastHour - 1) {
        if (list1[hourInt - firstHour + 1] == '' &&
            list2[hourInt - firstHour + 1] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(hour)
              .update({
            'half_hour': true,
          });
        }

        if (list2[hourInt - firstHour + 1] == '' &&
            list1[hourInt - firstHour + 2] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(nextHour)
              .update({
            'isTimeAvailable': true,
          });
        }
      } else if (hourInt == lastHour - 1) {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(hour)
            .update({
          'half_hour': true,
        });
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(nextHour)
            .update({
          'isTimeAvailable': true,
        });
      } else {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(hour)
            .update({
          'half_hour': true,
        });
      }

      if (hourInt > firstHour + 1) {
        if ((list2[hourInt - (firstHour + 2)] == '' ||
                list2[hourInt - (firstHour + 2)] == null) &&
            (list1[hourInt - (firstHour + 1)] == '' ||
                list1[hourInt - (firstHour + 1)] == null)) {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(prevHour)
              .update({
            'half_hour': true,
          });
          if ((list2[hourInt - (firstHour + 2)] == '' ||
                  list2[hourInt - (firstHour + 2)] == null) &&
              (list1[hourInt - (firstHour + 2)] == '' ||
                  list1[hourInt - (firstHour + 2)] == null)) {
            FirebaseDatabase.instanceFor(
                    app: Firebase.app(), databaseURL: dbURL)
                .ref()
                .child('Calendario')
                .child(month)
                .child(day)
                .child(pitch)
                .child(prevHour)
                .update({
              'isTimeAvailable': true,
            });
          }
        }
      } else if (hourInt == firstHour + 1) {
        //if((list2[hourInt - (firstHour + 2)] == '' || list2[hourInt - (firstHour +2)] == null) && (list1[hourInt - (firstHour + 1)] == '' || list1[hourInt - (firstHour +1)] == null)){
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(prevHour)
            .update({
          'half_hour': true,
        });
        //if (list2[hourInt - (firstHour +2)] == '' || list2[hourInt - (firstHour +2)] == null) {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(prevHour)
            .update({
          'isTimeAvailable': true,
        });
        //}
        //}
      }
    }
  } else {
    FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
        .ref()
        .child('Calendario')
        .child(month)
        .child(day)
        .child(pitch)
        .child(hour)
        .update({'half_hour': true, 'user_half': ''});

    if (sport == 'football') {
      if (hourInt > firstHour) {
        if (list2[hourInt - (firstHour + 1)] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(hour)
              .update({
            'isTimeAvailable': true,
          });
        }
      } else {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(hour)
            .update({
          'isTimeAvailable': true,
        });
      }

      if (hourInt < lastHour) {
        if (list2[hourInt - firstHour + 1] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(nextHour)
              .update({
            'isTimeAvailable': true,
          });
        }
      }
    } else if (sport == 'tennis') {
      if (hourInt < lastHour - 1) {
        if (list2[hourInt - firstHour + 1] == '' &&
            list1[hourInt - firstHour + 2] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(nextHour)
              .update({
            'isTimeAvailable': true,
          });
        }

        if (list1[hourInt - firstHour + 2] == '' &&
            list2[hourInt - firstHour + 2] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(nextHour)
              .update({
            'half_hour': true,
          });
        }
      } else if (hourInt == lastHour - 1) {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(nextHour)
            .update({
          'isTimeAvailable': true,
          'half_hour': true,
        });
      }

      if (hourInt > firstHour + 1) {
        if (list2[hourInt - (firstHour + 1)] == '' &&
            list1[hourInt - (firstHour + 1)] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(hour)
              .update({
            'isTimeAvailable': true,
          });

          if (list1[hourInt - (firstHour + 1)] == '' &&
              list2[hourInt - (firstHour + 2)] == '') {
            FirebaseDatabase.instanceFor(
                    app: Firebase.app(), databaseURL: dbURL)
                .ref()
                .child('Calendario')
                .child(month)
                .child(day)
                .child(pitch)
                .child(prevHour)
                .update({
              'half_hour': true,
            });
          }
        }
      } else if (hourInt == firstHour + 1) {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(hour)
            .update({
          'isTimeAvailable': true,
        });
        if (list1[hourInt - (firstHour + 1)] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(prevHour)
              .update({
            'half_hour': true,
          });
        }
      } else if (hourInt == firstHour) {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(hour)
            .update({
          'isTimeAvailable': true,
        });
      }
    }
  }

  FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child(sport)
      .child('$month-$day-$time')
      .remove();
}
