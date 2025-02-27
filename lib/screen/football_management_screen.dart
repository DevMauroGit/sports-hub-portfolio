// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/games_controller.dart';
import 'package:sports_hub_ios/controllers/profile_controller.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Requesting_widget/games_widget.dart';
import 'package:sports_hub_ios/widgets/appointment_card.dart';
import 'package:sports_hub_ios/widgets/appointment_create_card.dart';

class FootballManagementScreen extends StatefulWidget {
  const FootballManagementScreen(
      {super.key, required this.profile, required this.gameController});

  final String profile;
  final GameController gameController;

  @override
  State<FootballManagementScreen> createState() =>
      _FootballManagementScreenScreenState();
}

class _FootballManagementScreenScreenState
    extends State<FootballManagementScreen> {
  final controller = Get.put(ProfileController());
  GameController gameController = Get.put(GameController());

  Query dbRef = FirebaseDatabase.instance
      .ref()
      .child('Prenotazioni')
      .child(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child('Prenotazioni')
      .child(FirebaseAuth.instance.currentUser!.uid);
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    //   setState(() {
    //     list1.clear();
    //   });

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Column(
        children: [
          SizedBox(height: h * 0.02),
          FutureBuilder(
              future: gameController.getAllGames(),
              builder: (context, snapshot) {
                return gameController.allGames.isEmpty
                    ? Container(
                        width: w * 0.9,
                        height: (h) * 0.10,
                        decoration: const BoxDecoration(
                          color: kBackgroundColor2,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(children: [
                          SizedBox(height: h * 0.02),
                          GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Richieste in sospeso',
                                  style: TextStyle(
                                      fontSize: w > 605
                                          ? 25
                                          : w > 385
                                              ? 16
                                              : 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                //Icon(Icons.arrow_drop_down_outlined, color: Colors.white,) ,
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          Container(),
                        ]),
                      )
                    : Container(
                        width: w > 380 ? w * 0.9 : w * 0.95,
                        //height: gameController.allGames.isEmpty
                        //  ? (h) * 0.10
                        //: (h) * 0.120 * (1 + 1),
                        padding: EdgeInsets.symmetric(vertical: h * 0.02),
                        decoration: const BoxDecoration(
                          color: kBackgroundColor2,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(children: [
                          Text(
                            'Richieste in sospeso',
                            style: TextStyle(
                                fontSize: w > 605
                                    ? 25
                                    : w > 380
                                        ? 16
                                        : 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          SizedBox(height: h * 0.01),
                          gameController.allGames.isEmpty
                              ? Container()
                              : FutureBuilder(
                                  future: FirebaseDatabase.instanceFor(
                                          app: Firebase.app(),
                                          databaseURL: dbPrenotazioniURL)
                                      .ref()
                                      .child('Prenotazioni')
                                      .child(
                                          gameController.allGames.first.userId)
                                      .child('football')
                                      .child(gameController.allGames.first.date)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map appointment =
                                          snapshot.data!.value as Map;

                                      return GamesWidget(
                                        appointment: appointment,
                                        gameController: gameController,
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })
                        ]));
              }),
          Container(
              padding: const EdgeInsets.only(left: 10, right: 20, top: 10),
              margin: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Le tue partite",
                        style: TextStyle(
                            fontSize: w > 605
                                ? 45
                                : w > 385
                                    ? 30
                                    : 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                        height: h * 0.6,
                        child: FirebaseAnimatedList(
                            query: FirebaseDatabase.instanceFor(
                                    app: Firebase.app(),
                                    databaseURL: dbPrenotazioniURL)
                                .ref()
                                .child('Prenotazioni')
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .child('football'),
                            itemBuilder: (BuildContext context,
                                DataSnapshot snapshot,
                                Animation<double> animation,
                                int index) {
                              Map appointment = snapshot.value as Map;
                              appointment['key'] = snapshot.key;

                              return AppointmentCard(
                                  appointment: appointment,
                                  h: h,
                                  w: w,
                                  context: context,
                                  profile: widget.profile,
                                  sport: 'football');
                            }))
                  ]))
        ],
      )
    ]));
  }
}

