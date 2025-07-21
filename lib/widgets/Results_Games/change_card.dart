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

class ChangeCard1 extends StatefulWidget {
  const ChangeCard1({
    super.key,
    required this.appointment,
    required this.teammate,
    required this.p,
    required this.sport,
    required this.ospite,
    required this.list1,
  });

  final Map appointment;
  final Map teammate;
  final int p;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<ChangeCard1> createState() => _ChangeCard1State();
}

class _ChangeCard1State extends State<ChangeCard1> {
  @override
  Widget build(BuildContext context) {
    List list1 = widget.list1;

    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Map appointmentData = {};

    int counter = widget.appointment['playerCount1'];
    if (widget.ospite == true) {
      counter++;
    }

    print('lista inizio: $list1');

    String address = '';

    widget.sport == 'football'
        ? widget.appointment['crea_match']
            ? address = 'football/Crea_Match'
            : address = 'football'
        : address = 'tennis';

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: kDefaultPadding),
          child: GestureDetector(
              onTap: () {

                if (list1.isEmpty) {
                  list1.add(widget.teammate['email']);
                  print('prima aggiunta');
                  FirebaseDatabase.instanceFor(
                          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                      .ref(
                          'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/$address}/${widget.appointment['dateURL']}')
                      .onValue
                      .listen((DatabaseEvent event) {
                    final data = event.snapshot.value as Map;

                    appointmentData.assignAll(data);
                  });

                  sendChangeToServer1(
                      uid,
                      utente,
                      widget.appointment['club'],
                      widget.appointment['campo'],
                      widget.appointment['day'],
                      widget.appointment['time'],
                      widget.appointment['month'],
                      counter,
                      widget.teammate['email'],
                      widget.p + 2,
                      widget.sport,
                      widget.appointment['crea_match']);
                }

                for (int i = 0; i < (list1.length); i++) {
                  if (widget.teammate['email'] != list1[i]) {
                    counter1 = counter1 + 1;
                  }
                }
                counter1 == list1.length
                    ? sendChangeToServer1(
                        uid,
                        utente,
                        widget.appointment['club'],
                        widget.appointment['campo'],
                        widget.appointment['day'],
                        widget.appointment['time'],
                        widget.appointment['month'],
                        counter,
                        widget.teammate['email'],
                        widget.p + 2,
                        widget.sport,
                        widget.appointment['crea_match'])
                    : Container();
                if (counter1 == list1.length) {
                  FirebaseDatabase.instanceFor(
                          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                      .ref(
                          'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/$address/${widget.appointment['dateURL']}')
                      .onValue
                      .listen((DatabaseEvent event) {
                    final data = event.snapshot.value as Map;
                    appointmentData.assignAll(data);
                  });
                }
                counter1 = 0;

                Future.delayed(const Duration(milliseconds: 355));

                if (appointmentData.isEmpty) {
                  appointmentData.assignAll(widget.appointment);
                }

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
              )),
        )
      ],
    );
  }
}

class ChangeCard2 extends StatefulWidget {
  const ChangeCard2({
    super.key,
    required this.appointment,
    required this.p,
    required this.teammate,
    required this.sport,
    required this.ospite,
    required this.list1,
  });

  final Map appointment;
  final int p;

  final Map teammate;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<ChangeCard2> createState() => _ChangeCardState();
}

