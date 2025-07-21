import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/page/football_results_page.dart';
import 'package:sports_hub_ios/page/tennis_result_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Crea_Match/football_create_results_page.dart';
import 'package:sports_hub_ios/widgets/Results_Games/teammate_carousel.dart';

class PopUpChange1 extends StatefulWidget {
  const PopUpChange1({
    super.key,
    required this.appointment,
    required this.p,
    required this.teammate,
    required this.h,
    required this.w,
    required this.sport,
    required this.ospite,
    required this.list1,
  });

  final Map appointment;
  final int p;

  final double h;
  final double w;

  final List teammate;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<PopUpChange1> createState() => PopUpChange1State();
}

class PopUpChange1State extends State<PopUpChange1> {
  @override
  Widget build(BuildContext context) {
    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    Map appointmentData = {};

    int counter = widget.appointment['playerCount1'];
    if (widget.ospite == false) {
      counter--;
    }

    String address = '';

    widget.sport == 'football'
        ? widget.appointment['crea_match']
            ? address = 'football/Crea_Match'
            : address = 'football'
        : address = 'tennis';

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 100 : 40),
                width: widget.w * 0.8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    SizedBox(height: widget.h * 0.03),
                    Container(
                      width: widget.w * 0.6,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h * 0.015,
                      ),
                      //margin: EdgeInsets.only(top: h*0.02),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kBackgroundColor2,
                      ),

                      child: Column(
                        children: [
                          SizedBox(height: widget.h * 0.01),
                          DefaultTextStyle(
                            style: TextStyle(
                                fontSize: widget.w > 385 ? 15 : 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            child: Center(
                              child: Text(
                                'Sostituisci il giocatore:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.w > 605
                                        ? 25
                                        : widget.w > 385
                                            ? 18
                                            : 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: widget.h * 0.03,
                    ),
                    Container(
                      height: widget.h * 0.07,
                      width: widget.w * 0.6,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.black, width: 1),
                        color: Colors.red,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          sendOspiteToServer1(
                              uid,
                              utente,
                              widget.appointment['club'],
                              widget.appointment['campo'],
                              widget.appointment['day'],
                              widget.appointment['time'],
                              widget.appointment['month'],
                              'ospite',
                              widget.p + 2,
                              counter,
                              widget.sport,
                              widget.appointment['crea_match']);


                          FirebaseDatabase.instanceFor(
                                  app: Firebase.app(),
                                  databaseURL: dbPrenotazioniURL)
                              .ref(
                                  'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/$address/${widget.appointment['dateURL']}')
                              .onValue
                              .listen((DatabaseEvent event) {
                            final data = event.snapshot.value as Map;

                            appointmentData.assignAll(data);
                          });

                          if (appointmentData.isEmpty) {
                            appointmentData.assignAll(widget.appointment);
                            print('empty');
                          }

                          Future.delayed(const Duration(milliseconds: 500), () {
                            appointmentData.isEmpty
                                ? appointmentData = widget.appointment
                                : Container();
                            if (widget.sport == 'football') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FootballResultsPage(
                                            appointment: appointmentData,
                                            create: false,
                                          )));
                            }
                            if (widget.sport == 'tennis') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TennisResultsPage(
                                          appointment: appointmentData)));
                            }
                          });
                        },
                        child: Center(
                          child: DefaultTextStyle(
                            style: TextStyle(
                                fontSize: widget.h > 800
                                    ? 18
                                    : widget.w > 385
                                        ? 14
                                        : 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            child: const Text(
                              'SOSTITUISCI CON OSPITE',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.h * 0.01),
                    ChangeCarousel1(
                      appointment: widget.appointment,
                      p: widget.p,
                      allTeammate: widget.teammate,
                      sport: widget.sport,
                      ospite: widget.ospite,
                      list1: widget.list1,
                    ),
                  ],
                ))));
  }
}

class PopUpChange2 extends StatefulWidget {
  const PopUpChange2({
    super.key,
    required this.appointment,
    required this.p,
    required this.teammate,
    required this.h,
    required this.w,
    required this.sport,
    required this.ospite,
    required this.list1,
  });

