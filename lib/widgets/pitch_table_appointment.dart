// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sports_hub_ios/controllers/admin_controller.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/utils/datetime_converter.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';
import 'package:sports_hub_ios/widgets/popup_appointment_club.dart';

String price = '';

class PitchTableAppointment extends StatefulWidget {
  final DateTime daySelected;
  final Map club;
  final Map pitch;

  const PitchTableAppointment(
      {super.key,
      required this.daySelected,
      required this.club,
      required this.pitch});

  @override
  State<PitchTableAppointment> createState() => _PitchTableAppointmentState();
}

class _PitchTableAppointmentState extends State<PitchTableAppointment> {
  AdminController adminController = Get.put(AdminController());

  late Future<AdminController> dataFuture;

  String time = '';
  String hour = 'no time';
  int min = 0;
  DateTime today = DateTime.now();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    initInfo();
    dataFuture = getData();
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: (payload) async {
      try {} catch (e) {}
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('..................onMessage..................');
      print(
          'onmessage: ${message.notification?.title}/${message.notification?.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'sportshub',
        'sportshub',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: const DarwinNotificationDetails());
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  Future<AdminController> getData() async {
    adminController = await Get.put(AdminController());
    Get.lazyPut(() => FirebaseStorageService());

    return adminController;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    if (widget.pitch['price'] != null) {
      setState(() {
        price = widget.pitch['price'];
      });
    }

    String data = "";
    if (widget.daySelected.month < 10) {
      setState(() {
        data = "0";
      });
    }
    final getMonth =
        "$data${widget.daySelected.month}_${DateConverted.getMonth(widget.daySelected.month)}";

    TextStyle titles = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: w > 385 ? 18 : 14,
        color: Colors.black);

    TextStyle prenotato = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: w > 605
            ? 22
            : w > 385
                ? 14
                : 10);

