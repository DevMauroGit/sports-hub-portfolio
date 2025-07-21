import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/models/game_model.dart';
import 'package:sports_hub_ios/models/tennis_game_model.dart';
import 'package:sports_hub_ios/models/user_model.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';

class GameCard extends StatefulWidget {
  const GameCard({
    super.key,
    required this.game,
    required this.appointment,
  });

  final Map appointment;
  final GameModel game;

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    String email = FirebaseAuth.instance.currentUser!.email.toString();

    final userController = Get.put(UserController());

    String address = '';

    widget.appointment['sport'] == 'football'
        ? widget.appointment['crea_match']
            ? address = 'football/Crea_Match'
            : address = 'football'
        : address = 'tennis';

    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: h * 0.015),
      margin: EdgeInsets.symmetric(
          horizontal: w > 385 ? kDefaultPadding : kDefaultPadding / 2),
      decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: kBackgroundColor2,
                ),
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    Text(
                      widget.game.giorno,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 15
                                  : 12,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: h * 0.018),
                    Text(
                      widget.game.club,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 15
                                  : widget.game.club.length > 11
                                      ? 10
                                      : 11,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(width: w * 0.01),
              Container(
                color: kBackgroundColor2,
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    Text(
                      '${widget.game.totTeam1}  -  ${widget.game.totTeam2}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 35
                              : w > 385
                                  ? 20
                                  : 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: h * 0.01),
                    Text(
                      widget.game.risultato,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 13
                                  : 10),
                    ),
                  ],
                ),
              ),
              SizedBox(width: w * 0.01),
              Container(
                decoration: const BoxDecoration(
                  color: kBackgroundColor2,
                ),
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    Text(
                      'Goal: ${widget.game.goal}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 14
                                  : 10,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: h * 0.018),
                    Text(
                      'host: ${widget.game.hostUsername}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 14
                                  : widget.game.hostUsername.length > 7
                                      ? 9
                                      : 10,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: h * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedButton(
                isFixedHeight: false,
                height: h > 700 ? h * 0.035 : h * 0.04,
                width: w > 385 ? w * 0.3 : w * 0.35,
                text: "CONFERMA",
                buttonTextStyle: TextStyle(
                    letterSpacing: 0.5,
                    color: Colors.black,
                    fontSize: w > 605 ? 20 : 16,
                    fontWeight: FontWeight.bold),
                color: Colors.green,
                pressEvent: () {
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title:
                              "${widget.game.totTeam1} - ${widget.game.totTeam2}\n goal: ${widget.game.goal}",
                          titleTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: w > 605
                                  ? 40
                                  : w > 385
                                      ? 30
                                      : 25,
                              fontWeight: FontWeight.w700),
                          desc: "Vuoi confermare il risultato?",
                          descTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: w > 605
                                  ? 30
                                  : w > 385
                                      ? 20
                                      : 18,
                              fontWeight: FontWeight.w700),
                          btnOkOnPress: () async {

                            Navigator.of(context)
                                .push(HeroDialogRoute(builder: (context) {
                              return const LoadingScreen();
                            }));

                            if (widget.appointment['permissions'] + 1 ==
                                widget.appointment['playerCount1'] +
                                    widget.appointment['playerCount2']) {
                              for (int a = 1; a <= 2; a++) {
                                int c = 0;
                                if (widget.appointment['totTeam1'] >
                                    widget.appointment['totTeam2']) {
                                  if (a == 1) {
                                    c = 1;
                                  }
                                }
                                if (widget.appointment['totTeam2'] >
                                    widget.appointment['totTeam1']) {
                                  if (a == 2) {
                                    c = 1;
                                  }
                                }
                                for (int i = 1;
                                    i <= widget.appointment['playerCount$a'];
                                    i++) {

                                  QuerySnapshot<
                                      Map<String,
                                          dynamic>> data = await FirebaseFirestore
                                      .instance
                                      .collection('User')
                                      .where('email',
                                          isEqualTo: widget
                                              .appointment['team${a}_P$i'])
                                      .get();
                                  final profile = data.docs
                                      .map((user) =>
                                          UserModel.fromSnapshot(user))
                                      .single;

                                  await FirebaseFirestore.instance
                                      .collection('User')
                                      .doc(profile.email)
                                      .set({
                                    "id": profile.id,
                                    "username": profile.username,
                                    "email": profile.email,
                                    "phoneNumber": profile.phoneNumber,
                                    "city": profile.city,
                                    "password": profile.password,
                                    "profile_pic": profile.profile_pic,
                                    "cover_pic": profile.cover_pic,
                                    "isEmailVerified": profile.isEmailVerified,
                                    'games': profile.games + 1,
                                    'goals': profile.goals +
                                        widget.appointment['t${a}p$i goals'],
                                    'win': profile.win + c,
                                    'games_tennis': profile.games_tennis,
                                    'set_vinti': profile.set_vinti,
                                    'win_tennis': profile.win_tennis,
                                    'prenotazioni': profile.prenotazioni,
                                    'token': profile.token
                                  });

                                  await FirebaseFirestore.instance
                                      .collection('User')
                                      .doc(profile.email)
                                      .collection('last games')
                                      .doc(
                                          '${widget.game.date}-${widget.game.club})')
                                      .set({
                                    'date': widget.game.date,
                                    'club': widget.game.club,
                                    'goals':
                                        widget.appointment['t${a}p$i goals'],
                                    'result': widget.game.risultato,
                                  });
                                }
                              }
                            } else {
                            }

                            sendGamePermission(
                                widget.game.host,
                                email,
                                widget.appointment['permissions'] + 1,
                                widget.game.userId,
                                widget.game.date,
                                'football',
                                widget.appointment['crea_match']);

                            userController.allGames.clear();

                            await FirebaseFirestore.instance
                                .collection('User')
                                .doc(email)
                                .collection('Games')
                                .doc(widget.game.date)
                                .delete();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          docIds: email,
                                          avviso: true,
                                          sport: 'football',
                                        )));
                          },
                          btnOkIcon: Icons.thumb_up,
                          btnOkText: "CONFERMA",
                          btnOkColor: kBackgroundColor2)
                      .show();
                },
              ),
              SizedBox(width: w * 0.04),
              AnimatedButton(
                isFixedHeight: false,
                height: h > 700 ? h * 0.035 : h * 0.04,
                width: w > 385 ? w * 0.3 : w * 0.35,
                text: "SEGNALA",
                buttonTextStyle: TextStyle(
                    letterSpacing: 0.5,
                    color: Colors.black,
                    fontSize: w > 605 ? 20 : 16,
                    fontWeight: FontWeight.bold),
                color: Colors.red,
                pressEvent: () {
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title:
                              "Se non hai preso parte a questa partita manda una segnalazione",
                          titleTextStyle: TextStyle(
                            fontSize: w > 605
                                ? 25
                                : w > 385
                                    ? 18
                                    : 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          desc: "Vuoi Segnalare?",
                          descTextStyle: TextStyle(
                            fontSize: w > 605
                                ? 30
                                : w > 385
                                    ? 20
                                    : 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          btnOkOnPress: () async {
                            Navigator.of(context)
                                .push(HeroDialogRoute(builder: (context) {
                              return const LoadingScreen();
                            }));

                            await FirebaseFirestore.instance
                                .collection('User')
                                .doc(email)
                                .collection('Games')
                                .doc(widget.game.date)
                                .delete();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          docIds: email,
                                          avviso: false,
                                          sport: 'football',
                                        )));
                          },
                          btnOkIcon: Icons.thumb_up,
                          btnOkText: "CONFERMA",
                          btnOkColor: kBackgroundColor2)
                      .show();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> sendGamePermission(String userFriend, String host, int counter,
      String id, String date, String sport, bool crea_match) async {
    String address = '';
    crea_match ? address = '$sport/Crea_Match' : address = sport;

    await FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: dbPrenotazioniURL)
        .ref()
        .child('Prenotazioni')
        .child(id)
        .child(address)
        .child(date)
        .update({'permissions': counter});
  }

  Future<void> loadGoalsToPlayers(
    Map appointment,
  ) async {
    for (int a = 1; a <= 2; a++) {
      int c = 0;
      if (appointment['totTeam1'] > appointment['totTeam2']) {
        if (a == 1) {
          c = 1;
        }
      }
      if (appointment['totTeam2'] > appointment['totTeam1']) {
        if (a == 2) {
          c = 1;
        }
      }
      for (int i = 1; 1 < appointment['playerCount$a']; i++) {
        Map utente = {};
        FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('User')
                .doc(appointment['team${a}_$i'])
                .get(),
            builder: (((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> profile =
                    snapshot.data!.data() as Map<String, dynamic>;

                setState(() {
                  utente = profile;
                });

                return Container();
              }
              return Container();
            })));
        await FirebaseFirestore.instance
            .collection('User')
            .doc(appointment['team${a}_$i'])
            .set({
          'games': utente['games'] + 1,
          'goals': utente['goals'] + appointment['t${a}p$i goals'],
          'win': utente['win'] + c,
        });
      }
    }
  }
}