  final Map appointment;
  final int p;

  final double h;
  final double w;

  final List teammate;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<PopUpChange2> createState() => PopUpChangeState();
}

class PopUpChangeState extends State<PopUpChange2> {
  @override
  Widget build(BuildContext context) {
    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    Map appointmentData = {};

    int counter = widget.appointment['playerCount2'];
    if (widget.ospite == false) {
      counter--;
    }

    String address = '';

    widget.sport == 'football'
        ? widget.appointment['crea_match']
            ? address = 'football/Crea_Match'
            : address = 'football'
        : address = 'tennis';

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 100 : 40),
                width: widget.w * 0.8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    SizedBox(height: widget.h * 0.03),
                    Container(
                      width: widget.w * 0.6,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h * 0.015,
                      ),
                      //margin: EdgeInsets.only(top: h*0.02),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kBackgroundColor2,
                      ),

                      child: Column(
                        children: [
                          SizedBox(height: widget.h * 0.01),
                          DefaultTextStyle(
                            style: TextStyle(
                                fontSize: widget.w > 385 ? 15 : 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            child: Center(
                              child: Text(
                                'Sostituisci il giocatore:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.w > 605
                                        ? 25
                                        : widget.w > 380
                                            ? 18
                                            : 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: widget.h * 0.03,
                    ),
                    Container(
                      height: widget.h * 0.071,
                      width: widget.w * 0.6,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.black, width: 1),
                        color: Colors.red,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          sendOspiteToServer2(
                              uid,
                              utente,
                              widget.appointment['club'],
                              widget.appointment['campo'],
                              widget.appointment['day'],
                              widget.appointment['time'],
                              widget.appointment['month'],
                              'ospite',
                              widget.p + 1,
                              counter,
                              widget.sport,
                              widget.appointment['crea_match']);


                          FirebaseDatabase.instanceFor(
                                  app: Firebase.app(),
                                  databaseURL: dbPrenotazioniURL)
                              .ref(
                                  'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/$address/${widget.appointment['dateURL']}')
                              .onValue
                              .listen((DatabaseEvent event) async {
                            final data = event.snapshot.value as Map;

                            appointmentData.assignAll(data);
                          });

                          if (appointmentData.isEmpty) {
                            appointmentData.assignAll(widget.appointment);
                            print('empty');
                          }

                          Future.delayed(const Duration(milliseconds: 500), () {
                            appointmentData.isEmpty
                                ? appointmentData = widget.appointment
                                : Container();
                            widget.sport == 'football'
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FootballResultsPage(
                                              appointment: appointmentData,
                                              create: false,
                                            )))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TennisResultsPage(
                                            appointment: appointmentData)));
                          });
                        },
                        child: Center(
                          child: DefaultTextStyle(
                            style: TextStyle(
                                fontSize: widget.h > 800
                                    ? 18
                                    : widget.w > 385
                                        ? 14
                                        : 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            child: const Text(
                              'SOSTITUISCI CON OSPITE',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.h * 0.01),
                    ChangeCarousel2(
                      appointment: widget.appointment,
                      p: widget.p,
                      teammate: widget.teammate,
                      sport: widget.sport,
                      ospite: widget.ospite,
                      list1: widget.list1,
                    ),
                  ],
                ))));
  }
}

class PopUpCreateChange1 extends StatefulWidget {
  const PopUpCreateChange1({
    super.key,
    required this.appointment,
    required this.p,
    required this.teammate,
    required this.h,
    required this.w,
    required this.sport,
    required this.ospite,
    required this.list1,
  });

  final Map appointment;
  final int p;

  final double h;
  final double w;

  final List teammate;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<PopUpCreateChange1> createState() => PopUpCreateChange1State();
}

class PopUpCreateChange1State extends State<PopUpCreateChange1> {
  @override
  Widget build(BuildContext context) {
    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    Map appointmentData = {};

    int counter = widget.appointment['playerCount1'];
    if (widget.ospite == false) {
      counter--;
    }

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 100 : 40),
                width: widget.w * 0.8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    SizedBox(height: widget.h * 0.03),
                    Container(
                      width: widget.w * 0.6,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h * 0.015,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kBackgroundColor2,
                      ),

