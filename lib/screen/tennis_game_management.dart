// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/games_controller.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Requesting_widget/tennis_games_widget.dart';
import 'package:sports_hub_ios/widgets/appointment_card.dart';

class TennisManagementScreen extends StatefulWidget {
  const TennisManagementScreen(
      {super.key, required this.profile, required this.gameController});

  final String profile;
  final GameController gameController;

  @override
  State<TennisManagementScreen> createState() =>
      _TennisManagementScreenScreenState();
}

class _TennisManagementScreenScreenState extends State<TennisManagementScreen> {
  GameController gameController = Get.put(GameController());

  String email = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    //  setState(() {
    //    list1.clear();
    //  });

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      //buildGameManagement(h, w),
      Column(
        children: [
          SizedBox(height: h * 0.02),
          FutureBuilder(
              future: gameController.getAllTennisGames(),
              builder: (context, snapshot) {
                return gameController.allTennisGames.isEmpty
                    ? Container(
                        width: w * 0.9,
                        height: (h) * 0.10,
                        decoration: const BoxDecoration(
                          color: kBackgroundColor2,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(children: [
                          SizedBox(height: h * 0.02),
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
                          Container(),
                        ]),
                      )
                    : Container(
                        width: w * 0.9,
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
                          FutureBuilder(
                              future: FirebaseDatabase.instanceFor(
                                      app: Firebase.app(),
                                      databaseURL: dbPrenotazioniURL)
                                  .ref()
                                  .child('Prenotazioni')
                                  .child(gameController
                                      .allTennisGames.first.userId)
                                  .child('tennis')
                                  .child(
                                      gameController.allTennisGames.first.date)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  Map appointment = snapshot.data!.value as Map;

                                  //print(appointment);

                                  return TennisGamesWidget(
                                    appointment: appointment,
                                    gameController: gameController,
                                  );
                                } else {
                                  return Container();
                                }
                              })
                        ]));

                //FriendsRequest(users: userController),
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
                                : w > 380
                                    ? 30
                                    : 22,
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
                                .child('tennis'),
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
                                  sport: 'tennis');
                            }))
                  ]))
        ],
      )
    ]));
  }
}
