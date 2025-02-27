import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/page/visit_profile_page.dart';
import 'package:sports_hub_ios/screen/football_create_results_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Crea_Match/football_create_results_page.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({super.key, required this.friends, required this.sport});

  final Map friends;
  final String sport;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return friends['email'].isEmpty
        ? Container(color: Colors.black)
        : Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VisitProfilePage(
                                userFriend: friends['email'],
                                showRequest: false,
                              )));
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          //right: kDefaultPadding,
                          //left: kDefaultPadding,
                          top: kDefaultPadding,
                          //bottom: kDefaultPadding * 15,
                        ),
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        width: size.width * 0.8,
                        height: w > 605 ? h * 0.4 : size.height * 0.2,
                        child: CachedNetworkImage(
                          imageUrl: friends['profile_pic'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.fill)),
                          ),
                          placeholder: (context, url) => Container(
                            padding: const EdgeInsets.all(0),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          ),
                          //errorWidget: (context, url, error) => Image.asset("assets/images/arena.jpg")
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(children: <Widget>[
                            Container(
                                width: size.width * 0.8,
                                height: size.height > 700
                                    ? size.height * 0.19
                                    : size.height * 0.24,
                                margin: const EdgeInsets.only(
                                    //left: kDefaultPadding,
                                    //right: kDefaultPadding,
                                    // top: kDefaultPadding,
                                    //bottom: kDefaultPadding * 15,
                                    ),
                                padding: const EdgeInsets.only(
                                    right: 0, left: 0, top: 15),
                                decoration: const BoxDecoration(
                                  color: kBackgroundColor2,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Column(children: <Widget>[
                                  Text(friends['username'],
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: w > 385 ? 18 : 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: size.height * 0.01),

                                  sport == 'football'
                                      ? FootballStatsWidgetCard(
                                          profile: friends)
                                      : TennisStatsWidgetCard(profile: friends),

                                  SizedBox(height: size.height * 0.01),
                                  //if(friends['isRequested'] == 'false')
                                  AnimatedButton(
                                    isFixedHeight: false,
                                    height: size.height > 700
                                        ? h * 0.03
                                        : h * 0.035,
                                    width: w > 385 ? w * 0.4 : w * 0.5,
                                    text: "RIMUOVI AMICO",
                                    buttonTextStyle: TextStyle(
                                        letterSpacing: 0.5,
                                        color: Colors.white,
                                        fontSize: w > 605
                                            ? 20
                                            : w > 385
                                                ? 15
                                                : 9,
                                        fontWeight: FontWeight.bold),
                                    color: kBackgroundColor2,
                                    pressEvent: () {
                                      AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.success,
                                              animType: AnimType.topSlide,
                                              showCloseIcon: true,
                                              title: "RIMUOVI AMICO",
                                              titleTextStyle: TextStyle(
                                                  fontSize: w > 605
                                                      ? 35
                                                      : w > 385
                                                          ? 30
                                                          : 25,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                              desc:
                                                  "Confermando, Tu e ${friends['username']} non sarete piu amici",
                                              descTextStyle: TextStyle(
                                                  fontSize: w > 605
                                                      ? 25
                                                      : w > 385
                                                          ? 20
                                                          : 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                              btnOkOnPress: () async {
                                                Navigator.of(context).push(
                                                    HeroDialogRoute(
                                                        builder: (context) {
                                                  return const LoadingScreen();
                                                }));

                                                await FirebaseFirestore.instance
                                                    .collection("User")
                                                    .doc(email)
                                                    .collection('Friends')
                                                    .doc(friends['email'])
                                                    .delete();

                                                await FirebaseFirestore.instance
                                                    .collection("User")
                                                    .doc(friends['email'])
                                                    .collection('Friends')
                                                    .doc(email)
                                                    .delete();

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePage(
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

                                  //                            GestureDetector(
                                  //                              onTap: () async {
                                  //                                await FirebaseFirestore.instance.collection("User").doc(email).collection('Friends').doc(friends['email']).
                                  //                                delete();
                                  //                                //update({'isRequested': 'refused'});
                                  //                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                  //                  FriendsPage(docIds: email, h: h, w: w, future: FirebaseFirestore.instance
                                  //    .collection('User')
                                  //    .doc(email)
                                  //    .collection('Friends')
                                  //    .where('isRequested', isEqualTo: 'false')
                                  //    .get(),)));
                                  //                              },
                                  //                              child: Text('Rimuovi amico', style: TextStyle(color: Colors.white, fontSize: 13),),
                                  //                            )
                                ])),
                          ])
                          //)
                          )
                    ]),
              )
            ],
          );
  }

  Future<void> _dialogBuilder(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
  }
}