                      child: Column(
                        children: [
                          SizedBox(height: widget.h * 0.01),
                          DefaultTextStyle(
                            style: TextStyle(
                                fontSize: widget.w > 385 ? 15 : 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            child: Center(
                              child: Text(
                                'Sostituisci il giocatore:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.w > 605
                                        ? 25
                                        : widget.w > 385
                                            ? 18
                                            : 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: widget.h * 0.03,
                    ),
                    Container(
                      height: widget.h * 0.07,
                      width: widget.w * 0.6,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.black, width: 1),
                        color: Colors.red,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          sendOspiteToServer1Create(
                              uid,
                              utente,
                              widget.appointment['club'],
                              widget.appointment['campo'],
                              widget.appointment['day'],
                              widget.appointment['time'],
                              widget.appointment['month'],
                              'ospite',
                              widget.p + 2,
                              counter,
                              widget.sport,
                              widget.appointment['city']);

                          FirebaseDatabase.instanceFor(
                                  app: Firebase.app(),
                                  databaseURL: dbPrenotazioniURL)
                              .ref(
                                  'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/${widget.sport}/Crea_Match/${widget.appointment['dateURL']}')
                              .onValue
                              .listen((DatabaseEvent event) {
                            final data = event.snapshot.value as Map;

                            appointmentData.assignAll(data);
                          });

                          if (appointmentData.isEmpty) {
                            appointmentData.assignAll(widget.appointment);
                          }

                          Future.delayed(const Duration(milliseconds: 500), () {
                            appointmentData.isEmpty
                                ? appointmentData = widget.appointment
                                : Container();
                            if (widget.sport == 'football') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FootballCreateResultsPage(
                                              appointment: appointmentData)));
                            }
                            if (widget.sport == 'tennis') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TennisResultsPage(
                                          appointment: appointmentData)));
                            }
                          });
                        },
                        child: Center(
                          child: DefaultTextStyle(
                            style: TextStyle(
                                fontSize: widget.h > 800
                                    ? 18
                                    : widget.w > 385
                                        ? 14
                                        : 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            child: const Text(
                              'SOSTITUISCI CON OSPITE',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.h * 0.01),
                    ChangeCreateCarousel1(
                      appointment: widget.appointment,
                      p: widget.p,
                      allTeammate: widget.teammate,
                      sport: widget.sport,
                      ospite: widget.ospite,
                      list1: widget.list1,
                    ),
                  ],
                ))));
  }
}

class PopUpCreateChange2 extends StatefulWidget {
  const PopUpCreateChange2({
    super.key,
    required this.appointment,
    required this.p,
    required this.teammate,
    required this.h,
    required this.w,
    required this.sport,
    required this.ospite,
    required this.list1,
  });

  final Map appointment;
  final int p;

  final double h;
  final double w;

  final List teammate;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<PopUpCreateChange2> createState() => PopUpCreateChangeState();
}

class PopUpCreateChangeState extends State<PopUpCreateChange2> {
  @override
  Widget build(BuildContext context) {
    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    Map appointmentData = {};

    int counter = widget.appointment['playerCount2'];
    if (widget.ospite == false) {
      counter--;
    }

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 100 : 40),
                width: widget.w * 0.8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    SizedBox(height: widget.h * 0.03),
                    Container(
                      width: widget.w * 0.6,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h * 0.015,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kBackgroundColor2,
                      ),