    TextStyle libero = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: w > 605
            ? 22
            : w > 385
                ? 16
                : 12);

    ScrollController scrollController2 = ScrollController();

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('User')
                .doc(FirebaseAuth.instance.currentUser!.email.toString())
                .get(),
            builder: (((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> profile =
                    snapshot.data!.data() as Map<String, dynamic>;

                return SizedBox(
                  width: w * 0.65,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    //child: Padding(
                    //padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      children: [
                        SizedBox(
                            height: h * 0.05,
                            width: w > 385
                                ? w * 0.25 * widget.club['slot'] * 2
                                : w * 0.275 * widget.club['slot'] * 2,
                            child: Row(
                              children: [
                                for (int i = 0; i < widget.club['slot']; i++)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: w > 385 ? w * 0.2 : w * 0.225,
                                          alignment: Alignment.topCenter,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: h * 0.01,
                                          ),
                                          child: Text(
                                            '${widget.club['orari']['h${i + 1}']}:00',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: w > 605
                                                    ? 22
                                                    : w > 385
                                                        ? 18
                                                        : 13,
                                                color: Colors.black),
                                          )),
                                      Container(
                                          width: w > 385 ? w * 0.2 : w * 0.225,
                                          alignment: Alignment.topCenter,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: h * 0.01,
                                          ),
                                          child: Text(
                                            '${widget.club['orari']['h${i + 1}']}:30',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: w > 605
                                                    ? 22
                                                    : w > 385
                                                        ? 18
                                                        : 13,
                                                color: Colors.black),
                                          )),
                                    ],
                                  ),
                              ],
                            )),
                        Container(
                          height: h * 0.08,
                          width: w > 385
                              ? w * 0.25 * widget.club['slot'] * 2
                              : w * 0.275 * widget.club['slot'] * 2,
                          color: kBackgroundColor2,
                          alignment: Alignment.topCenter,
                          child: FirebaseAnimatedList(
                              controller: scrollController2,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              query: FirebaseDatabase.instanceFor(
                                      app: Firebase.app(),
                                      databaseURL: widget.club['dbURL'])
                                  .ref()
                                  .child('Calendario')
                                  .child(getMonth)
                                  .child("${widget.daySelected.day}")
                                  .child(widget.pitch['title']),
                              itemBuilder: (BuildContext context,
                                  DataSnapshot snapshot,
                                  Animation<double> animation,
                                  int index) {
                                Map day = snapshot.value as Map;
                                day['key'] = snapshot.key;

                                int next_hour = 10;

                                for (int i = 0; i < 15; i++) {
                                  if (day['key'] == '${09 + i}') {
                                    next_hour = 10 + i;
                                  }
                                }

                                var availableTime = [];
                                var availableNextTime = [];

                                if (snapshot
                                        .child('isTimeAvailable')
                                        .value
                                        .toString() ==
                                    'true') {
                                  availableTime.add('libero');
                                } else {
                                  availableTime.add('X');
                                }

                                if (snapshot
                                        .child('half_hour')
                                        .value
                                        .toString() ==
                                    'true') {
                                  availableNextTime.add('libero');
                                } else {
                                  availableNextTime.add('X');
                                }

                                return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: h * 0.75,
                                        width: w > 385 ? w * 0.2 : w * 0.225,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: h * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                            color: availableTime[0] == 'libero'
                                                ? Colors.green[700]
                                                : Colors.red[300],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: AnimatedButton(
                                          isFixedHeight: false,
                                          height: h * 0.05,
                                          width: w * 0.4,
                                          text: availableTime[0],
                                          buttonTextStyle:
                                              availableTime[0] == 'libero'
                                                  ? libero
                                                  : prenotato,
                                          color: Colors.transparent,
                                          pressEvent: () {
                                            int hourInt = 0;

                                            time = day['key'];
                                            for (int i = 10; i < 24; i++) {
                                              if (time == '$i') {
                                                hour = '$i';
                                                hourInt = i;
                                              }
                                            }
                                            for (int i = 0; i < 10; i++) {
                                              if (time == 'i') {
                                                hour = '0$i';
                                                hourInt = i;
                                              }
                                            }

                                            time = '$time:00 - $next_hour:00';
                                            min = 0;

                                            String b_hour = hour;
                                            //int b_minutes_int = 60 - widget.club['b_minutes'] as int;
                                            String monthN =
                                                '${widget.daySelected.month}';
                                            String dayN =
                                                '${widget.daySelected.day}';

                                            if (widget.daySelected.month < 10) {
                                              monthN =
                                                  '0${widget.daySelected.month}';
                                            }

                                            if (widget.daySelected.day < 10) {
                                              dayN =
                                                  '0${widget.daySelected.day}';
                                            }

                                            int before_hour_int = 0;
                                            int before_c_hour_int = 0;
                                            String before_hour = '';
                                            String before_c_hour = '';
                                            int safe_hour = widget.daySelected.weekday.toString() ==
                                                        'sunday' ||
                                                    (widget.daySelected.day == 1 &&
                                                        widget.daySelected.month ==
                                                            1) ||
                                                    (widget.daySelected.day == 6 &&
                                                        widget.daySelected.month ==
                                                            1) ||
                                                    (widget.daySelected.day == 25 &&
                                                        widget.daySelected.month ==
                                                            4) ||
                                                    (widget.daySelected.day == 1 &&
                                                        widget.daySelected.month ==
                                                            5) ||
                                                    (widget.daySelected.day == 2 &&
                                                        widget.daySelected.month ==
                                                            6) ||
                                                    (widget.daySelected.day == 15 &&
                                                        widget.daySelected.month ==
                                                            8) ||
                                                    (widget.daySelected.day == 1 &&
                                                        widget.daySelected.month ==
                                                            11) ||
                                                    (widget.daySelected.day == 8 &&
                                                        widget.daySelected.month == 12) ||
                                                    (widget.daySelected.day == 25 && widget.daySelected.month == 12) ||
                                                    (widget.daySelected.day == 26 && widget.daySelected.month == 12)
                                                ? widget.club['b_hour_f']
                                                : widget.club['b_hour'];
                                            int safe_c_hour =
                                                widget.club['c_hour'];
                                            int b_minutes_int = 0;
                                            int c_minutes_int = 0;
                                            String b_minutes = '';
                                            String c_minutes = '';
                                            before_hour_int =
                                                hourInt - safe_hour;
                                            before_c_hour_int =
                                                hourInt - safe_c_hour;

                                            if (widget.club['b_minutes']
                                                    as int !=
                                                0) {
                                              if (widget.club['b_minutes']
                                                      as int <=
                                                  30) {
                                                b_minutes_int = 30 -
                                                        widget.club['b_minutes']
                                                    as int;
                                              } else {
                                                b_minutes_int = 60 -
                                                    ((widget.club['b_minutes']
                                                            as int) -
                                                        30);
                                                before_hour_int =
                                                    before_hour_int - 1;
                                              }
                                            }

                                            if (widget.club['c_minutes']
                                                    as int !=
                                                0) {
                                              if (widget.club['c_minutes']
                                                      as int <=
                                                  30) {
                                                c_minutes_int = 30 -
                                                        widget.club['c_minutes']
                                                    as int;
                                              } else {
                                                c_minutes_int = 60 -
                                                    ((widget.club['c_minutes']
                                                            as int) -
                                                        30);
                                                before_c_hour_int =
                                                    before_c_hour_int - 1;
                                              }
                                            }

                                            if (before_hour_int < 10) {
                                              before_hour = '0$before_hour_int';
                                            } else {
                                              before_hour = '$before_hour_int';
                                            }

                                            if (before_c_hour_int < 10) {
                                              before_c_hour =
                                                  '0$before_c_hour_int';
                                            } else {
                                              before_c_hour =
                                                  '$before_c_hour_int';
                                            }

                                            //int b_minutes_int = widget.club['b_minutes'] as int;

                                            if (b_minutes_int < 10) {
                                              b_minutes = '0$b_minutes_int';
                                            } else {
                                              b_minutes = '$b_minutes_int';
                                            }

                                            if (c_minutes_int < 10) {
                                              c_minutes = '0$c_minutes_int';
                                            } else {
                                              c_minutes = '$c_minutes_int';
                                            }

                                            print(
                                                '2024-$monthN-$dayN $b_hour:$b_minutes:00');

                                            if (profile['prenotazioniPremium'] <
                                                    2 &&
                                                availableTime[0] == 'libero' &&
                                                DateTime.parse(
                                                        '2024-$monthN-$dayN $before_hour:$b_minutes:00')
                                                    .isAfter(DateTime.now())) {
                                              final getDate =
                                                  DateConverted.getDate(
                                                      widget.daySelected);
                                              final getDay =
                                                  DateConverted.getDay(widget
                                                          .daySelected.weekday)
                                                      .toString();

                                              String id = FirebaseAuth
                                                  .instance.currentUser!.uid;
                                              String email = FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .email as String;
                                              int next_hour = 10;
                                              int previous_hour = 0;

                                              //DocumentSnapshot snap = await FirebaseFirestore.instance.collection('Clubs').doc(widget.club['mail']).get()

                                              for (int i = 0;
                                                  i < widget.pitch['last_hour'];
                                                  i++) {
                                                if (hour ==
                                                    '${widget.pitch['first_hour'] + i}') {
                                                  next_hour = widget
                                                          .pitch['first_hour'] +
                                                      i +
                                                      1;
                                                }
                                              }

                                              for (int i = 1;
                                                  i < widget.pitch['last_hour'];
                                                  i++) {
                                                if (hour ==
                                                    '${widget.pitch['first_hour'] + i}') {
                                                  previous_hour = widget
                                                          .pitch['first_hour'] +
                                                      i -
                                                      1;
                                                }
                                              }

                                              //b_minutes = 45;
                                              for (int i = 10; i < 24; i++) {
                                                if (snapshot == '$i') {
                                                  b_hour = '${i + 1}';
                                                }
                                                if (hour == '09') {
                                                  b_hour = '10';
                                                }
                                              }

                                              AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.success,
                                                      animType:
                                                          AnimType.topSlide,
                                                      showCloseIcon: true,
                                                      title:
                                                          "Vuoi Prenotare questo orario?",
                                                      titleTextStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: w > 605
                                                              ? 45
                                                              : w > 385
                                                                  ? 30
                                                                  : 20,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                      desc:
                                                          "$dayN/$monthN $time\n una volta prenotato non potrai disdire oltre un certo orario",
                                                      descTextStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: w > 605
                                                              ? 30
                                                              : w > 380
                                                                  ? 20
                                                                  : 16,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                      btnOkOnPress: () async {
                                                        Navigator.of(context)
                                                            .push(HeroDialogRoute(
                                                                builder:
                                                                    (context) {
                                                          return const LoadingScreen();
                                                        }));

                                                        if (profile['prenotazioniPremium'] <
                                                                2 &&
                                                            availableTime[0] ==
                                                                'libero' &&
                                                            DateTime.parse(
                                                                    '2024-$monthN-$dayN $before_hour:$b_minutes:00')
                                                                .isAfter(DateTime
                                                                    .now())) {
                                                          updateToServer(
                                                              email,
                                                              widget.daySelected
                                                                  .day
                                                                  .toString(),
                                                              time,
                                                              getMonth,
                                                              widget.pitch[
                                                                  'title'],
                                                              hour,
                                                              widget.pitch[
                                                                  'first_hour'],
                                                              widget.pitch[
                                                                  'last_hour'],
                                                              widget.club[
                                                                  'dbURL'],
                                                              widget.pitch[
                                                                  'sport'],
                                                              widget.club[
                                                                  'title']);

                                                          sendToServer(
                                                              id,
                                                              email,
                                                              widget.pitch[
                                                                  'club'],
                                                              widget.pitch[
                                                                  'title'],
                                                              '${widget.daySelected.day}/${widget.daySelected.month}/${widget.daySelected.year}',
                                                              widget.daySelected
                                                                  .day
                                                                  .toString(),
                                                              time,
                                                              getMonth,
                                                              widget.daySelected
                                                                  .day
                                                                  .toString(),
                                                              1,
                                                              widget.pitch[
                                                                  'teamSize'],
                                                              hour,
                                                              min,
                                                              monthN,
                                                              dayN,
                                                              profile[
                                                                  'username'],
                                                              '$getMonth-${widget.daySelected.day.toString()}-$time',
                                                              1,
                                                              widget.pitch[
                                                                  'sport'],
                                                              widget.pitch[
                                                                  'first_hour'],
                                                              widget.pitch[
                                                                  'last_hour'],
                                                              widget.club[
                                                                  'dbURL'],
                                                              before_c_hour,
                                                              c_minutes);

                                                          //print('token ${widget.club['token']}');
                                                          sendPushMessage(widget
                                                              .club['token']);
                                                          //print(b_hour);
                                                          //print(b_minutes);

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "User")
                                                              .doc(email)
                                                              .update({
                                                            'prenotazioni':
                                                                profile['prenotazioni'] +
                                                                    1
                                                          });

                                                          Navigator.of(context)
                                                              .push(HeroDialogRoute(
                                                                  builder:
                                                                      (context) {
                                                            return PopUpAppointmentClub(
                                                              hour:
                                                                  '${snapshot.key.toString()}:00 - $next_hour:00',
                                                              date:
                                                                  '$dayN / $monthN',
                                                              w: w,
                                                              h: h,
                                                              sport:
                                                                  widget.pitch[
                                                                      'sport'],
                                                              email: email,
                                                            );
                                                          }));
                                                        }
                                                      },
                                                      btnOkIcon: Icons.thumb_up,
                                                      btnOkText: "CONFERMA",
                                                      btnOkColor:
                                                          kBackgroundColor2)
                                                  .show();
                                            } else {
                                              if (profile[
                                                      'prenotazioniPremium'] >=
                                                  3) {
                                                Get.snackbar('', "",
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                    titleText: Text(
                                                      'Hai già ${profile['prenotazioniPremium']} prenotazioni in programma o in attesa di risultato',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          letterSpacing: 1,
                                                          fontSize: w < 380
                                                              ? 13
                                                              : w > 605
                                                                  ? 18
                                                                  : 15),
                                                    ),
                                                    messageText: Text(
                                                      "Conferma, cancella o archivia una partita per prenotare di nuovo",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 1,
                                                          fontSize: w < 380
                                                              ? 13
                                                              : w > 605
                                                                  ? 18
                                                                  : 15),
                                                    ),
                                                    duration: const Duration(
                                                        seconds: 6),
                                                    backgroundColor: Colors
                                                        .redAccent
                                                        .withOpacity(0.6),
                                                    colorText: Colors.black);
                                              } else {
                                                if (DateTime.parse(
                                                            '2024-$monthN-$dayN $before_hour:$b_minutes:00')
                                                        .isAfter(
                                                            DateTime.now()) !=
                                                    true) {
                                                  Get.snackbar('', "",
                                                      snackPosition:
                                                          SnackPosition.TOP,
                                                      titleText: Text(
                                                        'Impossibile prenotare questo appuntamento',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            letterSpacing: 1,
                                                            fontSize: w < 380
                                                                ? 13
                                                                : w > 605
                                                                    ? 18
                                                                    : 15),
                                                      ),
                                                      messageText: Text(
                                                        "fuori tempo massimo",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 1,
                                                            fontSize: w < 380
                                                                ? 13
                                                                : w > 605
                                                                    ? 18
                                                                    : 15),
                                                      ),
                                                      duration: const Duration(
                                                          seconds: 4),
                                                      backgroundColor: Colors
                                                          .redAccent
                                                          .withOpacity(0.6),
                                                      colorText: Colors.black);
                                                } else {
                                                  Get.snackbar('', "",
                                                      snackPosition:
                                                          SnackPosition.TOP,
                                                      titleText: Text(
                                                        'Impossibile prenotare questo appuntamento',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            letterSpacing: 1,
                                                            fontSize: w < 380
                                                                ? 13
                                                                : w > 605
                                                                    ? 18
                                                                    : 15),
                                                      ),
                                                      messageText: Text(
                                                        "seleziona un orario disponibile",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 1,
                                                            fontSize: w < 380
                                                                ? 13
                                                                : w > 605
                                                                    ? 18
                                                                    : 15),
                                                      ),
                                                      duration: const Duration(
                                                          seconds: 4),
                                                      backgroundColor: Colors
                                                          .redAccent
                                                          .withOpacity(0.6),
                                                      colorText: Colors.black);
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      Container(
                                        height: h * 0.75,
                                        width: w > 385 ? w * 0.2 : w * 0.225,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: h * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                availableNextTime[0] == 'libero'
                                                    ? Colors.green[700]
                                                    : Colors.red[300],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: AnimatedButton(
                                          isFixedHeight: false,
                                          height: h * 0.05,
                                          width: w * 0.4,
                                          text: availableNextTime[0],
                                          buttonTextStyle:
                                              availableNextTime[0] == 'libero'
                                                  ? libero
                                                  : prenotato,
                                          color: Colors.transparent,
                                          pressEvent: () {
                                            int hourInt = 0;

                                            time = day['key'];
                                            for (int i = 10; i < 24; i++) {
                                              if (time == '$i') {
                                                hour = '$i';
                                                hourInt = i;
                                              }
                                            }
                                            for (int i = 0; i < 10; i++) {
                                              if (time == 'i') {
                                                hour = '0$i';
                                                hourInt = i;
                                              }
                                            }

                                            time = '$time:00 - $next_hour:00';
                                            min = 0;

                                            String b_hour = hour;
                                            //int b_minutes_int = 60 - widget.club['b_minutes'] as int;
                                            String monthN =
                                                '${widget.daySelected.month}';
                                            String dayN =
                                                '${widget.daySelected.day}';

                                            if (widget.daySelected.month < 10) {
                                              monthN =
                                                  '0${widget.daySelected.month}';
                                            }

                                            if (widget.daySelected.day < 10) {
                                              dayN =
                                                  '0${widget.daySelected.day}';
                                            }

                                            int before_hour_int = 0;
                                            int before_c_hour_int = 0;
                                            String before_hour = '';
                                            String before_c_hour = '';
                                            int safe_hour =
                                                widget.club['b_hour'];
                                            int safe_c_hour =
                                                widget.club['c_hour'];
                                            int b_minutes_int = 0;
                                            int c_minutes_int = 0;
                                            String b_minutes = '';
                                            String c_minutes = '';
                                            before_hour_int =
                                                hourInt - safe_hour;
                                            before_c_hour_int =
                                                hourInt - safe_c_hour;

                                            if (widget.club['b_minutes']
                                                    as int !=
                                                0) {
                                              if (widget.club['b_minutes']
                                                      as int <=
                                                  30) {
                                                b_minutes_int = 30 -
                                                        widget.club['b_minutes']
                                                    as int;
                                              } else {
                                                b_minutes_int = 60 -
                                                    ((widget.club['b_minutes']
                                                            as int) -
                                                        30);
                                                before_hour_int =
                                                    before_hour_int - 1;
                                              }
                                            }

                                            if (widget.club['c_minutes']
                                                    as int !=
                                                0) {
                                              if (widget.club['c_minutes']
                                                      as int <=
                                                  30) {
                                                c_minutes_int = 30 -
                                                        widget.club['c_minutes']
                                                    as int;
                                              } else {
                                                c_minutes_int = 60 -
                                                    ((widget.club['c_minutes']
                                                            as int) -
                                                        30);
                                                before_c_hour_int =
                                                    before_c_hour_int - 1;
                                              }
                                            }

                                            if (before_hour_int < 10) {
                                              before_hour = '0$before_hour_int';
                                            } else {
                                              before_hour = '$before_hour_int';
                                            }

                                            if (before_c_hour_int < 10) {
                                              before_c_hour =
                                                  '0$before_c_hour_int';
                                            } else {
                                              before_c_hour =
                                                  '$before_c_hour_int';
                                            }

                                            //int b_minutes_int = widget.club['b_minutes'] as int;

                                            if (b_minutes_int < 10) {
                                              b_minutes = '0$b_minutes_int';
                                            } else {
                                              b_minutes = '$b_minutes_int';
                                            }

                                            if (c_minutes_int < 10) {
                                              c_minutes = '0$c_minutes_int';
                                            } else {
                                              c_minutes = '$c_minutes_int';
                                            }

                                            print(
                                                '2024-$monthN-$dayN $b_hour:$b_minutes:00');
                                            print(availableTime[0]);

                                            if (profile['prenotazioniPremium'] <
                                                    2 &&
                                                availableNextTime[0] ==
                                                    'libero' &&
                                                DateTime.parse(
                                                        '2024-$monthN-$dayN $before_hour:$b_minutes:00')
                                                    .isAfter(DateTime.now())) {
                                              AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.success,
                                                      animType:
                                                          AnimType.topSlide,
                                                      showCloseIcon: true,
                                                      title:
                                                          "Vuoi Prenotare questo orario?",
                                                      titleTextStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: w > 605
                                                              ? 45
                                                              : w > 380
                                                                  ? 30
                                                                  : 25,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                      desc:
                                                          "$dayN/$monthN $time\n una volta prenotato non potrai disdire oltre un certo orario",
                                                      descTextStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: w > 605
                                                              ? 30
                                                              : w > 380
                                                                  ? 20
                                                                  : 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                      btnOkOnPress: () async {
                                                        Navigator.of(context)
                                                            .push(HeroDialogRoute(
                                                                builder:
                                                                    (context) {
                                                          return const LoadingScreen();
                                                        }));

                                                        int hourInt = 0;

                                                        time = day['key'];
                                                        for (int i = 10;
                                                            i < 24;
                                                            i++) {
                                                          if (time == '$i') {
                                                            hour = '$i';
                                                            hourInt = i;
                                                          }
                                                        }
                                                        for (int i = 0;
                                                            i < 10;
                                                            i++) {
                                                          if (time == 'i') {
                                                            hour = '0$i';
                                                            hourInt = i;
                                                          }
                                                        }

                                                        min = 30;

                                                        String b_hour = hour;
                                                        // String b_minutes = '';

                                                        for (int i = 11;
                                                            i < 24;
                                                            i++) {
                                                          if (hour == '$i') {
                                                            b_hour = '${i - 1}';
                                                          }
                                                          if (hour == '09') {
                                                            b_hour = '08';
                                                          }
                                                        }

                                                        //int b_minutes = (widget.club['b_minutes'] as int) - 30;

                                                        String monthN =
                                                            '${widget.daySelected.month}';
                                                        String dayN =
                                                            '${widget.daySelected.day}';

                                                        if (widget.daySelected
                                                                .month <
                                                            10) {
                                                          monthN =
                                                              '0${widget.daySelected.month}';
                                                        }

                                                        if (widget.daySelected
                                                                .day <
                                                            10) {
                                                          dayN =
                                                              '0${widget.daySelected.day}';
                                                        }

                                                        int before_hour_int = 0;
                                                        int before_c_hour_int =
                                                            0;
                                                        String before_hour = '';
                                                        String before_c_hour =
                                                            '';
                                                        int safe_hour = widget
                                                            .club['b_hour'];
                                                        int safe_c_hour = widget
                                                            .club['c_hour'];
                                                        int b_minutes_int = 0;
                                                        int c_minutes_int = 0;
                                                        String b_minutes = '';
                                                        String c_minutes = '';
                                                        before_hour_int =
                                                            hourInt - safe_hour;
                                                        before_c_hour_int =
                                                            hourInt -
                                                                safe_c_hour;

                                                        if (widget.club[
                                                                    'b_minutes']
                                                                as int !=
                                                            0) {
                                                          if (widget.club[
                                                                      'b_minutes']
                                                                  as int <=
                                                              30) {
                                                            b_minutes_int = 30 -
                                                                    widget.club[
                                                                        'b_minutes']
                                                                as int;
                                                          } else {
                                                            b_minutes_int = 60 -
                                                                ((widget.club[
                                                                            'b_minutes']
                                                                        as int) -
                                                                    30);
                                                            before_hour_int =
                                                                before_hour_int -
                                                                    1;
                                                          }
                                                        }

                                                        if (widget.club[
                                                                    'c_minutes']
                                                                as int !=
                                                            0) {
                                                          if (widget.club[
                                                                      'c_minutes']
                                                                  as int <=
                                                              30) {
                                                            c_minutes_int = 30 -
                                                                    widget.club[
                                                                        'c_minutes']
                                                                as int;
                                                          } else {
                                                            c_minutes_int = 60 -
                                                                ((widget.club[
                                                                            'c_minutes']
                                                                        as int) -
                                                                    30);
                                                            before_c_hour_int =
                                                                before_c_hour_int -
                                                                    1;
                                                          }
                                                        }

                                                        if (before_hour_int <
                                                            10) {
                                                          before_hour =
                                                              '0$before_hour_int';
                                                        } else {
                                                          before_hour =
                                                              '$before_hour_int';
                                                        }

                                                        if (before_c_hour_int <
                                                            10) {
                                                          before_c_hour =
                                                              '0$before_c_hour_int';
                                                        } else {
                                                          before_c_hour =
                                                              '$before_c_hour_int';
                                                        }

                                                        //int b_minutes_int = widget.club['b_minutes'] as int;

                                                        if (b_minutes_int <
                                                            10) {
                                                          b_minutes =
                                                              '0$b_minutes_int';
                                                        } else {
                                                          b_minutes =
                                                              '$b_minutes_int';
                                                        }

                                                        if (c_minutes_int <
                                                            10) {
                                                          c_minutes =
                                                              '0$c_minutes_int';
                                                        } else {
                                                          c_minutes =
                                                              '$c_minutes_int';
                                                        }

                                                        final getDate =
                                                            DateConverted
                                                                .getDate(widget
                                                                    .daySelected);
                                                        final getDay = DateConverted
                                                                .getDay(widget
                                                                    .daySelected
                                                                    .weekday)
                                                            .toString();

                                                        String id = FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid;
                                                        String email =
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .email as String;
                                                        int next_hour = 10;
                                                        int previous_hour = 0;

                                                        for (int i = 0;
                                                            i < 15;
                                                            i++) {
                                                          if (hour ==
                                                              '${09 + i}') {
                                                            next_hour = 10 + i;
                                                          }
                                                        }

                                                        for (int i = 1;
                                                            i < 15;
                                                            i++) {
                                                          if (hour ==
                                                              '${09 + i}') {
                                                            previous_hour =
                                                                9 + i - 1;
                                                          }
                                                        }

                                                        for (int i = 10;
                                                            i < 21;
                                                            i++) {
                                                          if (hour == '$i') {
                                                            b_hour = '${i + 1}';
                                                          }
                                                          if (hour == '09') {
                                                            b_hour = '10';
                                                          }
                                                        }
                                                        time =
                                                            '$time:30 - $next_hour:30';

                                                        if (profile['prenotazioniPremium'] <
                                                                2 &&
                                                            availableNextTime[
                                                                    0] ==
                                                                'libero' &&
                                                            DateTime.parse(
                                                                    '2024-$monthN-$dayN $before_hour:$b_minutes:00')
                                                                .isAfter(DateTime
                                                                    .now())) {
                                                          updateToServer1(
                                                              email,
                                                              widget.daySelected
                                                                  .day
                                                                  .toString(),
                                                              time,
                                                              getMonth,
                                                              widget.pitch[
                                                                  'title'],
                                                              hour,
                                                              widget.pitch[
                                                                  'first_hour'],
                                                              widget.pitch[
                                                                  'last_hour'],
                                                              widget.club[
                                                                  'dbURL'],
                                                              widget.pitch[
                                                                  'sport'],
                                                              widget.club[
                                                                  'title']);

                                                          sendToServer(
                                                              id,
                                                              email,
                                                              widget.pitch[
                                                                  'club'],
                                                              widget.pitch[
                                                                  'title'],
                                                              '${widget.daySelected.day}/${widget.daySelected.month}/${widget.daySelected.year}',
                                                              widget.daySelected
                                                                  .day
                                                                  .toString(),
                                                              time,
                                                              getMonth,
                                                              widget.daySelected
                                                                  .day
                                                                  .toString(),
                                                              1,
                                                              widget.pitch[
                                                                  'teamSize'],
                                                              hour,
                                                              min,
                                                              monthN,
                                                              dayN,
                                                              profile[
                                                                  'username'],
                                                              '$getMonth-${widget.daySelected.day.toString()}-$time',
                                                              1,
                                                              widget.pitch[
                                                                  'sport'],
                                                              widget.pitch[
                                                                  'first_hour'],
                                                              widget.pitch[
                                                                  'last_hour'],
                                                              widget.club[
                                                                  'dbURL'],
                                                              before_c_hour,
                                                              c_minutes);

                                                          print(
                                                              'token ${widget.club['token']}');
                                                          sendPushMessage(widget
                                                              .club['token']);

                                                          //print(b_hour);
                                                          //print(b_minutes);

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "User")
                                                              .doc(email)
                                                              .update({
                                                            'prenotazioni':
                                                                profile['prenotazioni'] +
                                                                    1
                                                          });

                                                          Navigator.of(context)
                                                              .push(HeroDialogRoute(
                                                                  builder:
                                                                      (context) {
                                                            return PopUpAppointmentClub(
                                                              hour:
                                                                  '${snapshot.key.toString()}:30 - $next_hour:30',
                                                              date:
                                                                  '$dayN / $monthN',
                                                              w: w,
                                                              h: h,
                                                              sport:
                                                                  widget.pitch[
                                                                      'sport'],
                                                              email: email,
                                                            );
                                                          }));
                                                        }
                                                      },
                                                      btnOkIcon: Icons.thumb_up,
                                                      btnOkText: "CONFERMA",
                                                      btnOkColor:
                                                          kBackgroundColor2)
                                                  .show();
                                            } else {
                                              if (profile[
                                                      'prenotazioniPremium'] >=
                                                  3) {
                                                Get.snackbar('', "",
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                    titleText: Text(
                                                      'Hai già ${profile['prenotazioniPremium']} partite in programma o in attesa di risultato',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          letterSpacing: 1,
                                                          fontSize: w < 380
                                                              ? 13
                                                              : w > 605
                                                                  ? 18
                                                                  : 15),
                                                    ),
                                                    messageText: Text(
                                                      "Conferma, cancella o archivia una partita creata per prenotare di nuovo",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 1,
                                                          fontSize: w < 380
                                                              ? 13
                                                              : w > 605
                                                                  ? 18
                                                                  : 15),
                                                    ),
                                                    duration: const Duration(
                                                        seconds: 6),
                                                    backgroundColor: Colors
                                                        .redAccent
                                                        .withOpacity(0.6),
                                                    colorText: Colors.black);
                                              } else {
                                                if (DateTime.parse(
                                                            '2024-$monthN-$dayN $before_hour:$b_minutes:00')
                                                        .isAfter(
                                                            DateTime.now()) !=
                                                    true) {
                                                  Get.snackbar('', "",
                                                      snackPosition:
                                                          SnackPosition.TOP,
                                                      titleText: Text(
                                                        'Impossibile prenotare questo appuntamento',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            letterSpacing: 1,
                                                            fontSize: w < 380
                                                                ? 13
                                                                : w > 605
                                                                    ? 18
                                                                    : 15),
                                                      ),
                                                      messageText: Text(
                                                        "fuori tempo massimo",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 1,
                                                            fontSize: w < 380
                                                                ? 13
                                                                : w > 605
                                                                    ? 18
                                                                    : 15),
                                                      ),
                                                      duration: const Duration(
                                                          seconds: 4),
                                                      backgroundColor: Colors
                                                          .redAccent
                                                          .withOpacity(0.6),
                                                      colorText: Colors.black);
                                                } else {
                                                  Get.snackbar('', "",
                                                      snackPosition:
                                                          SnackPosition.TOP,
                                                      titleText: Text(
                                                        'Impossibile prenotare questo appuntamento',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            letterSpacing: 1,
                                                            fontSize: w < 380
                                                                ? 13
                                                                : w > 605
                                                                    ? 18
                                                                    : 15),
                                                      ),
                                                      messageText: Text(
                                                        "seleziona un orario disponibile",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 1,
                                                            fontSize: w < 380
                                                                ? 13
                                                                : w > 605
                                                                    ? 18
                                                                    : 15),
                                                      ),
                                                      duration: const Duration(
                                                          seconds: 4),
                                                      backgroundColor: Colors
                                                          .redAccent
                                                          .withOpacity(0.6),
                                                      colorText: Colors.black);
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ]);
                              }),
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                  //          ),
                );
              }
              return Container();
            }))));
  }
}