class TennisGameCard extends StatefulWidget {
  const TennisGameCard({
    super.key,
    required this.game,
    required this.appointment,
  });

  final Map appointment;
  final TennisGameModel game;

  @override
  State<TennisGameCard> createState() => _TennisGameCardState();
}

class _TennisGameCardState extends State<TennisGameCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    String email = FirebaseAuth.instance.currentUser!.email.toString();

    final userController = Get.put(UserController());

    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: h * 0.015),
      margin: EdgeInsets.symmetric(
          horizontal: w > 385 ? kDefaultPadding : kDefaultPadding / 2),
      decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: kBackgroundColor2,
                ),
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.01),
                    Text(
                      widget.game.giorno,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 15
                                  : 11,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: h * 0.018),
                    Text(
                      widget.game.club,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 15
                                  : widget.game.club.length > 11
                                      ? 10
                                      : 11,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(width: w * 0.03),
              Container(
                color: kBackgroundColor2,
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    Text(
                      '${widget.game.S1T1}-${widget.game.S2T1}-${widget.game.S3T1}\n${widget.game.S1T2}-${widget.game.S2T2}-${widget.game.S3T2}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 30
                              : w > 385
                                  ? 18
                                  : 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: h * 0.01),
                    Text(
                      widget.game.risultato,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 13
                                  : 10),
                    ),
                  ],
                ),
              ),
              SizedBox(width: w * 0.03),
              Container(
                decoration: const BoxDecoration(
                  color: kBackgroundColor2,
                ),
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    Text(
                      'Set Vinti:\n${widget.game.set}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 15
                                  : 10,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: h * 0.002),
                    Text(
                      'host:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 15
                                  : 10,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      widget.game.hostUsername,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w > 605
                              ? 25
                              : w > 385
                                  ? 15
                                  : widget.game.hostUsername.length > 7
                                      ? 10
                                      : 11,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: h * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedButton(
                isFixedHeight: false,
                height: h > 700 ? h * 0.035 : h * 0.04,
                width: w > 385 ? w * 0.3 : w * 0.35,
                text: "CONFERMA",
                buttonTextStyle: TextStyle(
                    letterSpacing: 0.5,
                    color: Colors.black,
                    fontSize: w > 605 ? 20 : 16,
                    fontWeight: FontWeight.bold),
                color: Colors.green,
                pressEvent: () {
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title:
                              "${widget.game.S1T1}-${widget.game.S2T1}-${widget.game.S3T1}\n${widget.game.S1T2}-${widget.game.S2T2}-${widget.game.S3T2}\n${widget.game.risultato}",
                          titleTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: w > 605
                                  ? 40
                                  : w > 385
                                      ? 30
                                      : 25,
                              fontWeight: FontWeight.w700),
                          desc: "Vuoi confermare il risultato?",
                          descTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: w > 605
                                  ? 25
                                  : w > 385
                                      ? 20
                                      : 18,
                              fontWeight: FontWeight.w700),
                          btnOkOnPress: () async {
                            if (widget.appointment['permissions'] + 1 ==
                                widget.appointment['playerCount1'] +
                                    widget.appointment['playerCount2']) {
                              for (int a = 1; a <= 2; a++) {
                                int c = 0;
                                if (widget.game.risultato == 'VITTORIA') {
                                  c = 1;
                                }
                                for (int i = 1;
                                    i <= widget.appointment['playerCount$a'];
                                    i++) {
                                  QuerySnapshot<
                                      Map<String,
                                          dynamic>> data = await FirebaseFirestore
                                      .instance
                                      .collection('User')
                                      .where('email',
                                          isEqualTo: widget
                                              .appointment['team${a}_P$i'])
                                      .get();
                                  final profile = data.docs
                                      .map((user) =>
                                          UserModel.fromSnapshot(user))
                                      .single;

                                  await FirebaseFirestore.instance
                                      .collection('User')
                                      .doc(profile.email)
                                      .set({
                                    "id": profile.id,
                                    "username": profile.username,
                                    "email": profile.email,
                                    "phoneNumber": profile.phoneNumber,
                                    "city": profile.city,
                                    "password": profile.password,
                                    "profile_pic": profile.profile_pic,
                                    "cover_pic": profile.cover_pic,
                                    "isEmailVerified": profile.isEmailVerified,
                                    'games': profile.games,
                                    'goals': profile.goals,
                                    'win': profile.win,
                                    'games_tennis': profile.games_tennis + 1,
                                    'set_vinti':
                                        profile.set_vinti + widget.game.set,
                                    'win_tennis': profile.win_tennis + c,
                                    'prenotazioni': profile.prenotazioni,
                                    'token': profile.token
                                  });

                                  await FirebaseFirestore.instance
                                      .collection('User')
                                      .doc(profile.email)
                                      .collection('last games')
                                      .doc(
                                          '${widget.game.date}-${widget.game.club})')
                                      .set({
                                    'date': widget.game.date,
                                    'club': widget.game.club,
                                    'set_vinti': widget.game.set,
                                    'result': widget.game.risultato,
                                  });
                                }
                              }
                            } else {
                            }

                            sendGamePermission(
                              widget.game.host,
                              email,
                              widget.appointment['permissions'] + 1,
                              widget.game.userId,
                              widget.game.date,
                              'tennis',
                            );

                            userController.allGames.clear();

                            await FirebaseFirestore.instance
                                .collection('User')
                                .doc(email)
                                .collection('Tennis Games')
                                .doc(widget.game.date)
                                .delete();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          docIds: email,
                                          avviso: true,
                                          sport: 'tennis',
                                        )));
                          },
                          btnOkIcon: Icons.thumb_up,
                          btnOkText: "CONFERMA",
                          btnOkColor: kBackgroundColor2)
                      .show();
                },
              ),
              SizedBox(width: w * 0.04),
              AnimatedButton(
                isFixedHeight: false,
                height: h > 700 ? h * 0.035 : h * 0.04,
                width: w > 385 ? w * 0.3 : w * 0.35,
                text: "SEGNALA",
                buttonTextStyle: TextStyle(
                    letterSpacing: 0.5,
                    color: Colors.black,
                    fontSize: w > 605 ? 20 : 16,
                    fontWeight: FontWeight.bold),
                color: Colors.red,
                pressEvent: () {
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          showCloseIcon: true,
                          title:
                              "Se non hai preso parte a questa partita manda una segnalazione",
                          titleTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: w > 605
                                  ? 25
                                  : w > 385
                                      ? 18
                                      : 15,
                              fontWeight: FontWeight.w700),
                          desc: "Vuoi Segnalare?",
                          descTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: w > 605
                                  ? 30
                                  : w > 385
                                      ? 20
                                      : 18,
                              fontWeight: FontWeight.w700),
                          btnOkOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection('User')
                                .doc(email)
                                .collection('Tennis Games')
                                .doc(widget.game.date)
                                .delete();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          docIds: email,
                                          avviso: false,
                                          sport: 'tennis',
                                        )));
                          },
                          btnOkIcon: Icons.thumb_up,
                          btnOkText: "CONFERMA",
                          btnOkColor: kBackgroundColor2)
                      .show();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> sendGamePermission(
    String userFriend,
    String host,
    int counter,
    String id,
    String date,
    String sport,
  ) async {
    await FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: dbPrenotazioniURL)
        .ref()
        .child('Prenotazioni')
        .child(id)
        .child(sport)
        .child(date)
        .update({'permissions': counter});
  }

  Future<void> loadGoalsToPlayers(
    Map appointment,
  ) async {
    for (int a = 1; a <= 2; a++) {
      int c = 0;
      if (appointment['totTeam1'] > appointment['totTeam2']) {
        if (a == 1) {
          c = 1;
        }
      }
      if (appointment['totTeam2'] > appointment['totTeam1']) {
        if (a == 2) {
          c = 1;
        }
      }
      for (int i = 1; 1 < appointment['playerCount$a']; i++) {
        Map utente = {};
        FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('User')
                .doc(appointment['team${a}_$i'])
                .get(),
            builder: (((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> profile =
                    snapshot.data!.data() as Map<String, dynamic>;

                setState(() {
                  utente = profile;
                });

                return Container();
              }
              return Container();
            })));

        await FirebaseFirestore.instance
            .collection('User')
            .doc(appointment['team${a}_$i'])
            .set({
          'games': utente['games'] + 1,
          'goals': utente['goals'] + appointment['t${a}p$i goals'],
          'win': utente['win'] + c,
        });
      }
    }
  }
}
