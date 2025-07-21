import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/page/football_results_page.dart';
import 'package:sports_hub_ios/page/tennis_result_page.dart';
import 'package:sports_hub_ios/screen/football_results_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Crea_Match/football_create_results_page.dart';

class TeammateCard1 extends StatefulWidget {
  const TeammateCard1({
    super.key,
    required this.appointment,
    required this.teammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final Map teammate;
  final String sport;

  final List list1;

  @override
  State<TeammateCard1> createState() => _TeammateCard1State();
}

class _TeammateCard1State extends State<TeammateCard1> {
  @override
  Widget build(BuildContext context) {
    List list1 = widget.list1;

    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Map appointmentData = {};

    String address = '';

    widget.appointment['crea_match']
        ? address = '${widget.sport}/Crea_Match'
        : address = widget.sport;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: kDefaultPadding),
          child: GestureDetector(
              onTap: () {
                if (list1.isEmpty) {
                  list1.add(widget.teammate['email']);

                  sendToServer1(
                      uid,
                      utente,
                      widget.appointment['club'],
                      widget.appointment['campo'],
                      widget.appointment['day'],
                      widget.appointment['time'],
                      widget.appointment['month'],
                      widget.appointment['playerCount1'] + 1,
                      widget.teammate['email'],
                      widget.sport,
                      widget.appointment['crea_match']);
                }

                for (int i = 0; i < (list1.length); i++) {
                  if (widget.teammate['email'] != list1[i]) {
                    counter1 = counter1 + 1;
                  }
                }

                if (counter1 == list1.length &&
                    widget.appointment['playerCount1Tot'] <
                        (widget.appointment['teamSize'])) {
                  sendToServer1(
                      uid,
                      utente,
                      widget.appointment['club'],
                      widget.appointment['campo'],
                      widget.appointment['day'],
                      widget.appointment['time'],
                      widget.appointment['month'],
                      widget.appointment['playerCount1'] + 1,
                      widget.teammate['email'],
                      widget.sport,
                      widget.appointment['crea_match']);
                }
                FirebaseDatabase.instanceFor(
                        app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                    .ref(
                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/$address/${widget.appointment['dateURL']}')
                    .onValue
                    .listen((DatabaseEvent event) {
                  final data = event.snapshot.value as Map;
                  

                  appointmentData.assignAll(data);
                }); 
                counter1 = 0;


                if (appointmentData.isEmpty) {
                  appointmentData.assignAll(widget.appointment);
                  print('empty');
                  print(appointmentData);
                }

                Future.delayed(const Duration(milliseconds: 500), () {
                  appointmentData.isEmpty
                      ? appointmentData = widget.appointment
                      : appointmentData = appointmentData;
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
              child: Container(
                padding: EdgeInsets.only(
                    left: w * 0.07,
                    right: w * 0.05,
                    top: h * 0.016,
                    bottom: h * 0.016),
                decoration: const BoxDecoration(
                    color: kBackgroundColor2,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 75,
                        width: 75,
                        decoration: const BoxDecoration(
                            color: kPrimaryColor, shape: BoxShape.circle),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.teammate['profile_pic'],
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
                      ),
                      SizedBox(width: w * 0.05),
                      DefaultTextStyle(
                        style: TextStyle(
                            fontSize: w > 385
                                ? widget.teammate['username'].length > 8
                                    ? 15
                                    : widget.teammate['username'].length > 6
                                        ? 18
                                        : 20
                                : widget.teammate['username'].length > 8
                                    ? 12
                                    : widget.teammate['username'].length > 5
                                        ? 14
                                        : 16,
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        child: Text(
                          widget.teammate['username'],
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ]),
              )
              //)
              ),
        )
      ],
    );
  }
}

class TeammateCard2 extends StatefulWidget {
  const TeammateCard2({
    super.key,
    required this.appointment,
    required this.teammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final Map teammate;

  final String sport;

  final List list1;

  @override
  State<TeammateCard2> createState() => _TeammateCardState();
}

class _TeammateCardState extends State<TeammateCard2> {
  @override
  Widget build(BuildContext context) {
    List list1 = widget.list1;

    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Map appointmentData = {};

    String address = '';

    widget.appointment['crea_match']
        ? address = '${widget.sport}/Crea_Match'
        : address = widget.sport;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              if (list1.isEmpty) {
                list1.add(widget.teammate['email']);
                FirebaseDatabase.instanceFor(
                        app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                    .ref(
                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/$address/${widget.appointment['dateURL']}')
                    .onValue
                    .listen((DatabaseEvent event) {
                  final data = event.snapshot.value as Map;

                  appointmentData.assignAll(data);
                });


                sendToServer2(
                    uid,
                    utente,
                    widget.appointment['club'],
                    widget.appointment['campo'],
                    widget.appointment['day'],
                    widget.appointment['time'],
                    widget.appointment['month'],
                    widget.appointment['playerCount2'] + 1,
                    widget.teammate['email'],
                    widget.sport,
                    widget.appointment['crea_match']);
              }

              for (int i = 0; i < (list1.length); i++) {
                if (widget.teammate['email'] != list1[i]) {
                  counter1 = counter1 + 1;
                }
              }

              if (counter1 == list1.length &&
                  widget.appointment['playerCount2'] <
                      (widget.appointment['teamSize'])) {
                sendToServer2(
                    uid,
                    utente,
                    widget.appointment['club'],
                    widget.appointment['campo'],
                    widget.appointment['day'],
                    widget.appointment['time'],
                    widget.appointment['month'],
                    widget.appointment['playerCount2'] + 1,
                    widget.teammate['email'],
                    widget.sport,
                    widget.appointment['crea_match']);
                FirebaseDatabase.instanceFor(
                        app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                    .ref(widget.appointment['crea_match']
                        ? 'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/${widget.sport}/Crea_Match/${widget.appointment['dateURL']}'
                        : 'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/${widget.sport}/${widget.appointment['dateURL']}')
                    .onValue
                    .listen((DatabaseEvent event) {
                  final data = event.snapshot.value as Map;

                  appointmentData.assignAll(data);
                });
              }
              setState(() {
                counter1 = 0;
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
                          builder: (context) => FootballResultsPage(
                                appointment: appointmentData,
                                create: false,
                              )));
                }
                if (widget.sport == 'tennis') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TennisResultsPage(appointment: appointmentData)));
                }
              });
            },
            child: Container(
              padding: EdgeInsets.only(
                  left: w * 0.07,
                  right: w * 0.05,
                  top: h * 0.016,
                  bottom: h * 0.016),
              decoration: const BoxDecoration(
                  color: kBackgroundColor2,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: const BoxDecoration(
                          color: kPrimaryColor, shape: BoxShape.circle),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.teammate['profile_pic']!,
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
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.05),
                    DefaultTextStyle(
                      style: TextStyle(
                          fontSize: w > 385
                              ? widget.teammate['username'].length > 8
                                  ? 15
                                  : widget.teammate['username'].length > 6
                                      ? 18
                                      : 20
                              : widget.teammate['username'].length > 8
                                  ? 12
                                  : widget.teammate['username'].length > 5
                                      ? 14
                                      : 16,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      child: Text(
                        widget.teammate['username'],
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ]),
            ),
          ),
        )
      ],
    );
  }
}