void sendToServer(
    String id,
    String email,
    String club,
    String campo,
    String date,
    String day,
    String time,
    String month,
    String giorno,
    int playerCount,
    int teamSize,
    String hour,
    int minutes,
    String meseN,
    String dayN,
    String host,
    String dateURL,
    int counter,
    String sport,
    int first_hour,
    int last_hour,
    String dbURL,
    String c_hour,
    String c_minutes) {
  FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child(sport)
      .child('$month-$day-$time')
      .set({
    'id': id,
    'email': email,
    'club': club,
    'campo': campo,
    'date': date,
    'day': day,
    'month': month,
    'meseN': meseN,
    'dayN': dayN,
    'time': time,
    'hour': hour,
    'minutes': minutes,
    'playerCount1': playerCount,
    'playerCount2': playerCount - 1,
    'playerCount1Tot': playerCount,
    'playerCount2Tot': playerCount - 1,
    'teamSize': teamSize,
    'caricato': false,
    'host': host,
    'dateURL': dateURL,
    'permissions': counter,
    'team1_P1': email,
    'sport': sport,
    'first_hour': first_hour,
    'last_hour': last_hour,
    'dbURL': dbURL,
    't1p1 goals': 0,
    'c_hour': c_hour,
    'c_minutes': c_minutes,
    'crea_match': false,
  });
}

