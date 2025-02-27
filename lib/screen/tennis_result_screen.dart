import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/models/tennis_game_model.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Results_Games/score_card.dart';
import 'package:sports_hub_ios/widgets/Results_Games/team_popup_card.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';

var set1Counter = 0;
var set2Counter = 0;
var set3Counter = 0;
var set1Counter2 = 0;
var set2Counter2 = 0;
var set3Counter2 = 0;

int counter1 = 0;

class TennisResultsScreen extends StatefulWidget {
  const TennisResultsScreen(
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
  State<TennisResultsScreen> createState() => _TennisResultsScreenState();
}

class _TennisResultsScreenState extends State<TennisResultsScreen> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  List allTeammate = [];
  final allTeam1 = <Map<String, dynamic>>[].obs;

  //AppointmentController appointmentController = Get.put(AppointmentController("${appointment['club']}-${appointment['month']}-${appointment['day']}-${appointment['campo']}-${appointment['time']}"));
  CollectionReference user = FirebaseFirestore.instance.collection('User');
  final String utente = FirebaseAuth.instance.currentUser!.email.toString();
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  UserController userController = Get.put(UserController());
  var set1Counter = 0;
  var set2Counter = 0;
  var set3Counter = 0;
  var set1Counter2 = 0;
  var set2Counter2 = 0;
  var set3Counter2 = 0;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 380));

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    List list1 = widget.list1;

    return Column(children: [
      SizedBox(height: widget.h * 0.01),
      Center(
          child: Container(
              height: h > 800
                  ? h * 0.8
                  : widget.h > 700
                      ? widget.h * 0.75
                      : widget.h * 0.75,
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
                      margin: EdgeInsets.symmetric(horizontal: widget.h * 0.02),
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
                            height: widget.h > 700
                                ? widget.h * 0.5
                                : widget.h * 0.46,
                            width: widget.w * 0.8,
                            color: kBackgroundColor2,
                            child: Row(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(left: widget.h * 0.01),
                                  child: Column(
                                    children: [
                                      TennisScoreCardP1(
                                        user: utente,
                                        team: 1,
                                      ),

                                      if (widget
                                              .appointment['playerCount1Tot'] >
                                          1)
                                        Container(
                                          height: widget.appointment[
                                                      'playerCount1Tot'] <
                                                  4
                                              ? widget.h *
                                                  0.1 *
                                                  (widget.appointment[
                                                          'playerCount1Tot'] -
                                                      1)
                                              : widget.h * 0.1 * 2.2,
                                          width: widget.w * 0.35,
                                          constraints: BoxConstraints(
                                              maxHeight: widget.h * 0.073 * 5),
                                          child: ListView.builder(
                                              itemCount: widget.appointment[
                                                      'playerCount1Tot'] -
                                                  1,
                                              itemBuilder: (
                                                BuildContext context,
                                                index,
                                              ) =>
                                                  TennisScoreCard1(
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
                                                    list1: list1,
                                                  )),
                                        ),

                                      SizedBox(height: widget.h * 0.012),

                                      //const ScoreCardP1(user: 'ospite', team: 1,),
                                      //SizedBox(height: h*0.02),
                                      SizedBox(
                                          height: widget.h > 700
                                              ? widget.h * 0.02
                                              : widget.h * 0.03,
                                          width: widget.w * 0.33,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (widget.appointment[
                                                      'playerCount1Tot'] <
                                                  2) {
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
                                                    sport: 'tennis',
                                                    list1: list1,
                                                  );
                                                }));
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
                                                                ? 12
                                                                : 8,
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
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: kPrimaryColor,
                                              ),
                                              child: Text(
                                                'Aggiungi giocatore  +',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    letterSpacing: 0.25,
                                                    fontSize: w > 605
                                                        ? 18
                                                        : widget.w > 380
                                                            ? 12
                                                            : 8,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )),
                                      SizedBox(
                                          height: widget.h > 700
                                              ? widget.h * 0.03
                                              : widget.h * 0.01),
                                      Container(
                                        //height: widget.h * 0.2,
                                        //width: widget.w*0.3,
                                        padding:
                                            EdgeInsets.all(widget.h * 0.012),
                                        decoration: const BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Column(
                                          children: [
                                            //SizedBox(height: widget.h*0.015),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (set1Counter != 0) {
                                                        set1Counter =
                                                            set1Counter - 1;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: widget.h * 0.05,
                                                    width: widget.w * 0.08,
                                                    padding: EdgeInsets.only(
                                                        top: widget.h * 0.01),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kBackgroundColor2,
                                                    ),
                                                    child: Text(
                                                      '-1',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w > 605
                                                            ? 18
                                                            : w > 380
                                                                ? 14
                                                                : 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: widget.h * 0.05,
                                                  width: widget.w * 0.08,
                                                  padding: EdgeInsets.only(
                                                      top: widget.h * 0.01),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.black)),
                                                  child: Text(
                                                    set1Counter.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: w > 605
                                                          ? 18
                                                          : w > 380
                                                              ? 14
                                                              : 10,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (set1Counter < 9) {
                                                        set1Counter =
                                                            set1Counter + 1;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: widget.h * 0.05,
                                                    width: widget.w * 0.08,
                                                    padding: EdgeInsets.only(
                                                        top: widget.h * 0.01),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kBackgroundColor2,
                                                    ),
                                                    child: Text(
                                                      '+1',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w > 605
                                                            ? 18
                                                            : w > 380
                                                                ? 14
                                                                : 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(
                                                height: widget.h > 700
                                                    ? widget.h * 0.01
                                                    : widget.h * 0.005),

                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (set2Counter != 0) {
                                                        set2Counter =
                                                            set2Counter - 1;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: widget.h * 0.05,
                                                    width: widget.w * 0.08,
                                                    padding: EdgeInsets.only(
                                                        top: widget.h * 0.01),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kBackgroundColor2,
                                                    ),
                                                    child: Text(
                                                      '-1',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w > 605
                                                            ? 18
                                                            : w > 380
                                                                ? 14
                                                                : 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: widget.h * 0.05,
                                                  width: widget.w * 0.08,
                                                  padding: EdgeInsets.only(
                                                      top: widget.h * 0.01),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.black)),
                                                  child: Text(
                                                    set2Counter.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: w > 605
                                                          ? 18
                                                          : w > 380
                                                              ? 14
                                                              : 10,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (set2Counter < 9) {
                                                        set2Counter =
                                                            set2Counter + 1;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: widget.h * 0.05,
                                                    width: widget.w * 0.08,
                                                    padding: EdgeInsets.only(
                                                        top: widget.h * 0.01),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kBackgroundColor2,
                                                    ),
                                                    child: Text(
                                                      '+1',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w > 605
                                                            ? 18
                                                            : w > 380
                                                                ? 14
                                                                : 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(
                                                height: widget.h > 700
                                                    ? widget.h * 0.01
                                                    : widget.h * 0.005),

                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (set3Counter != 0) {
                                                        set3Counter =
                                                            set3Counter - 1;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: widget.h * 0.05,
                                                    width: widget.w * 0.08,
                                                    padding: EdgeInsets.only(
                                                        top: widget.h * 0.01),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kBackgroundColor2,
                                                    ),
                                                    child: Text(
                                                      '-1',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w > 605
                                                            ? 18
                                                            : w > 380
                                                                ? 14
                                                                : 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  child: Container(
                                                    height: widget.h * 0.05,
                                                    width: widget.w * 0.08,
                                                    padding: EdgeInsets.only(
                                                        top: widget.h * 0.01),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.black)),
                                                    child: Text(
                                                      set3Counter.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: w > 605
                                                            ? 18
                                                            : w > 380
                                                                ? 14
                                                                : 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (set3Counter < 9) {
                                                        set3Counter =
                                                            set3Counter + 1;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: widget.h * 0.05,
                                                    width: widget.w * 0.08,
                                                    padding: EdgeInsets.only(
                                                        top: widget.h * 0.01),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: kBackgroundColor2,
                                                    ),
                                                    child: Text(
                                                      '+1',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w > 605
                                                            ? 18
                                                            : w > 380
                                                                ? 14
                                                                : 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  //child: Team1(),
                                ),
                                SizedBox(width: widget.w * 0.03),
                                Container(
                                  //alignment: Alignment.topCenter,
                                  //margin: EdgeInsets.only(bottom: h*0.15),
                                  height: widget.h * 0.6,
                                  width: 1,
                                  color: Colors.white,
                                ),
                                if (list1.isEmpty)
                                  SizedBox(width: widget.w * 0.025),
                                SizedBox(width: widget.w * 0.01),
                                Column(
                                  children: [
                                    if (widget.appointment['playerCount2Tot'] !=
                                        0)
                                      Container(
                                        height: widget.h *
                                            0.1 *
                                            (widget.appointment[
                                                'playerCount2Tot']),
                                        width: widget.w * 0.35,
                                        constraints: BoxConstraints(
                                            maxHeight: widget.h * 0.0775 * 6),
                                        child: ListView.builder(
                                            itemCount: widget
                                                .appointment['playerCount2Tot'],
                                            itemBuilder: (
                                              BuildContext context,
                                              index,
                                            ) =>
                                                Column(
                                                  children: [
                                                    TennisScoreCard2(
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

                                    //const ScoreCardP1(user: 'ospite', team: 2,),

                                    SizedBox(
                                        height: widget.h > 700
                                            ? widget.h * 0.02
                                            : widget.h * 0.03,
                                        width: widget.w * 0.33,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (widget.appointment[
                                                    'playerCount2Tot'] <
                                                2) {
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
                                                  sport: 'tennis',
                                                  list1: list1,
                                                );
                                              }));
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
                                                      fontSize: w < 380
                                                          ? 13
                                                          : w > 605
                                                              ? 18
                                                              : 15,
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
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: kPrimaryColor,
                                            ),
                                            child: Text(
                                              'Aggiungi giocatore  +',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  letterSpacing: 0.25,
                                                  fontSize: w > 605
                                                      ? 18
                                                      : w > 380
                                                          ? 12
                                                          : 8,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )),

                                    SizedBox(
                                        height: widget.h > 700
                                            ? widget.h * 0.03
                                            : widget.h * 0.01),
                                    Container(
                                      //height: widget.h * 0.2,
                                      //width: widget.w*0.3,
                                      padding: EdgeInsets.all(widget.h * 0.012),
                                      decoration: const BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Column(
                                        children: [
                                          //SizedBox(height: widget.h*0.015),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (set1Counter2 != 0) {
                                                      set1Counter2 =
                                                          set1Counter2 - 1;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: widget.h * 0.05,
                                                  width: widget.w * 0.08,
                                                  padding: EdgeInsets.only(
                                                      top: widget.h * 0.01),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: kBackgroundColor2,
                                                  ),
                                                  child: Text(
                                                    '-1',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: w > 605
                                                          ? 18
                                                          : w > 380
                                                              ? 14
                                                              : 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: widget.h * 0.05,
                                                width: widget.w * 0.08,
                                                padding: EdgeInsets.only(
                                                    top: widget.h * 0.01),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black)),
                                                child: Text(
                                                  set1Counter2.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: w > 605
                                                        ? 18
                                                        : w > 380
                                                            ? 14
                                                            : 10,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (set1Counter2 < 9) {
                                                      set1Counter2 =
                                                          set1Counter2 + 1;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: widget.h * 0.05,
                                                  width: widget.w * 0.08,
                                                  padding: EdgeInsets.only(
                                                      top: widget.h * 0.01),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: kBackgroundColor2,
                                                  ),
                                                  child: Text(
                                                    '+1',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: w > 605
                                                          ? 18
                                                          : w > 380
                                                              ? 14
                                                              : 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                              height: widget.h > 700
                                                  ? widget.h * 0.01
                                                  : widget.h * 0.005),

                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (set2Counter2 != 0) {
                                                      set2Counter2 =
                                                          set2Counter2 - 1;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: widget.h * 0.05,
                                                  width: widget.w * 0.08,
                                                  padding: EdgeInsets.only(
                                                      top: widget.h * 0.01),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: kBackgroundColor2,
                                                  ),
                                                  child: Text(
                                                    '-1',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: w > 605
                                                          ? 18
                                                          : w > 380
                                                              ? 14
                                                              : 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: widget.h * 0.05,
                                                width: widget.w * 0.08,
                                                padding: EdgeInsets.only(
                                                    top: widget.h * 0.01),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black)),
                                                child: Text(
                                                  set2Counter2.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: w > 605
                                                        ? 18
                                                        : w > 380
                                                            ? 14
                                                            : 10,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (set2Counter2 < 9) {
                                                      set2Counter2 =
                                                          set2Counter2 + 1;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: widget.h * 0.05,
                                                  width: widget.w * 0.08,
                                                  padding: EdgeInsets.only(
                                                      top: widget.h * 0.01),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: kBackgroundColor2,
                                                  ),
                                                  child: Text(
                                                    '+1',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: w > 605
                                                          ? 18
                                                          : w > 380
                                                              ? 14
                                                              : 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                              height: widget.h > 700
                                                  ? widget.h * 0.01
                                                  : widget.h * 0.005),

                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (set3Counter2 != 0) {
                                                      set3Counter2 =
                                                          set3Counter2 - 1;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: widget.h * 0.05,
                                                  width: widget.w * 0.08,
                                                  padding: EdgeInsets.only(
                                                      top: widget.h * 0.01),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: kBackgroundColor2,
                                                  ),
                                                  child: Text(
                                                    '-1',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: w > 605
                                                          ? 18
                                                          : w > 380
                                                              ? 14
                                                              : 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: widget.h * 0.05,
                                                width: widget.w * 0.08,
                                                padding: EdgeInsets.only(
                                                    top: widget.h * 0.01),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black)),
                                                child: Text(
                                                  set3Counter2.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: w > 605
                                                        ? 18
                                                        : w > 380
                                                            ? 14
                                                            : 10,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (set3Counter2 < 9) {
                                                      set3Counter2 =
                                                          set3Counter2 + 1;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: widget.h * 0.05,
                                                  width: widget.w * 0.08,
                                                  padding: EdgeInsets.only(
                                                      top: widget.h * 0.01),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: kBackgroundColor2,
                                                  ),
                                                  child: Text(
                                                    '+1',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: w > 605
                                                          ? 18
                                                          : w > 380
                                                              ? 14
                                                              : 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: widget.h > 700
                                  ? widget.h * 0.02
                                  : widget.h * 0.01),
                          //Center(
                          // child: Column(
                          //   children: [
                          //     Text('FINALE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                          //     Text('$totTeam1 - $totTeam2', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
                          //   ],
                          // ),
                          //),
                          FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(FirebaseAuth.instance.currentUser!.email
                                      .toString())
                                  .get(),
                              builder: (((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> utenteDB = snapshot.data!
                                      .data() as Map<String, dynamic>;

                                  return AnimatedButton(
                                    isFixedHeight: false,
                                    height: widget.h * 0.05,
                                    width: widget.w * 0.4,
                                    text: "CONFERMA",
                                    buttonTextStyle: TextStyle(
                                        letterSpacing: 0.5,
                                        color: Colors.black,
                                        fontSize: w > 605 ? 22 : 16,
                                        fontWeight: FontWeight.bold),
                                    color: kPrimaryColor,
                                    pressEvent: () {
                                      if (set1Counter == set1Counter2 ||
                                          set2Counter == set2Counter2 ||
                                          set3Counter == set3Counter2) {
                                        Get.snackbar("", '',
                                            snackPosition: SnackPosition.TOP,
                                            titleText: Text(
                                              'Un Set non può finire in parità',
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
                                                fontSize: w < 380
                                                    ? 13
                                                    : w > 605
                                                        ? 18
                                                        : 15,
                                              ),
                                            ),
                                            duration:
                                                const Duration(seconds: 4),
                                            backgroundColor: Colors.redAccent
                                                .withOpacity(0.6),
                                            colorText: Colors.black);
                                      } else {
                                        if (widget
                                                .appointment['playerCount2'] ==
                                            0) {
                                          Get.snackbar('', "",
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
                                                  fontSize: w < 380
                                                      ? 13
                                                      : w > 605
                                                          ? 18
                                                          : 15,
                                                ),
                                              ),
                                              duration:
                                                  const Duration(seconds: 4),
                                              backgroundColor: Colors.redAccent
                                                  .withOpacity(0.6),
                                              colorText: Colors.black);
                                        } else {
                                          AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.success,
                                                  animType: AnimType.topSlide,
                                                  showCloseIcon: true,
                                                  title:
                                                      "$set1Counter-$set2Counter-$set3Counter\n$set1Counter2-$set2Counter2-$set3Counter2",
                                                  titleTextStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: w > 605
                                                          ? 45
                                                          : widget.w > 380
                                                              ? 30
                                                              : 25,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  desc:
                                                      "Vuoi inserire il risultato?",
                                                  descTextStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: w > 605
                                                          ? 30
                                                          : widget.w > 380
                                                              ? 20
                                                              : 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  btnOkOnPress: () async {
                                                    Navigator.of(context).push(
                                                        HeroDialogRoute(
                                                            builder: (context) {
                                                      return const LoadingScreen();
                                                    }));

                                                    sendSetsToServer(
                                                        uid,
                                                        widget.appointment[
                                                            'month'],
                                                        widget
                                                            .appointment['day'],
                                                        widget.appointment[
                                                            'time'],
                                                        widget.appointment[
                                                            'playerCount1'],
                                                        widget.appointment[
                                                            'playerCount2'],
                                                        set1Counter,
                                                        set2Counter,
                                                        set3Counter,
                                                        set1Counter2,
                                                        set2Counter2,
                                                        set3Counter2,
                                                        widget.appointment[
                                                            'club'],
                                                        widget.appointment[
                                                            'dbURL']);

                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 200));
                                                    final snapshot =
                                                        await FirebaseDatabase
                                                                .instanceFor(
                                                                    app: Firebase
                                                                        .app(),
                                                                    databaseURL:
                                                                        dbPrenotazioniURL)
                                                            .ref()
                                                            .child(
                                                                'Prenotazioni/$uid/tennis/${widget.appointment['dateURL']}')
                                                            .get();
                                                    if (snapshot.exists) {
                                                      Map data =
                                                          snapshot.value as Map;
                                                      data['key'] =
                                                          snapshot.key;
                                                      //print(data);

                                                      for (int a = 1;
                                                          a <= 2;
                                                          a++) {
                                                        for (int i = 1;
                                                            i <=
                                                                (data['playerCount$a'] -
                                                                    (2 - a));
                                                            i++) {
                                                          sendSetsToFriend(
                                                              '${data['team${a}_P${(i + ((a * (3 - a))) - ((2 * a) - a))}']}',
                                                              data['dateURL'],
                                                              utente,
                                                              a,
                                                              data['host'],
                                                              data['id'],
                                                              1,
                                                              data['club'],
                                                              '${widget.appointment['day']}/${widget.appointment['meseN']}',
                                                              set1Counter,
                                                              set2Counter,
                                                              set3Counter,
                                                              set1Counter2,
                                                              set2Counter2,
                                                              set3Counter2,
                                                              'tennis');
                                                        }
                                                      }
                                                    } else {
                                                      print(
                                                          'No data available.');
                                                    }

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("User")
                                                        .doc(email)
                                                        .update({
                                                      'prenotazioni': utenteDB[
                                                              'prenotazioni'] -
                                                          1
                                                    });

                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProfilePage(
                                                                          docIds:
                                                                              utente,
                                                                          avviso:
                                                                              false,
                                                                          sport:
                                                                              'football',
                                                                        )));
                                                  },
                                                  btnOkIcon: Icons.thumb_up,
                                                  btnOkText: "CONFERMA",
                                                  btnOkColor: kBackgroundColor2)
                                              .show();
                                        }
                                      }
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              })))
                        ],
                      ),
                    ),
                  ])))),
      //SizedBox(height: widget.h*0.1)
    ]);
  }
}

