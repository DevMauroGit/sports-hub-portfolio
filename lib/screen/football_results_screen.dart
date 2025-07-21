import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/models/user_model.dart';
import 'package:sports_hub_ios/page/football_results_page.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Results_Games/score_card.dart';
import 'package:sports_hub_ios/widgets/Results_Games/team_popup_card.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';

int totTeam1 = 0;
int totTeam2 = 0;

int t1p1 = 0;
int t1p2 = 0;
int t1p3 = 0;
int t1p4 = 0;
int t1p5 = 0;
int t1p6 = 0;
int t1p7 = 0;
int t1p8 = 0;
int t1p9 = 0;

int t2p1 = 0;
int t2p2 = 0;
int t2p3 = 0;
int t2p4 = 0;
int t2p5 = 0;
int t2p6 = 0;
int t2p7 = 0;
int t2p8 = 0;
int t2p9 = 0;

int counter1 = 0;

late List<String> list2;
int counter2 = 0;

class FootballResultsScreen extends StatefulWidget {
  const FootballResultsScreen(
      {super.key,
      required this.allTeammate,
      required this.allTeammateData,
      required this.h,
      required this.w,
      required this.appointment,
      required this.list1});

  final List allTeammate;
  final List allTeammateData;

  final double h;
  final double w;

  final Map appointment;

  final List list1;

  @override
  State<FootballResultsScreen> createState() => _FootballResultsScreenState();
}

class _FootballResultsScreenState extends State<FootballResultsScreen> {
  var goalsCounter = 0;
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  List allTeammate = [];
  final allTeam1 = <Map<String, dynamic>>[].obs;