                      child: Column(
                        children: [
                          SizedBox(height: widget.h * 0.01),
                          DefaultTextStyle(
                            style: TextStyle(
                                fontSize: widget.w > 385 ? 15 : 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            child: Center(
                              child: Text(
                                'Sostituisci il giocatore:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.w > 605
                                        ? 25
                                        : widget.w > 380
                                            ? 18
                                            : 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: widget.h * 0.03,
                    ),
                    Container(
                      height: widget.h * 0.071,
                      width: widget.w * 0.6,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.black, width: 1),
                        color: Colors.red,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          sendOspiteToServer2Create(
                              uid,
                              utente,
                              widget.appointment['club'],
                              widget.appointment['campo'],
                              widget.appointment['day'],
                              widget.appointment['time'],
                              widget.appointment['month'],
                              'ospite',
                              widget.p + 1,
                              counter,
                              widget.sport,
                              widget.appointment['city']);

                          FirebaseDatabase.instanceFor(
                                  app: Firebase.app(),
                                  databaseURL: dbPrenotazioniURL)
                              .ref(
                                  'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/${widget.sport}/Crea_Match/${widget.appointment['dateURL']}')
                              .onValue
                              .listen((DatabaseEvent event) async {
                            final data = event.snapshot.value as Map;

                            appointmentData.assignAll(data);
                          });


                          if (appointmentData.isEmpty) {
                            appointmentData.assignAll(widget.appointment);
                            print('if');
                          }

                          Future.delayed(const Duration(milliseconds: 500), () {
                            appointmentData.isEmpty
                                ? appointmentData = widget.appointment
                                : Container();
                            widget.sport == 'football'
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FootballCreateResultsPage(
                                                appointment: appointmentData)))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TennisResultsPage(
                                            appointment: appointmentData)));
                          });
                        },
                        child: Center(
                          child: DefaultTextStyle(
                            style: TextStyle(
                                fontSize: widget.h > 800
                                    ? 18
                                    : widget.w > 385
                                        ? 14
                                        : 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            child: const Text(
                              'SOSTITUISCI CON OSPITE',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.h * 0.01),
                    ChangeCreateCarousel2(
                      appointment: widget.appointment,
                      p: widget.p,
                      teammate: widget.teammate,
                      sport: widget.sport,
                      ospite: widget.ospite,
                      list1: widget.list1,
                    ),
                  ],
                ))));
  }
}

void sendOspiteToServer1(
    String uid,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    String selectedUser,
    int p,
    int playerCount1,
    String sport,
    bool crea_match) async {
  String address = '';
  crea_match ? address = '$sport/Crea_Match' : address = sport;

  await FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(uid)
      .child(address)
      .child('$month-$day-$time')
      .update({
    'team1_P$p': selectedUser,
    'playerCount1': playerCount1
  });
}

void sendOspiteToServer2(
    String id,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    String selectedUser,
    int p,
    int playerCount2,
    String sport,
    bool crea_match) async {
  String address = '';
  crea_match ? address = '$sport/Crea_Match' : address = sport;

  await FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child(address)
      .child('$month-$day-$time')
      .update({
    //'team1_P1': selectedUser,
    'team2_P$p': selectedUser,
    'playerCount2': playerCount2
  });
}

void sendOspiteToServer1Create(
    String uid,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    String selectedUser,
    int p,
    int playerCount1,
    String sport,
    String city) async {
  await FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(uid)
      .child(sport)
      .child('Crea_Match')
      .child('$month-$day-$time')
      .update({
    'team1_P$p': selectedUser,
    'playerCount1': playerCount1
  });

  await FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbCreaMatchURL)
      .ref()
      .child('Prenotazioni')
      .child('Crea_Match')
      .child(city)
      .child(sport)
      .child('$month-$day-$time')
      .update({
    'team1_P$p': selectedUser,
    'playerCount1': playerCount1
  });
}

void sendOspiteToServer2Create(
    String id,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    String selectedUser,
    int p,
    int playerCount2,
    String sport,
    String city) async {
  await FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child(sport)
      .child('Crea_Match')
      .child('$month-$day-$time')
      .update({
    'team2_P$p': selectedUser,
    'playerCount2': playerCount2
  });

  await FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbCreaMatchURL)
      .ref()
      .child('Prenotazioni')
      .child('Crea_Match')
      .child(city)
      .child(sport)
      .child('$month-$day-$time')
      .update({
    'team2_P$p': selectedUser,
    'playerCount2': playerCount2
  });
}