void sendSetsToServer(
    String id,
    String month,
    String day,
    String time,
    int playerCount1,
    int playerCount2,
    // ignore: non_constant_identifier_names
    int S1T1,
    int S2T1,
    int S3T1,
    int S1T2,
    int S2T2,
    int S3T2,
    String club,
    String dbURL) {
  FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child('tennis')
      .child('$month-$day-$time')
      .update({
    'set1Team1': S1T1,
    'set2Team1': S2T1,
    'set3Team1': S3T1,
    'set1Team2': S1T2,
    'set2Team2': S2T2,
    'set3Team2': S3T2,
  });

  FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child('tennis')
      .child('$month-$day-$time')
      .update({
    'caricato': true,
  });
}

Future<void> sendSetsToFriend(
    String userFriend,
    String date,
    String host,
    int team,
    String hostUsername,
    String userId,
    int permissions,
    String club,
    String giorno,
    int S1T1,
    int S2T1,
    int S3T1,
    int S1T2,
    int S2T2,
    int S3T2,
    String sport) async {
  int c1 = 0;
  int c2 = 0;
  String finale = '';
  int set = 0;
  if (S1T1 < S1T2) {
    c2++;
  } else {
    c1++;
  }
  if (S2T1 < S2T2) {
    c2++;
  } else {
    c1++;
  }
  if (S3T1 < S3T2) {
    c2++;
  } else {
    c1++;
  }
  if (c1 < c2) {
    if (team == 1) {
      finale = 'SCONFITTA';
      set = c1;
    } else if (team == 2) {
      finale = 'VITTORIA';
      set = c2;
    }
  }
  if (c1 > c2) {
    if (team == 2) {
      finale = 'SCONFITTA';
      set = c2;
    } else if (team == 1) {
      finale = 'VITTORIA';
      set = c1;
    }
  }

  TennisGameModel game = TennisGameModel(
      host: host,
      team: team,
      S1T1: S1T1,
      S2T1: S2T1,
      S3T1: S3T1,
      S1T2: S1T2,
      S2T2: S2T2,
      S3T2: S3T2,
      risultato: finale,
      hostUsername: hostUsername,
      userId: userId,
      date: date,
      permissions: permissions,
      club: club,
      giorno: giorno,
      set: set,
      sport: sport);
  //FriendModel user = FriendModel(username: username, id: id, email: email, phoneNo: phoneNo, password: password, profile_pic: profile_pic, cover_pic: cover_pic, isEmailVerified: isEmailVerified, isRequested: isRequested)
  await FirebaseFirestore.instance
      .collection("User")
      .doc(userFriend)
      .collection('Tennis Games')
      .doc(date)
      .set(game.toJson());
}
