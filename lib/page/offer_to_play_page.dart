import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/models/friend_model.dart';
import 'package:sports_hub_ios/screen/offer_to_play_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class OfferToPlay extends StatefulWidget {
  const OfferToPlay({
    super.key,
    required this.appointment,
    required this.h,
    required this.w,
  });

  final Map appointment;
  final double h;
  final double w;

  @override
  State<OfferToPlay> createState() => _OfferToPlayState();
}

class _OfferToPlayState extends State<OfferToPlay> {
  get allTeammate => null;

  @override
  Widget build(BuildContext context) {
    List list1 = [];

    String email = FirebaseAuth.instance.currentUser!.email.toString();

    List allTeammate = [];
    List allTeammateData = [];

    Map appointmentData = {};

    //List list1 = [];

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
            'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/football/Crea_Match/${widget.appointment['dateURL']}')
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map;

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

      for (int i = 0; i < widget.appointment['candidatiTot']; i++) {
        if (widget.appointment['candidati'][i] != 'ospite') {
          list1.add(widget.appointment['candidati'][i]);
        }
      }

      appointmentData.assignAll(data);
    });

    return PopScope(
        canPop: true,
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.2)),
            child: Scaffold(
              appBar: TopBar(),
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
                      //print('carousel has data');
                    }

                    return SingleChildScrollView(
                        child: Column(children: [
                      SizedBox(height: widget.h * 0.02),
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
                      //widget.appointment['sport'] == 'football' ?
                      OfferToPlayScreen(
                        h: widget.h,
                        w: widget.w,
                        appointment: widget.appointment,
                        list1: list1,
                      )
                    ]));
                  }),
              //if(showFriends==true)

              //SizedBox(height: h*0.05),
            )));
  }
}