class FootballStatsWidgetCard extends StatelessWidget {
  const FootballStatsWidgetCard({super.key, required this.profile});

  //final UserModel profile;
  final Map profile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height > 700 ? size.height * 0.08 : size.height * 0.1,
      width: size.width * 0.5,
      decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButton(
              text: 'Games',
              value: profile['games'],
              w: size.width,
              h: size.height),
          // buildDivider(),
          buildButton(
              text: 'Goal ',
              value: profile['goals'],
              w: size.width,
              h: size.height),
          //buildDivider(),
          buildButton(
              text: ' Win ',
              value: profile['win'],
              w: size.width,
              h: size.height),
        ],
      ),
    );
  }

  Widget buildDivider() => const SizedBox(
        height: 24,
        child: VerticalDivider(
          width: 1,
        ),
      );

  Widget buildButton(
          {required String text,
          required int value,
          required double w,
          required double h}) =>
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        //onPressed: (){},
        //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value',
              style: TextStyle(
                  color: kBackgroundColor2,
                  fontWeight: FontWeight.bold,
                  fontSize: w > 605
                      ? 20
                      : w > 385
                          ? 14
                          : 12),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w > 605
                      ? 20
                      : w > 385
                          ? 14
                          : 12,
                  color: kBackgroundColor2),
            )
          ],
        ),
      );
}

class TennisStatsWidgetCard extends StatelessWidget {
  const TennisStatsWidgetCard({super.key, required this.profile});

  //final UserModel profile;
  final Map profile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height > 700 ? size.height * 0.08 : size.height * 0.1,
      width: size.width * 0.5,
      decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButton(
              text: 'Games',
              value: profile['games_tennis'],
              w: size.width,
              h: size.height),
          // buildDivider(),
          buildButton(
              text: ' Set ',
              value: profile['set_vinti'],
              w: size.width,
              h: size.height),
          //buildDivider(),
          buildButton(
              text: ' Win ',
              value: profile['win_tennis'],
              w: size.width,
              h: size.height),
        ],
      ),
    );
  }

  Widget buildDivider() => const SizedBox(
        height: 24,
        child: VerticalDivider(
          width: 1,
        ),
      );

  Widget buildButton(
          {required String text,
          required int value,
          required double w,
          required double h}) =>
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        //onPressed: (){},
        //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value',
              style: TextStyle(
                color: kBackgroundColor2,
                fontWeight: FontWeight.bold,
                fontSize: w > 605
                    ? 20
                    : w > 385
                        ? 14
                        : 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w > 605
                      ? 20
                      : w > 385
                          ? 14
                          : 12,
                  color: kBackgroundColor2),
            )
          ],
        ),
      );
}

class FootballCandidateCard extends StatefulWidget {
  const FootballCandidateCard({
    super.key,
    required this.profile,
    required this.list1,
    required this.appointment,
  });

  //final UserModel profile;
  final String profile;
  final List list1;
  final Map appointment;

  @override
  State<FootballCandidateCard> createState() => _FootballCandidateCardState();
}