class _ChangeCardState extends State<ChangeCard2> {
  @override
  Widget build(BuildContext context) {
    List list1 = widget.list1;

    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Map appointmentData = {};

    int counter = widget.appointment['playerCount2'];
    if (widget.ospite == true) {
      counter++;
    }

    String address = '';

    widget.sport == 'football'
        ? widget.appointment['crea_match']
            ? address = 'football/Crea_Match'
            : address = 'football'
        : address = 'tennis';

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: kDefaultPadding),
          child: GestureDetector(
              onTap: () {
                if (list1.isEmpty) {
                  list1.add(widget.teammate['email']);
                  print('prima aggiunta');
                  FirebaseDatabase.instanceFor(
                          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                      .ref(
                          'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/$address/${widget.appointment['dateURL']}')
                      .onValue
                      .listen((DatabaseEvent event) {
                    final data = event.snapshot.value as Map;

                    appointmentData.assignAll(data);
                  });

                  sendChangeToServer2(
                      uid,
                      utente,
                      widget.appointment['club'],
                      widget.appointment['campo'],
                      widget.appointment['day'],
                      widget.appointment['time'],
                      widget.appointment['month'],
                      counter,
                      widget.teammate['email'],
                      widget.p + 1,
                      widget.sport,
                      widget.appointment['crea_match']);
                }

                for (int i = 0; i < (list1.length); i++) {
                  if (widget.teammate['email'] != list1[i]) {
                    counter1 = counter1 + 1;
                  }
                }
                if (counter1 == list1.length) {
                  sendChangeToServer2(
                      uid,
                      utente,
                      widget.appointment['club'],
                      widget.appointment['campo'],
                      widget.appointment['day'],
                      widget.appointment['time'],
                      widget.appointment['month'],
                      counter,
                      widget.teammate['email'],
                      widget.p + 1,
                      widget.sport,
                      widget.appointment['crea_match']);

                  FirebaseDatabase.instanceFor(
                          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                      .ref(
                          'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/$address/${widget.appointment['dateURL']}')
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

                appointmentData.isEmpty
                    ? appointmentData = widget.appointment
                    : Container();
                if (widget.sport == 'football') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FootballResultsPage(
                                appointment: appointmentData,
                                create: widget.appointment['crea_match'],
                              )));
                }
                if (widget.sport == 'tennis') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TennisResultsPage(appointment: appointmentData)));
                }
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
              )),
        )
      ],
    );
  }
}

class ChangeCreateCard1 extends StatefulWidget {
  const ChangeCreateCard1({
    super.key,
    required this.appointment,
    required this.teammate,
    required this.p,
    required this.sport,
    required this.ospite,
    required this.list1,
  });

  final Map appointment;
  final Map teammate;
  final int p;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<ChangeCreateCard1> createState() => _ChangeCreateCard1State();
}

class _ChangeCreateCard1State extends State<ChangeCreateCard1> {
  @override
  Widget build(BuildContext context) {
    List list1 = widget.list1;

    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Map appointmentData = {};

    int counter = widget.appointment['playerCount1'];
    if (widget.ospite == true) {
      counter++;
    }

    print('lista inizio: $list1');

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: kDefaultPadding),
          child: GestureDetector(
              onTap: () {

                if (list1.isEmpty) {
                  list1.add(widget.teammate['email']);
                  print('prima aggiunta');
                  FirebaseDatabase.instanceFor(
                          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                      .ref(
                          'Prenotazioni/Crea_Match/${widget.appointment['city']}/${widget.sport}/${widget.appointment['dateURL']}')
                      .onValue
                      .listen((DatabaseEvent event) {
                    final data = event.snapshot.value as Map;
                    //print(data);

                    appointmentData.assignAll(data);
                  });

                  sendChangeToServer1Create(
                      uid,
                      utente,
                      widget.appointment['club'],
                      widget.appointment['campo'],
                      widget.appointment['day'],
                      widget.appointment['time'],
                      widget.appointment['month'],
                      counter,
                      widget.teammate['email'],
                      widget.p + 2,
                      widget.sport,
                      widget.appointment['city']);
                }

                for (int i = 0; i < (list1.length); i++) {
                  if (widget.teammate['email'] != list1[i]) {
                    counter1 = counter1 + 1;
                  }
                }
                counter1 == list1.length
                    ? sendChangeToServer1Create(
                        uid,
                        utente,
                        widget.appointment['club'],
                        widget.appointment['campo'],
                        widget.appointment['day'],
                        widget.appointment['time'],
                        widget.appointment['month'],
                        counter,
                        widget.teammate['email'],
                        widget.p + 2,
                        widget.sport,
                        widget.appointment['city'])
                    : Container();
                if (counter1 == list1.length) {
                  FirebaseDatabase.instanceFor(
                          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                      .ref(
                          'Prenotazioni/Crea_Match/${widget.appointment['city']}/${widget.sport}/${widget.appointment['dateURL']}')
                      .onValue
                      .listen((DatabaseEvent event) {
                    final data = event.snapshot.value as Map;
                    appointmentData.assignAll(data);
                  });
                }
                counter1 = 0;

                Future.delayed(const Duration(milliseconds: 355));

                if (appointmentData.isEmpty) {
                  appointmentData.assignAll(widget.appointment);
                }

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
              )),
        )
      ],
    );
  }
}