class TeammateCreateCard1 extends StatefulWidget {
  const TeammateCreateCard1({
    super.key,
    required this.appointment,
    required this.teammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final Map teammate;
  final String sport;

  final List list1;

  @override
  State<TeammateCreateCard1> createState() => _TeammateCreateCard1State();
}

class _TeammateCreateCard1State extends State<TeammateCreateCard1> {
  @override
  Widget build(BuildContext context) {
    List list1 = widget.list1;

    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Map appointmentData = {};

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: kDefaultPadding),
          child: GestureDetector(
              onTap: () {
                if (list1.isEmpty) {
                  list1.add(widget.teammate['email']);

                  FirebaseDatabase.instanceFor(
                          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                      .ref(
                          'Prenotazioni/$uid/${widget.sport}/Crea_Match/${widget.appointment['dateURL']}')
                      .onValue
                      .listen((DatabaseEvent event) {
                    final data = event.snapshot.value as Map;

                    appointmentData.assignAll(data);
                  });

                  sendToServer1Create(
                      uid,
                      utente,
                      widget.appointment['club'],
                      widget.appointment['campo'],
                      widget.appointment['day'],
                      widget.appointment['time'],
                      widget.appointment['month'],
                      widget.appointment['playerCount1'] + 1,
                      widget.teammate['email'],
                      widget.sport,
                      widget.appointment['city']);
                }

                for (int i = 0; i < (list1.length); i++) {
                  if (widget.teammate['email'] != list1[i]) {
                    counter1 = counter1 + 1;
                  }
                }

                if (counter1 == list1.length &&
                    widget.appointment['playerCount1Tot'] <
                        (widget.appointment['teamSize'])) {
                  sendToServer1Create(
                      uid,
                      utente,
                      widget.appointment['club'],
                      widget.appointment['campo'],
                      widget.appointment['day'],
                      widget.appointment['time'],
                      widget.appointment['month'],
                      widget.appointment['playerCount1'] + 1,
                      widget.teammate['email'],
                      widget.sport,
                      widget.appointment['city']);

                  FirebaseDatabase.instanceFor(
                          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                      .ref(
                          'Prenotazioni/$uid/${widget.sport}/Crea_Match/${widget.appointment['dateURL']}')
                      .onValue
                      .listen((DatabaseEvent event) {
                    final data = event.snapshot.value as Map;

                    appointmentData.assignAll(data);
                  });
                }
                counter1 = 0;



                if (appointmentData.isEmpty) {
                  appointmentData.assignAll(widget.appointment);
                  print('if');
                }

                Future.delayed(const Duration(milliseconds: 500), () {
                  appointmentData.isEmpty
                      ? appointmentData = widget.appointment
                      : Container();
                  if (widget.sport == 'football') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FootballCreateResultsPage(
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
              child: Container(
                padding: EdgeInsets.only(
                    left: w * 0.07,
                    right: w * 0.05,
                    top: h * 0.016,
                    bottom: h * 0.016),
                decoration: const BoxDecoration(
                    color: kBackgroundColor2,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 75,
                        width: 75,
                        decoration: const BoxDecoration(
                            color: kPrimaryColor, shape: BoxShape.circle),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.teammate['profile_pic'],
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
                      ),
                      SizedBox(width: w * 0.05),
                      DefaultTextStyle(
                        style: TextStyle(
                            fontSize: w > 385
                                ? widget.teammate['username'].length > 8
                                    ? 15
                                    : widget.teammate['username'].length > 6
                                        ? 18
                                        : 20
                                : widget.teammate['username'].length > 8
                                    ? 12
                                    : widget.teammate['username'].length > 5
                                        ? 14
                                        : 16,
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        child: Text(
                          widget.teammate['username'],
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ]),
              )
              //)
              ),
        )
      ],
    );
  }
}

class TeammateCreateCard2 extends StatefulWidget {
  const TeammateCreateCard2({
    super.key,
    required this.appointment,
    required this.teammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final Map teammate;

  final String sport;

  final List list1;

  @override
  State<TeammateCreateCard2> createState() => _TeammateCreateCardState();
}

class _TeammateCreateCardState extends State<TeammateCreateCard2> {
  @override
  Widget build(BuildContext context) {
    List list1 = widget.list1;

    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Map appointmentData = {};

    return Stack(
      children: [
        Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              if (list1.isEmpty) {
                list1.add(widget.teammate['email']);
                FirebaseDatabase.instanceFor(
                        app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                    .ref(
                        'Prenotazioni/$uid/${widget.sport}/Crea_Match/${widget.appointment['dateURL']}')
                    .onValue
                    .listen((DatabaseEvent event) {
                  final data = event.snapshot.value as Map;
                  //print(data);

                  appointmentData.assignAll(data);
                });


                sendToServer2Create(
                    uid,
                    utente,
                    widget.appointment['club'],
                    widget.appointment['campo'],
                    widget.appointment['day'],
                    widget.appointment['time'],
                    widget.appointment['month'],
                    widget.appointment['playerCount2'] + 1,
                    widget.teammate['email'],
                    widget.sport,
                    widget.appointment['city']);
              }

              for (int i = 0; i < (list1.length); i++) {
                if (widget.teammate['email'] != list1[i]) {
                  counter1 = counter1 + 1;
                }
              }

              if (counter1 == list1.length &&
                  widget.appointment['playerCount2'] <
                      (widget.appointment['teamSize'])) {
                sendToServer2Create(
                    uid,
                    utente,
                    widget.appointment['club'],
                    widget.appointment['campo'],
                    widget.appointment['day'],
                    widget.appointment['time'],
                    widget.appointment['month'],
                    widget.appointment['playerCount2'] + 1,
                    widget.teammate['email'],
                    widget.sport,
                    widget.appointment['city']);
                FirebaseDatabase.instanceFor(
                        app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                    .ref(
                        'Prenotazioni/$uid/${widget.sport}/Crea_Match/${widget.appointment['dateURL']}')
                    .onValue
                    .listen((DatabaseEvent event) {
                  final data = event.snapshot.value as Map;
                  //print(data);

                  appointmentData.assignAll(data);
                });
              }
              setState(() {
                counter1 = 0;
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
                          builder: (context) => FootballCreateResultsPage(
                              appointment: appointmentData)));
                }
                if (widget.sport == 'tennis') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TennisResultsPage(appointment: appointmentData)));
                }
              });
            },
            child: Container(
              padding: EdgeInsets.only(
                  left: w * 0.07,
                  right: w * 0.05,
                  top: h * 0.016,
                  bottom: h * 0.016),
              decoration: const BoxDecoration(
                  color: kBackgroundColor2,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: const BoxDecoration(
                          color: kPrimaryColor, shape: BoxShape.circle),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.teammate['profile_pic']!,
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
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.05),
                    DefaultTextStyle(
                      style: TextStyle(
                          fontSize: w > 385
                              ? widget.teammate['username'].length > 8
                                  ? 15
                                  : widget.teammate['username'].length > 6
                                      ? 18
                                      : 20
                              : widget.teammate['username'].length > 8
                                  ? 12
                                  : widget.teammate['username'].length > 5
                                      ? 14
                                      : 16,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      child: Text(
                        widget.teammate['username'],
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ]),
            ),
          ),
        )
      ],
    );
  }
}

class CandidatoCard extends StatefulWidget {
  const CandidatoCard({
    super.key,
    required this.appointment,
    required this.teammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final Map teammate;

  final String sport;

  final List list1;

  @override
  State<CandidatoCard> createState() => _CandidatoCardState();
}

class _CandidatoCardState extends State<CandidatoCard> {
  @override
  Widget build(BuildContext context) {
    List list1 = widget.list1;

    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Map appointmentData = {};

    return Stack(
      children: [
        Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              if (list1.isEmpty) {
                list1.add(widget.teammate['email']);
                FirebaseDatabase.instanceFor(
                        app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                    .ref(
                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/${widget.sport}/Crea_Match/${widget.appointment['dateURL']}')
                    .onValue
                    .listen((DatabaseEvent event) {
                  final data = event.snapshot.value as Map;

                  appointmentData.assignAll(data);
                });


                sendToServer2Create(
                    uid,
                    utente,
                    widget.appointment['club'],
                    widget.appointment['campo'],
                    widget.appointment['day'],
                    widget.appointment['time'],
                    widget.appointment['month'],
                    widget.appointment['playerCount2'] + 1,
                    widget.teammate['email'],
                    widget.sport,
                    widget.appointment['city']);
              }

              for (int i = 0; i < (list1.length); i++) {
                if (widget.teammate['email'] != list1[i]) {
                  counter1 = counter1 + 1;
                }
              }

              if (counter1 == list1.length &&
                  widget.appointment['playerCount2'] <
                      (widget.appointment['teamSize'])) {
                sendToServer2Create(
                    uid,
                    utente,
                    widget.appointment['club'],
                    widget.appointment['campo'],
                    widget.appointment['day'],
                    widget.appointment['time'],
                    widget.appointment['month'],
                    widget.appointment['playerCount2'] + 1,
                    widget.teammate['email'],
                    widget.sport,
                    widget.appointment['city']);
                FirebaseDatabase.instanceFor(
                        app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                    .ref(
                        'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/${widget.sport}/Crea_Match/${widget.appointment['dateURL']}')
                    .onValue
                    .listen((DatabaseEvent event) {
                  final data = event.snapshot.value as Map;

                  appointmentData.assignAll(data);
                });
              }
              setState(() {
                counter1 = 0;
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
                          builder: (context) => FootballCreateResultsPage(
                              appointment: appointmentData)));
                }
                if (widget.sport == 'tennis') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TennisResultsPage(appointment: appointmentData)));
                }
              });
            },
            child: Container(
              padding: EdgeInsets.only(
                  left: w * 0.07,
                  right: w * 0.05,
                  top: h * 0.016,
                  bottom: h * 0.016),
              decoration: const BoxDecoration(
                  color: kBackgroundColor2,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: const BoxDecoration(
                          color: kPrimaryColor, shape: BoxShape.circle),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.teammate['profile_pic']!,
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
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.05),
                    DefaultTextStyle(
                      style: TextStyle(
                          fontSize: w > 385 ? 20 : 15,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      child: Text(
                        widget.teammate['username'],
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ]),
            ),
          ),
        )
      ],
    );
  }
}

void sendToServer1(
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
    'playerCount1': playerCount,
    'playerCount1Tot': playerCount,
    'team1_P$playerCount': selectedUser,
  });
}

void sendToServer2(
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
    'playerCount2': playerCount,
    'playerCount2Tot': playerCount,
    'team2_P$playerCount': selectedUser,
  });
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
    'playerCount1': playerCount,
    'playerCount1Tot': playerCount,
    'team1_P$playerCount': selectedUser,
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
    'playerCount1': playerCount,
    'playerCount1Tot': playerCount,
    'team1_P$playerCount': selectedUser,
  });
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
    'playerCount2': playerCount,
    'playerCount2Tot': playerCount,
    'team2_P$playerCount': selectedUser,
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
    'playerCount2': playerCount,
    'playerCount2Tot': playerCount,
    'team2_P$playerCount': selectedUser,
  });
}