class _FootballCandidateCardState extends State<FootballCandidateCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List list1 = widget.list1;
    Map appointmentData = {};
    Map listaCandidati = {};
    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();

    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('User')
            .doc(widget.profile)
            .get(),
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> candidato =
                snapshot.data!.data() as Map<String, dynamic>;

            return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      //right: kDefaultPadding,
                      //left: kDefaultPadding,
                      top: kDefaultPadding,
                      //bottom: kDefaultPadding * 15,
                    ),
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    width: size.width * 0.75,
                    height: size.height > 600
                        ? size.height * 0.28
                        : size.height * 0.25,
                    child: CachedNetworkImage(
                      imageUrl: candidato['profile_pic'],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                      placeholder: (context, url) => Container(
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                      //errorWidget: (context, url, error) => Image.asset("assets/images/arena.jpg")
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: size.width * 0.8,
                          height: size.height > 700
                              ? size.height * 0.22
                              : size.height * 0.24,
                          margin: const EdgeInsets.only(
                              //left: kDefaultPadding,
                              //right: kDefaultPadding,
                              // top: kDefaultPadding,
                              //bottom: kDefaultPadding * 15,
                              ),
                          padding:
                              const EdgeInsets.only(right: 0, left: 0, top: 15),
                          decoration: const BoxDecoration(
                            color: kBackgroundColor2,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(children: <Widget>[
                            DefaultTextStyle(
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: size.width > 605
                                      ? 25
                                      : size.width > 355
                                          ? 18
                                          : 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              child: Text(
                                candidato['username'],
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Container(
                                height: size.height > 700
                                    ? size.height * 0.08
                                    : size.height * 0.1,
                                width: size.width * 0.5,
                                decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildButton(
                                          text: 'Games',
                                          value: candidato['games'],
                                          w: size.width,
                                          h: size.height),
                                      // buildDivider(),
                                      buildButton(
                                          text: 'Goal ',
                                          value: candidato['goals'],
                                          w: size.width,
                                          h: size.height),
                                      //buildDivider(),
                                      buildButton(
                                          text: ' Win ',
                                          value: candidato['win'],
                                          w: size.width,
                                          h: size.height),
                                    ])),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AnimatedButton(
                                  isFixedHeight: false,
                                  height: size.height > 900
                                      ? size.height * 0.035
                                      : size.height * 0.04,
                                  width: size.width > 390
                                      ? size.width * 0.2
                                      : size.width * 0.3,
                                  text: "Team 1",
                                  buttonTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width > 605
                                          ? 25
                                          : size.width > 390
                                              ? 18
                                              : 13,
                                      fontWeight: FontWeight.bold),
                                  color: kPrimaryColor,
                                  pressEvent: () {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            animType: AnimType.topSlide,
                                            showCloseIcon: true,
                                            title: "Conferma Giocatore",
                                            titleTextStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    size.width > 605 ? 40 : 18),
                                            desc:
                                                "Vuoi aggiungere ${candidato['username']} nel Team 2?",
                                            descTextStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    size.width > 605 ? 30 : 18),
                                            btnOkOnPress: () async {
                                              if (list1.isEmpty) {
                                                list1.add(candidato['email']);

                                                FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL:
                                                            dbPrenotazioniURL)
                                                    .ref(
                                                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/football/Crea_Match/${widget.appointment['dateURL']}')
                                                    .onValue
                                                    .listen(
                                                        (DatabaseEvent event) {
                                                  final data = event
                                                      .snapshot.value as Map;
                                                  //print(data);

                                                  appointmentData
                                                      .assignAll(data);
                                                });

                                                FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL:
                                                            dbPrenotazioniURL)
                                                    .ref(
                                                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/football/Crea_Match/${widget.appointment['dateURL']}/candidati')
                                                    .onValue
                                                    .listen(
                                                        (DatabaseEvent event) {
                                                  final listaCandidati1 = event
                                                      .snapshot.value as Map;

                                                  listaCandidati.assignAll(
                                                      listaCandidati1);
                                                });

                                                sendToServer1Create(
                                                    uid,
                                                    utente,
                                                    widget.appointment['club'],
                                                    widget.appointment['campo'],
                                                    widget.appointment['day'],
                                                    widget.appointment['time'],
                                                    widget.appointment['month'],
                                                    widget.appointment[
                                                            'playerCount1'] +
                                                        1,
                                                    candidato['email'],
                                                    'football',
                                                    widget.appointment['city'],
                                                    widget.appointment,
                                                    listaCandidati);
                                              }

                                              for (int i = 0;
                                                  i < (list1.length);
                                                  i++) {
                                                if (candidato['email'] !=
                                                    list1[i]) {
                                                  counter1 = counter1 + 1;
                                                }
                                              }

                                              if (counter1 == list1.length &&
                                                  widget.appointment[
                                                          'playerCount1Tot'] <
                                                      (widget.appointment[
                                                          'teamSize'])) {
                                                FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL:
                                                            dbPrenotazioniURL)
                                                    .ref(
                                                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/football/Crea_Match/${widget.appointment['dateURL']}/candidati')
                                                    .onValue
                                                    .listen(
                                                        (DatabaseEvent event) {
                                                  final listaCandidati1 = event
                                                      .snapshot.value as Map;

                                                  listaCandidati.assignAll(
                                                      listaCandidati1);
                                                });
                                                sendToServer1Create(
                                                    uid,
                                                    utente,
                                                    widget.appointment['club'],
                                                    widget.appointment['campo'],
                                                    widget.appointment['day'],
                                                    widget.appointment['time'],
                                                    widget.appointment['month'],
                                                    widget.appointment[
                                                            'playerCount1'] +
                                                        1,
                                                    candidato['email'],
                                                    'football',
                                                    widget.appointment['city'],
                                                    widget.appointment,
                                                    listaCandidati);

                                                Future.delayed(const Duration(
                                                    milliseconds: 355));

                                                FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL:
                                                            dbPrenotazioniURL)
                                                    .ref(
                                                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/football/Crea_Match/${widget.appointment['dateURL']}')
                                                    .onValue
                                                    .listen(
                                                        (DatabaseEvent event) {
                                                  final data = event
                                                      .snapshot.value as Map;
                                                  //print(data);

                                                  appointmentData
                                                      .assignAll(data);
                                                });
                                              }
                                              //setState(() {
                                              counter1 = 0;

                                              //});

                                              Future.delayed(const Duration(
                                                  milliseconds: 355));

                                              if (appointmentData.isEmpty) {
                                                appointmentData.assignAll(
                                                    widget.appointment);
                                              }

                                              //print(appointmentData);
                                              appointmentData.isEmpty
                                                  ? appointmentData =
                                                      widget.appointment
                                                  : Container();
                                              //       if (widget.sport == 'football') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FootballCreateResultsPage(
                                                              appointment:
                                                                  appointmentData)));
                                            },
                                            btnOkIcon: Icons.thumb_up,
                                            btnOkText: "Conferma",
                                            btnOkColor: Colors.green[800],
                                            buttonsTextStyle: TextStyle(
                                                fontSize:
                                                    size.width > 605 ? 30 : 18,
                                                color: Colors.white))
                                        .show();
                                  },
                                ),
                                AnimatedButton(
                                  isFixedHeight: false,
                                  height: size.height > 900
                                      ? size.height * 0.035
                                      : size.height * 0.04,
                                  width: size.width > 390
                                      ? size.width * 0.2
                                      : size.width * 0.3,
                                  text: "Team 2",
                                  buttonTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width > 605
                                          ? 25
                                          : size.width > 390
                                              ? 18
                                              : 13,
                                      fontWeight: FontWeight.bold),
                                  color: kPrimaryColor,
                                  pressEvent: () {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            animType: AnimType.topSlide,
                                            showCloseIcon: true,
                                            title: "Conferma Giocatore",
                                            titleTextStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    size.width > 605 ? 40 : 18),
                                            desc:
                                                "Vuoi aggiungere ${candidato['username']} nel Team 2?",
                                            descTextStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    size.width > 605 ? 30 : 18),
                                            btnOkOnPress: () async {
                                              if (list1.isEmpty) {
                                                list1.add(candidato['email']);

                                                FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL:
                                                            dbPrenotazioniURL)
                                                    .ref(
                                                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/football/Crea_Match/${widget.appointment['dateURL']}')
                                                    .onValue
                                                    .listen(
                                                        (DatabaseEvent event) {
                                                  final data = event
                                                      .snapshot.value as Map;
                                                  //print(data);

                                                  appointmentData
                                                      .assignAll(data);
                                                });

                                                FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL:
                                                            dbPrenotazioniURL)
                                                    .ref(
                                                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/football/Crea_Match/${widget.appointment['dateURL']}/candidati')
                                                    .onValue
                                                    .listen(
                                                        (DatabaseEvent event) {
                                                  final listaCandidati1 = event
                                                      .snapshot.value as Map;

                                                  listaCandidati.assignAll(
                                                      listaCandidati1);
                                                });

                                                sendToServer2Create(
                                                    uid,
                                                    utente,
                                                    widget.appointment['club'],
                                                    widget.appointment['campo'],
                                                    widget.appointment['day'],
                                                    widget.appointment['time'],
                                                    widget.appointment['month'],
                                                    widget.appointment[
                                                            'playerCount2'] +
                                                        1,
                                                    candidato['email'],
                                                    'football',
                                                    widget.appointment['city'],
                                                    widget.appointment,
                                                    listaCandidati);
                                              }

                                              for (int i = 0;
                                                  i < (list1.length);
                                                  i++) {
                                                if (candidato['email'] !=
                                                    list1[i]) {
                                                  counter1 = counter1 + 1;
                                                }
                                              }

                                              if (counter1 == list1.length &&
                                                  widget.appointment[
                                                          'playerCount2Tot'] <
                                                      (widget.appointment[
                                                          'teamSize'])) {
                                                FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL:
                                                            dbPrenotazioniURL)
                                                    .ref(
                                                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/football/Crea_Match/${widget.appointment['dateURL']}/candidati')
                                                    .onValue
                                                    .listen(
                                                        (DatabaseEvent event) {
                                                  final listaCandidati1 = event
                                                      .snapshot.value as Map;

                                                  listaCandidati.assignAll(
                                                      listaCandidati1);
                                                });
                                                sendToServer2Create(
                                                    uid,
                                                    utente,
                                                    widget.appointment['club'],
                                                    widget.appointment['campo'],
                                                    widget.appointment['day'],
                                                    widget.appointment['time'],
                                                    widget.appointment['month'],
                                                    widget.appointment[
                                                            'playerCount2'] +
                                                        1,
                                                    candidato['email'],
                                                    'football',
                                                    widget.appointment['city'],
                                                    widget.appointment,
                                                    listaCandidati);

                                                Future.delayed(const Duration(
                                                    milliseconds: 355));

                                                FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL:
                                                            dbPrenotazioniURL)
                                                    .ref(
                                                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/football/Crea_Match/${widget.appointment['dateURL']}')
                                                    .onValue
                                                    .listen(
                                                        (DatabaseEvent event) {
                                                  final data = event
                                                      .snapshot.value as Map;
                                                  //print(data);

                                                  appointmentData
                                                      .assignAll(data);
                                                });
                                              }
                                              //setState(() {
                                              counter1 = 0;

                                              //});

                                              Future.delayed(const Duration(
                                                  milliseconds: 355));

                                              if (appointmentData.isEmpty) {
                                                appointmentData.assignAll(
                                                    widget.appointment);
                                              }

                                              //print(appointmentData);
                                              appointmentData.isEmpty
                                                  ? appointmentData =
                                                      widget.appointment
                                                  : Container();
                                              //       if (widget.sport == 'football') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FootballCreateResultsPage(
                                                              appointment:
                                                                  appointmentData)));
                                              //           }
                                              //         if (widget.sport == 'tennis') {
                                              //         Navigator.push(
                                              //           context,
                                              //         MaterialPageRoute(
                                              //           builder: (context) =>
                                              //             TennisResultsPage(appointment: appointmentData)));
                                              //     }
                                            },
                                            btnOkIcon: Icons.thumb_up,
                                            btnOkText: "Conferma",
                                            btnOkColor: Colors.green[800],
                                            buttonsTextStyle: TextStyle(
                                                fontSize:
                                                    size.width > 605 ? 30 : 18,
                                                color: Colors.white))
                                        .show();
                                  },
                                ),
                              ],
                            )
                          ]),
                        ),
                      ],
                    ),
                  )
                ]);
          }
          return const LoadingScreen();
        })));
  }

  Widget buildDivider() => const SizedBox(
        height: 24,
        child: VerticalDivider(
          width: 1,
        ),
      );

  Widget buildButton(
          {required String text,
          required int value,
          required double w,
          required double h}) =>
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        //onPressed: (){},
        //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                  color: kBackgroundColor2,
                  fontWeight: FontWeight.bold,
                  fontSize: w > 605
                      ? 20
                      : w > 385
                          ? 14
                          : 12),
              child: Text(
                '$value',
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 2),
            DefaultTextStyle(
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w > 605
                      ? 20
                      : w > 385
                          ? 14
                          : 12,
                  color: kBackgroundColor2),
              child: Text(
                text,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      );
}