void updateToServer(
    String email,
    String day,
    String time,
    String month,
    String pitch,
    String hour,
    int first_hour,
    last_hour,
    String dbURL,
    String sport,
    String club) {
  int hourInt = 09;
  String prev_hour = '';
  String next_hour = '';

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
    prev_hour = '0${hourInt - 1}';
  } else {
    prev_hour = '${hourInt - 1}';
  }
  if (hourInt < 9) {
    next_hour = '0${hourInt + 1}';
  } else {
    next_hour = '${hourInt + 1}';
  }

  FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
      .ref()
      .child('Calendario')
      .child(month)
      .child(day)
      .child(pitch)
      .child(hour)
      .update({
    'isTimeAvailable': false,
    'user': email,
    'half_hour': false,
  });

  if (club == 'Athletic Pavia' && pitch == 'Campo 7') {
    FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
        .ref()
        .child('Calendario')
        .child(month)
        .child(day)
        .child('Campo 4')
        .child(hour)
        .update({
      'isTimeAvailable': false,
      'user': email,
      'half_hour': false,
    });

    FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
        .ref()
        .child('Calendario')
        .child(month)
        .child(day)
        .child('Campo 5')
        .child(hour)
        .update({
      'isTimeAvailable': false,
      'user': email,
      'half_hour': false,
    });

    FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
        .ref()
        .child('Calendario')
        .child(month)
        .child(day)
        .child('Campo 6')
        .child(hour)
        .update({
      'isTimeAvailable': false,
      'user': email,
      'half_hour': false,
    });
  }

  if (club == 'Athletic Pavia' &&
      (pitch == 'Campo 6' || pitch == 'Campo 5' || pitch == 'Campo 4')) {
    FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
        .ref()
        .child('Calendario')
        .child(month)
        .child(day)
        .child('Campo 7')
        .child(hour)
        .update({
      'isTimeAvailable': false,
      'user': email,
      'half_hour': false,
    });
  }

  if (hourInt != first_hour) {
    FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
        .ref()
        .child('Calendario')
        .child(month)
        .child(day)
        .child(pitch)
        .child(prev_hour)
        .update({
      'half_hour': false,
    });

    if (club == 'Athletic Pavia' && pitch == 'Campo 7') {
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child('Campo 4')
          .child(prev_hour)
          .update({
        'half_hour': false,
      });

      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child('Campo 5')
          .child(prev_hour)
          .update({
        'half_hour': false,
      });

      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child('Campo 6')
          .child(prev_hour)
          .update({
        'half_hour': false,
      });
    }

    if (club == 'Athletic Pavia' &&
        (pitch == 'Campo 6' || pitch == 'Campo 5' || pitch == 'Campo 4')) {
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child('Campo 7')
          .child(prev_hour)
          .update({
        'half_hour': false,
      });
    }
  }

  if (sport == 'tennis') {
    if (hourInt != last_hour) {
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child(pitch)
          .child(next_hour)
          .update({
        'isTimeAvailable': false,
      });
    }
    if (hourInt != first_hour) {
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child(pitch)
          .child(prev_hour)
          .update({'half_hour': false, 'isTimeAvailable': false});
    }
  }
}

