import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/models/friend_model.dart';
import 'package:sports_hub_ios/screen/tennis_result_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class TennisResultsPage extends StatefulWidget {
  const TennisResultsPage({super.key, required this.appointment});

  final Map appointment;

  @override
  State<TennisResultsPage> createState() => _TennisResultsPageState();
}

class _TennisResultsPageState extends State<TennisResultsPage> {
  get allTeammate => null;

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    String email = FirebaseAuth.instance.currentUser!.email.toString();

    List allTeammate = [];
    List allTeammateData = [];

    Map appointmentData = {};

    List list1 = [];

    for (int i = 0; i < widget.appointment['playerCount1Tot']; i++) {
      if (widget.appointment['team1_P${i + 1}'] != 'ospite') {
        list1.add(widget.appointment['team1_P${i + 1}']);
      }
    }

    for (int i = 0; i < widget.appointment['playerCount2Tot']; i++) {
      if (widget.appointment['team2_P${i + 1}'] != 'ospite') {
        list1.add(widget.appointment['team2_P${i + 1}']);
      }
    }

    FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: dbPrenotazioniURL)
        .ref(
            'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/tennis/${widget.appointment['dateURL']}')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map;
      //print(data);

      list1.clear();

      for (int i = 0; i < widget.appointment['playerCount1Tot']; i++) {
        if (widget.appointment['team1_P${i + 1}'] != 'ospite') {
          list1.add(widget.appointment['team1_P${i + 1}']);
        }
      }

      for (int i = 0; i < widget.appointment['playerCount2Tot']; i++) {
        if (widget.appointment['team2_P${i + 1}'] != 'ospite') {
          list1.add(widget.appointment['team2_P${i + 1}']);
        }
      }

      appointmentData.assignAll(data);
    });

    return PopScope(
        canPop: false,
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.2)),
            child: Scaffold(
              appBar: TopBarGames(w),
              bottomNavigationBar: BottomBar(context),
              body: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('User')
                      .doc(email)
                      .collection('Friends')
                      .where('isRequested', isEqualTo: 'false')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print('errore caricamento dati');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        margin: const EdgeInsets.all(kDefaultPadding),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final friendList = snapshot.data!.docs
                          .map((friends) => FriendModel.fromSnapshot(friends))
                          .toList();

                      allTeammate.assignAll(friendList);
                    }

                    return SingleChildScrollView(
                        child: Column(children: [
                      SizedBox(height: h * 0.02),
                      for (int i = 0; i < allTeammate.length; i++)
                        if (allTeammate.isNotEmpty)
                          FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('User')
                                  .where('email',
                                      isEqualTo: '${allTeammate[i].email}')
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print('errore caricamento dati');
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                } else if (snapshot.hasData) {
                                  final friend =
                                      snapshot.data!.docs.elementAt(0).data();

                                  allTeammateData.add(friend);
                                }
                                return Container();
                              }),
                      TennisResultsScreen(
                        allTeammate: allTeammate,
                        allTeammateData: allTeammateData,
                        h: h,
                        w: w,
                        appointment: appointmentData,
                        list1: list1,
                      )
                    ]));
                  }),
            )));
  }
}