  //AppointmentController appointmentController = Get.put(AppointmentController("${appointment['club']}-${appointment['month']}-${appointment['day']}-${appointment['campo']}-${appointment['time']}"));
  CollectionReference user = FirebaseFirestore.instance.collection('User');
  final String utente = FirebaseAuth.instance.currentUser!.email.toString();
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 380));

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    List list1 = widget.list1;

    totTeam1 = 0;
    totTeam2 = 0;
    t1p1 = 0;
    t1p2 = 0;
    t1p3 = 0;
    t1p4 = 0;
    t1p5 = 0;
    t2p1 = 0;
    t2p2 = 0;
    t2p3 = 0;
    t2p4 = 0;
    t2p5 = 0;

    print(widget.appointment['dateURL']);

    widget.appointment['playerCount1Tot'] == null
        ? WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => FootballResultsPage(
                      appointment: widget.appointment,
                      create: false,
                    )));
          })
        : null;

    return Column(children: [
      //SizedBox(height: widget.h * 0.01),
      Center(
          child: Container(
              height: h > 800
                  ? h * 0.85
                  : h > 700
                      ? widget.h * 0.82
                      : widget.h * 0.85,
              width: widget.w * 0.9,
              margin: const EdgeInsets.only(bottom: kDefaultPadding),
              padding: const EdgeInsets.only(bottom: kDefaultPadding),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: kBackgroundColor2,
              ),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Column(children: [
                    SizedBox(height: widget.h * 0.02),
                    SizedBox(
                      child: Image.asset("assets/images/tabellone.png"),
                    ),
                    SizedBox(height: widget.h * 0.01),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: w > 605 ? 0 : w * 0.01),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(widget.appointment['club'].toString(),
                                  style: TextStyle(
                                      fontSize: w > 605
                                          ? 25
                                          : widget.w > 380
                                              ? 16
                                              : 11,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500)),
                              Text(widget.appointment['campo'].toString(),
                                  style: TextStyle(
                                      fontSize: w > 605
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
                                      fontSize: w > 605
                                          ? 25
                                          : widget.w > 380
                                              ? 16
                                              : 11,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500)),
                              Text(widget.appointment['time'].toString(),
                                  style: TextStyle(
                                      fontSize: w > 605
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
                            height: h > 700 ? widget.h * 0.55 : widget.h * 0.57,
                            width: widget.w * 0.85,
                            color: kBackgroundColor2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    ScoreCardP1(
                                      user: utente,
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
                                        width: w > 385 ? w * 0.35 : w * 0.38,
                                        child: ListView.builder(
                                            itemCount: widget.appointment[
                                                    'playerCount1Tot'] -
                                                1,
                                            itemBuilder: (
                                              BuildContext context,
                                              index,
                                            ) =>
                                                ScoreCard1(
                                                  user: widget.appointment[
                                                      'team1_P${index + 2}'],
                                                  player: index,
                                                  p: index,
                                                  date: widget
                                                      .appointment['dateURL'],
                                                  appointment:
                                                      widget.appointment,
                                                  allTeammateData:
                                                      widget.allTeammateData,
                                                  list1: widget.list1,
                                                )),
                                      ),

                                    SizedBox(height: widget.h * 0.012),

                                    const ScoreCardOspite(
                                      user: 'ospite',
                                      team: 1,
                                    ),
                                    //SizedBox(height: h*0.02),
                                    SizedBox(
                                        height: widget.h > 700
                                            ? widget.h * 0.02
                                            : widget.h * 0.03,
                                        width: widget.w * 0.33,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (widget.appointment[
                                                    'playerCount1'] <
                                                widget
                                                    .appointment['teamSize']) {
                                              Navigator.of(context).push(
                                                HeroDialogRoute(
                                                    builder: (context) {
                                                  return TeamPopupCard1(
                                                    appointment:
                                                        widget.appointment,
                                                    h: widget.h,
                                                    w: widget.w,
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection('User')
                                                        .doc(email)
                                                        .collection('Friends')
                                                        .where('isRequested',
                                                            isEqualTo: 'false')
                                                        .get(),
                                                    allTeammate:
                                                        widget.allTeammate,
                                                    allTeammateData:
                                                        widget.allTeammateData,
                                                    sport: 'football',
                                                    list1: list1,
                                                  );
                                                }),
                                              );
                                            } else {
                                              Get.snackbar('', "",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  titleText: Text(
                                                    'Impossibile aggiungere giocatore',
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
                                                    "Il Team è già pieno",
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
                                                  colorText: Colors.black);
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: h * 0.001,
                                                horizontal: w * 0.01),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: kPrimaryColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Aggiungi giocatore +',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    letterSpacing: 0.25,
                                                    fontSize: w > 605
                                                        ? 15
                                                        : widget.w > 385
                                                            ? 10
                                                            : 7,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                                Container(
                                  //alignment: Alignment.topCenter,
                                  //margin: EdgeInsets.only(bottom: h*0.15),
                                  height: widget.h > 800
                                      ? widget.h * 0.6
                                      : widget.h > 700
                                          ? widget.h * 0.63
                                          : widget.h * 0.55,
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
                                        width: w > 385 ? w * 0.35 : w * 0.38,
                                        child: ListView.builder(
                                            itemCount: widget
                                                .appointment['playerCount2Tot'],
                                            itemBuilder: (
                                              BuildContext context,
                                              index,
                                            ) =>
                                                Column(
                                                  children: [
                                                    ScoreCard(
                                                      user: widget.appointment[
                                                          'team2_P${index + 1}'],
                                                      player: index,
                                                      appointment:
                                                          widget.appointment,
                                                      date: widget.appointment[
                                                          'dateURL'],
                                                      p: index,
                                                      allTeammateData: widget
                                                          .allTeammateData,
                                                      list1: widget.list1,
                                                    ),
                                                  ],
                                                )),
                                      ),
                                    SizedBox(height: widget.h * 0.013),
                                    const ScoreCardOspite(
                                      user: 'ospite',
                                      team: 2,
                                    ),
                                    SizedBox(
                                        height: widget.h > 700
                                            ? widget.h * 0.02
                                            : widget.h * 0.03,
                                        width: widget.w * 0.33,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (widget.appointment[
                                                    'playerCount2Tot'] <
                                                widget
                                                    .appointment['teamSize']) {
                                              Navigator.of(context).push(
                                                HeroDialogRoute(
                                                    builder: (context) {
                                                  return TeamPopupCard2(
                                                    appointment:
                                                        widget.appointment,
                                                    date: widget
                                                        .appointment['dateURL'],
                                                    h: widget.h,
                                                    w: widget.w,
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection('User')
                                                        .doc(email)
                                                        .collection('Friends')
                                                        .where('isRequested',
                                                            isEqualTo: 'false')
                                                        .get(),
                                                    allTeammate:
                                                        widget.allTeammate,
                                                    allTeammateData:
                                                        widget.allTeammateData,
                                                    sport: 'football',
                                                    list1: list1,
                                                  );
                                                }),
                                              );
                                            } else {
                                              Get.snackbar('', "",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  titleText: Text(
                                                    'Impossibile aggiungere giocatore',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      letterSpacing: 1,
                                                      fontSize: w < 380
                                                          ? 13
                                                          : w > 605
                                                              ? 18
                                                              : 15,
                                                    ),
                                                  ),
                                                  messageText: Text(
                                                    "Il Team è già pieno",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 1,
                                                      fontSize: w > 605
                                                          ? 20
                                                          : widget.w > 380
                                                              ? 15
                                                              : 13,
                                                    ),
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 4),
                                                  backgroundColor: Colors
                                                      .redAccent
                                                      .withOpacity(0.6),
                                                  colorText: Colors.black);
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: h * 0.001,
                                                horizontal: w * 0.01),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: kPrimaryColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Aggiungi giocatore +',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    letterSpacing: 0.25,
                                                    fontSize: w > 605
                                                        ? 15
                                                        : widget.w > 385
                                                            ? 10
                                                            : 7,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: widget.h * 0.02),
                          //Center(
                          // child: Column(
                          //   children: [
                          //     Text('FINALE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                          //     Text('$totTeam1 - $totTeam2', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
                          //   ],
                          // ),
                          //),
                          AnimatedButton(
                            isFixedHeight: false,
                            height: widget.h * 0.05,
                            width: widget.w * 0.4,
                            text: "CONFERMA",
                            buttonTextStyle: TextStyle(
                                letterSpacing: 0.5,
                                color: Colors.black,
                                fontSize: w > 385 ? 14 : 12,
                                fontWeight: FontWeight.bold),
                            color: kPrimaryColor,
                            pressEvent: () {
                              if (totTeam1 == totTeam2) {
                                Get.snackbar("", '',
                                    snackPosition: SnackPosition.TOP,
                                    titleText: Text(
                                      'La Partita non può finire in parità',
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
                                      "Prova a correggere il risultato",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1,
                                        fontSize: w > 605
                                            ? 20
                                            : widget.w > 380
                                                ? 15
                                                : 13,
                                      ),
                                    ),
                                    duration: const Duration(seconds: 4),
                                    backgroundColor:
                                        Colors.redAccent.withOpacity(0.6),
                                    colorText: Colors.black);
                              } else {
                                if (widget.appointment['playerCount2'] == 0) {
                                  Get.snackbar("", "",
                                      snackPosition: SnackPosition.TOP,
                                      titleText: Text(
                                        'Il Team 2 non può essere vuoto',
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
                                        "Prova ad aggiungiere almeno un giocatore",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          fontSize: w > 605
                                              ? 20
                                              : widget.w > 380
                                                  ? 15
                                                  : 13,
                                        ),
                                      ),
                                      duration: const Duration(seconds: 4),
                                      backgroundColor:
                                          Colors.redAccent.withOpacity(0.6),
                                      colorText: Colors.black);
                                } else {
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.topSlide,
                                          showCloseIcon: true,
                                          title: "$totTeam1 - $totTeam2",
                                          titleTextStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: w > 605
                                                  ? 45
                                                  : widget.w > 380
                                                      ? 30
                                                      : 25,
                                              fontWeight: FontWeight.w700),
                                          desc: "Vuoi inserire il risultato?",
                                          descTextStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: w > 605
                                                  ? 30
                                                  : widget.w > 380
                                                      ? 20
                                                      : 18,
                                              fontWeight: FontWeight.w700),
                                          btnOkOnPress: () async {
                                            String address = '';

                                            widget.appointment['crea_match']
                                                ? address =
                                                    'football/Crea_Match'
                                                : address = 'football';

                                            Navigator.of(context).push(
                                                HeroDialogRoute(
                                                    builder: (context) {
                                              return const LoadingScreen();
                                            }));

                                            sendGoalsToServer(
                                                uid,
                                                utente,
                                                widget.appointment['club'],
                                                widget.appointment['campo'],
                                                widget.appointment['day'],
                                                widget.appointment['time'],
                                                widget.appointment['month'],
                                                widget.appointment[
                                                    'playerCount1Tot'],
                                                widget.appointment[
                                                    'playerCount2Tot'],
                                                t1p1,
                                                t1p2,
                                                t1p3,
                                                t1p4,
                                                t1p5,
                                                t1p6,
                                                t1p7,
                                                t1p8,
                                                t1p9,
                                                t2p1,
                                                t2p2,
                                                t2p3,
                                                t2p4,
                                                t2p5,
                                                t2p6,
                                                t2p7,
                                                t2p8,
                                                t2p9,
                                                totTeam1,
                                                totTeam2,
                                                widget.appointment['dbURL'],
                                                address);
                                            Future.delayed(const Duration(
                                                milliseconds: 200));
                                            final snapshot =
                                                await FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL:
                                                            'https://sports-hub-2710-db-prenotazioni.europe-west1.firebasedatabase.app/')
                                                    .ref()
                                                    .child('Prenotazioni')
                                                    .child(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .child(address)
                                                    .child(widget
                                                        .appointment['dateURL'])
                                                    .get();
                                            if (snapshot.exists) {
                                              Map data = snapshot.value as Map;
                                              data['key'] = snapshot.key;
                                              //print(data[widget.appointment['dateURL']]);

                                              for (int a = 1; a <= 2; a++) {
                                                for (int i = 1;
                                                    i <=
                                                        (data['playerCount${a}Tot'] -
                                                            (2 - a));
                                                    i++) {
                                                  await userController.sendGameToFriend(
                                                      '${data['team${a}_P${(i + ((a * (3 - a))) - ((2 * a) - a))}']}',
                                                      utente,
                                                      a,
                                                      totTeam1,
                                                      totTeam2,
                                                      data[
                                                          't${a}p${(i + ((a * (3 - a))) - ((2 * a) - a))} goals'],
                                                      data['host'],
                                                      data['id'],
                                                      data['dateURL'],
                                                      1,
                                                      data['club'],
                                                      '${widget.appointment['day']}/${widget.appointment['meseN']}',
                                                      widget
                                                          .appointment['dbURL'],
                                                      widget.appointment[
                                                          'crea_match']);

                                                  if (data[
                                                          'team${a}_P${(i + ((a * (3 - a))) - ((2 * a) - a))}'] !=
                                                      'ospite') {
                                                    QuerySnapshot<
                                                            Map<String,
                                                                dynamic>> user =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('User')
                                                            .where('email',
                                                                isEqualTo: data[
                                                                    'team${a}_P${(i + ((a * (3 - a))) - ((2 * a) - a))}'])
                                                            .get();

                                                    final userMap = user.docs
                                                        .map((friends) =>
                                                            UserModel
                                                                .fromSnapshot(
                                                                    friends))
                                                        .first;

                                                    sendPushMessage(
                                                        userMap.token);
                                                  }
                                                }
                                              }
                                            } else {
                                              print('No data available.');
                                            }

                                            QuerySnapshot<Map<String, dynamic>>
                                                user = await FirebaseFirestore
                                                    .instance
                                                    .collection('User')
                                                    .where('email',
                                                        isEqualTo: utente)
                                                    .get();

                                            final userMap = user.docs
                                                .map((friends) =>
                                                    UserModel.fromSnapshot(
                                                        friends))
                                                .first;

                                            if (widget.appointment[
                                                    'crea_match'] ==
                                                true) {
                                              await FirebaseFirestore.instance
                                                  .collection("User")
                                                  .doc(utente)
                                                  .update({
                                                'prenotazioni':
                                                    userMap.prenotazioni - 1
                                              });
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection("User")
                                                  .doc(utente)
                                                  .update({
                                                'prenotazioniPremium': userMap
                                                        .prenotazioniPremium -
                                                    1
                                              });
                                            }

                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePage(
                                                              docIds: utente,
                                                              avviso: false,
                                                              sport: 'football',
                                                            )));
                                          },
                                          btnOkIcon: Icons.thumb_up,
                                          btnOkText: "CONFERMA",
                                          btnOkColor: kBackgroundColor2)
                                      .show();
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ])))),
      //SizedBox(height: widget.h*0.1)
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