class FootballCreateManagementScreen extends StatefulWidget {
  const FootballCreateManagementScreen(
      {super.key, required this.profile, required this.gameController});

  final String profile;
  final GameController gameController;

  @override
  State<FootballCreateManagementScreen> createState() =>
      _FootballCreateManagementScreenScreenState();
}

class _FootballCreateManagementScreenScreenState
    extends State<FootballCreateManagementScreen> {
  final controller = Get.put(ProfileController());
  GameController gameController = Get.put(GameController());

  Query dbRef = FirebaseDatabase.instance
      .ref()
      .child('Prenotazioni')
      .child(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child('Prenotazioni')
      .child(FirebaseAuth.instance.currentUser!.uid);
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    //   setState(() {
    //     list1.clear();
    //   });

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Column(
        children: [
          SizedBox(height: h * 0.02),
          FutureBuilder(
              future: gameController.getAllCreateGames(),
              builder: (context, snapshot) {
                return gameController.allGames.isEmpty
                    ? Container(
                        width: w * 0.9,
                        height: (h) * 0.10,
                        decoration: const BoxDecoration(
                          color: kBackgroundColor2,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(children: [
                          SizedBox(height: h * 0.02),
                          GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Richieste in sospeso',
                                  style: TextStyle(
                                      fontSize: w > 605
                                          ? 25
                                          : w > 385
                                              ? 16
                                              : 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                //Icon(Icons.arrow_drop_down_outlined, color: Colors.white,) ,
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          Container(),
                        ]),
                      )
                    : Container(
                        width: w > 380 ? w * 0.9 : w * 0.95,
                        //height: gameController.allGames.isEmpty
                        //  ? (h) * 0.10
                        //: (h) * 0.120 * (1 + 1),
                        padding: EdgeInsets.symmetric(vertical: h * 0.02),
                        decoration: const BoxDecoration(
                          color: kBackgroundColor2,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(children: [
                          Text(
                            'Richieste in sospeso',
                            style: TextStyle(
                                fontSize: w > 605
                                    ? 25
                                    : w > 385
                                        ? 16
                                        : 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          SizedBox(height: h * 0.01),
                          gameController.allGames.isEmpty
                              ? Container()
                              : FutureBuilder(
                                  future: FirebaseDatabase.instanceFor(
                                          app: Firebase.app(),
                                          databaseURL: dbPrenotazioniURL)
                                      .ref()
                                      .child('Prenotazioni')
                                      .child(
                                          gameController.allGames.first.userId)
                                      .child('football')
                                      .child('Crea_Match')
                                      .child(gameController.allGames.first.date)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map appointment =
                                          snapshot.data!.value as Map;

                                      return GamesCreateWidget(
                                        appointment: appointment,
                                        gameController: gameController,
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })
                        ]));
              }),
          Container(
              padding: const EdgeInsets.only(left: 10, right: 20, top: 10),
              margin: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Le tue partite create",
                        style: TextStyle(
                            fontSize: w > 605
                                ? 45
                                : w > 385
                                    ? 30
                                    : 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                        height: h * 0.6,
                        child: FirebaseAnimatedList(
                            query: FirebaseDatabase.instanceFor(
                                    app: Firebase.app(),
                                    databaseURL: dbPrenotazioniURL)
                                .ref()
                                .child('Prenotazioni')
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .child('football')
                                .child('Crea_Match'),
                            itemBuilder: (BuildContext context,
                                DataSnapshot snapshot,
                                Animation<double> animation,
                                int index) {
                              Map appointment = snapshot.value as Map;
                              appointment['key'] = snapshot.key;

                              return AppointmentCreateCard(
                                  appointment: appointment,
                                  h: h,
                                  w: w,
                                  context: context,
                                  profile: widget.profile,
                                  sport: 'football');
                            }))
                  ]))
        ],
      )
    ]));
  }
}