class ChangeCreateCard2 extends StatefulWidget {
  const ChangeCreateCard2({
    super.key,
    required this.appointment,
    required this.p,
    required this.teammate,
    required this.sport,
    required this.ospite,
    required this.list1,
  });

  final Map appointment;
  final int p;

  final Map teammate;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<ChangeCreateCard2> createState() => _ChangeCreateCardState();
}

class _ChangeCreateCardState extends State<ChangeCreateCard2> {
  @override
  Widget build(BuildContext context) {
    List list1 = widget.list1;

    String utente = FirebaseAuth.instance.currentUser!.email.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Map appointmentData = {};

    int counter = widget.appointment['playerCount2'];
    if (widget.ospite == true) {
      counter++;
    }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: kDefaultPadding),
          child: GestureDetector(
              onTap: () {
                if (list1.isEmpty) {
                  list1.add(widget.teammate['email']);
                  print('prima aggiunta');
                  FirebaseDatabase.instanceFor(
                          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                      .ref(
                          'Prenotazioni/Crea_Match/${widget.appointment['city']}/${widget.sport}/${widget.appointment['dateURL']}')
                      .onValue
                      .listen((DatabaseEvent event) {
                    final data = event.snapshot.value as Map;

                    appointmentData.assignAll(data);
                  });

                  sendChangeToServer2Create(
                      uid,
                      utente,
                      widget.appointment['club'],
                      widget.appointment['campo'],
                      widget.appointment['day'],
                      widget.appointment['time'],
                      widget.appointment['month'],
                      counter,
                      widget.teammate['email'],
                      widget.p + 1,
                      widget.sport,
                      widget.appointment['city']);
                }

                for (int i = 0; i < (list1.length); i++) {
                  if (widget.teammate['email'] != list1[i]) {
                    counter1 = counter1 + 1;
                  }
                }
                if (counter1 == list1.length) {
                  sendChangeToServer2Create(
                      uid,
                      utente,
                      widget.appointment['club'],
                      widget.appointment['campo'],
                      widget.appointment['day'],
                      widget.appointment['time'],
                      widget.appointment['month'],
                      counter,
                      widget.teammate['email'],
                      widget.p + 1,
                      widget.sport,
                      widget.appointment['city']);

                  FirebaseDatabase.instanceFor(
                          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
                      .ref(
                          'Prenotazioni/Crea_Match/${widget.appointment['city']}/${widget.sport}/${widget.appointment['dateURL']}')
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
                            //errorWidget: (context, url, error) => Image.asset("assets/images/arena.jpg")
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.05),
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
              )),
        )
      ],
    );
  }
}

void sendChangeToServer1(
    String id,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    int playerCount,
    String selectedUser,
    int p,
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
    'team1_P$p': selectedUser,
  });
}

void sendChangeToServer2(
    String id,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    int playerCount,
    String selectedUser,
    int p,
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
    'team2_P$p': selectedUser,
  });
}

void sendChangeToServer1Create(
    String id,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    int playerCount,
    String selectedUser,
    int p,
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
    'team1_P$p': selectedUser,
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
    //'playerCount1Tot': playerCount,
    'team1_P$p': selectedUser,
  });
}

void sendChangeToServer2Create(
    String id,
    String email,
    String club,
    String campo,
    String day,
    String time,
    String month,
    int playerCount,
    String selectedUser,
    int p,
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
    'team2_P$p': selectedUser,
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
    'team2_P$p': selectedUser,
  });
}