void updateToServer1(
    String email,
    String day,
    String time,
    String month,
    String pitch,
    String hour,
    int first_hour,
    int last_hour,
    String dbURL,
    String sport,
    String club) {
  int hourInt = 09;
  String prev_hour = '';
  String next_hour = '';

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
    prev_hour = '0${hourInt - 1}';
  } else {
    prev_hour = '${hourInt - 1}';
  }
  if (hourInt < 9) {
    next_hour = '0${hourInt + 1}';
  } else {
    next_hour = '${hourInt + 1}';
  }

  if (hourInt != last_hour) {
    FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
        .ref()
        .child('Calendario')
        .child(month)
        .child(day)
        .child(pitch)
        .child(next_hour)
        .update({
      'isTimeAvailable': false,
    });

    if (club == 'Athletic Pavia' && pitch == 'Campo 7') {
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child('Campo 4')
          .child(next_hour)
          .update({
        'isTimeAvailable': false,
      });

      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child('Campo 5')
          .child(next_hour)
          .update({
        'isTimeAvailable': false,
      });

      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child('Campo 6')
          .child(next_hour)
          .update({
        'isTimeAvailable': false,
      });
    }

    if (club == 'Athletic Pavia' &&
        (pitch == 'Campo 6' || pitch == 'Campo 5' || pitch == 'Campo 4')) {
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child('Campo 7')
          .child(next_hour)
          .update({
        'isTimeAvailable': false,
      });
    }
  }

  if (sport == 'tennis') {
    if (hourInt != first_hour) {
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child(pitch)
          .child(prev_hour)
          .update({
        'half_hour': false,
      });
    }
    if (hourInt != last_hour) {
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
          .ref()
          .child('Calendario')
          .child(month)
          .child(day)
          .child(pitch)
          .child(next_hour)
          .update({
        'half_hour': false,
      });
    }
  }

  FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
      .ref()
      .child('Calendario')
      .child(month)
      .child(day)
      .child(pitch)
      .child(hour)
      .update(
          {'isTimeAvailable': false, 'half_hour': false, 'user_half': email});
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
            'title': 'Nuova Prenotazione!',
            'body':
                'Controlla il calendario, nuovi campi sono stati prenotati.',
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