void sendGoalsToServer(
    String id,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    int playerCount1,
    int playerCount2,
    int t1p1,
    int t1p2,
    int t1p3,
    int t1p4,
    int t1p5,
    int t1p6,
    int t1p7,
    int t1p8,
    int t1p9,
    int t2p1,
    int t2p2,
    int t2p3,
    int t2p4,
    int t2p5,
    int t2p6,
    int t2p7,
    int t2p8,
    int t2p9,
    int tot1,
    int tot2,
    String dbURL,
    String address) {
  for (int i = 0; i < playerCount1; i++) {
    FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: dbPrenotazioniURL)
        .ref()
        .child('Prenotazioni')
        .child(id)
        .child(address)
        .child('$month-$day-$time')
        .update({
      if (i == 0) 't1p${i + 1} goals': t1p1,
      if (i == 1) 't1p${i + 1} goals': t1p2,
      if (i == 2) 't1p${i + 1} goals': t1p3,
      if (i == 3) 't1p${i + 1} goals': t1p4,
      if (i == 4) 't1p${i + 1} goals': t1p5,
      if (i == 5) 't1p${i + 1} goals': t1p6,
      if (i == 6) 't1p${i + 1} goals': t1p7,
      if (i == 7) 't1p${i + 1} goals': t1p8,
      if (i == 8) 't1p${i + 1} goals': t1p9,
    });
  }

  for (int i = 0; i < playerCount2; i++) {
    FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: dbPrenotazioniURL)
        .ref()
        .child('Prenotazioni')
        .child(id)
        .child(address)
        .child('$month-$day-$time')
        .update({
      if (i == 0) 't2p${i + 1} goals': t2p1,
      if (i == 1) 't2p${i + 1} goals': t2p2,
      if (i == 2) 't2p${i + 1} goals': t2p3,
      if (i == 3) 't2p${i + 1} goals': t2p4,
      if (i == 4) 't2p${i + 1} goals': t2p5,
      if (i == 5) 't1p${i + 1} goals': t2p6,
      if (i == 6) 't1p${i + 1} goals': t2p7,
      if (i == 7) 't1p${i + 1} goals': t2p8,
      if (i == 8) 't1p${i + 1} goals': t2p9,
    });
  }

  FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child(address)
      .child('$month-$day-$time')
      .update({'totTeam1': tot1, 'totTeam2': tot2});

  FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child(address)
      .child('$month-$day-$time')
      .update({
    'caricato': true,
  });
}