void sendToServer1Create(
    String id,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    int playerCount,
    String selectedUser,
    String sport,
    String city,
    Map appointment,
    Map candidati) async {
  await FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child(sport)
      .child('Crea_Match')
      .child('$month-$day-$time')
      .update({
    'playerCount1': playerCount,
    'playerCount1Tot': playerCount,
    'team1_P$playerCount': selectedUser,
  });

  await FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child('Crea_Match')
      .child(city)
      .child(sport)
      .child('$month-$day-$time')
      .update({
    'playerCount1': playerCount,
    'playerCount1Tot': playerCount,
    'team1_P$playerCount': selectedUser,
  });

  List listC = [];

  for (int i = 0; i < appointment['candidatiTot']; i++) {
    if (candidati['c$i'].toString() == selectedUser.toString()) {
      print('if si');
    } else {
      listC.add(selectedUser);
      print('else');
    }
  }
  if (listC.isEmpty) {
    await FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: dbPrenotazioniURL)
        .ref()
        .child('Prenotazioni')
        .child(id)
        .child(sport)
        .child('Crea_Match')
        .child('$month-$day-$time')
        .child('candidati')
        .set(null);
    print('list empty');
    await FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: dbPrenotazioniURL)
        .ref()
        .child('Prenotazioni')
        .child(id)
        .child(sport)
        .child('Crea_Match')
        .child('$month-$day-$time')
        .update({'candidatiTot': 0});
  } else {
    for (int i = 0; i < listC.length; i++) {
      print('agguirna lista');
      await FirebaseDatabase.instanceFor(
              app: Firebase.app(), databaseURL: dbPrenotazioniURL)
          .ref()
          .child('Prenotazioni')
          .child(id)
          .child(sport)
          .child('Crea_Match')
          .child('$month-$day-$time')
          .child('candidati')
          .update({
        'c$i': listC[i],
      });
    }
  }
}

void sendToServer2Create(
    String id,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    int playerCount,
    String selectedUser,
    String sport,
    String city,
    Map appointment,
    Map candidati) async {
  await FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child('Crea_Match')
      .child(city)
      .child(sport)
      .child('$month-$day-$time')
      .update({
    'playerCount2': playerCount,
    'playerCount2Tot': playerCount,
    'team2_P$playerCount': selectedUser,
  });

  await FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child(sport)
      .child('Crea_Match')
      .child('$month-$day-$time')
      .update({
    'playerCount2': playerCount,
    'playerCount2Tot': playerCount,
    'team2_P$playerCount': selectedUser,
  });

  List listC = [];

  for (int i = 0; i < appointment['candidatiTot']; i++) {
    if (candidati['c$i'].toString() == selectedUser.toString()) {
      print('if si');
    } else {
      listC.add(selectedUser);
      print('else');
    }
  }
  if (listC.isEmpty) {
    await FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: dbPrenotazioniURL)
        .ref()
        .child('Prenotazioni')
        .child(id)
        .child(sport)
        .child('Crea_Match')
        .child('$month-$day-$time')
        .child('candidati')
        .set(null);
    print('list empty');
    await FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: dbPrenotazioniURL)
        .ref()
        .child('Prenotazioni')
        .child(id)
        .child(sport)
        .child('Crea_Match')
        .child('$month-$day-$time')
        .update({'candidatiTot': 0});
  } else {
    for (int i = 0; i < listC.length; i++) {
      print('agguirna lista');
      await FirebaseDatabase.instanceFor(
              app: Firebase.app(), databaseURL: dbPrenotazioniURL)
          .ref()
          .child('Prenotazioni')
          .child(id)
          .child(sport)
          .child('Crea_Match')
          .child('$month-$day-$time')
          .child('candidati')
          .update({
        'c$i': listC[i],
      });
    }
  }
}
