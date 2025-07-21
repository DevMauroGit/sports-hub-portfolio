import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/models/friend_model.dart';
import 'package:sports_hub_ios/screen/football_results_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';

class FootballResultsPage extends StatefulWidget {
  const FootballResultsPage({
    super.key,
    required this.appointment,
    required this.create,
  });

  final Map appointment;
  final bool create;

  @override
  State<FootballResultsPage> createState() => _FootballResultsPageState();
}

class _FootballResultsPageState extends State<FootballResultsPage> {
  @override
  Widget build(BuildContext context) {
    List list1 = [];

    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    String email = FirebaseAuth.instance.currentUser!.email.toString();

    List allTeammate = [];
    List allTeammateData = [];

    // If the appointment contains total players, prepare the data
    if (widget.appointment['playerCount1Tot'] != null) {
      // Add team1 players (excluding guest)
      for (int i = 0; i < widget.appointment['playerCount1Tot']; i++) {
        if (widget.appointment['team1_P${i + 1}'] != 'ospite') {
          list1.add(widget.appointment['team1_P${i + 1}']);
        }
      }

      // Add team2 players (excluding guest)
      for (int i = 0; i < widget.appointment['playerCount2Tot']; i++) {
        if (widget.appointment['team2_P${i + 1}'] != 'ospite') {
          list1.add(widget.appointment['team2_P${i + 1}']);
        }
      }

      String address = widget.create ? 'football/Crea_Match' : 'football';

      // Clear and refill list1 (may be redundant)
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

      return PopScope(
        canPop: false,
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
                  print('Error loading data');
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
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.02),
                      // For each friend, fetch full user data from Firestore
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
                                print('Error loading data');
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (snapshot.hasData) {
                                final friend =
                                    snapshot.data!.docs.elementAt(0).data();
                                allTeammateData.add(friend);
                              }
                              return Container();
                            },
                          ),
                      // Pass all data to the results screen
                      FootballResultsScreen(
                        allTeammate: allTeammate,
                        allTeammateData: allTeammateData,
                        h: h,
                        w: w,
                        appointment: widget.appointment,
                        list1: list1,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    } else {
      // Appointment data not complete: fallback to Realtime DB

      String address = widget.create ? 'football/Crea_Match' : 'football';
      Map appointmentData = {};

      // Fetch real-time updates from Firebase Realtime Database
      FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: dbPrenotazioniURL,
      )
          .ref(
              'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/$address/${widget.appointment['dateURL']}')
          .onValue
          .listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map;
        appointmentData.assignAll(data);
      });

      counter1 = 0;

      // If no data is returned from the DB, use widget's appointment as fallback
      if (appointmentData.isEmpty) {
        appointmentData.assignAll(widget.appointment);
        print('empty');
        print(appointmentData);
      }

      // Slight delay before navigation to ensure data is loaded
      Future.delayed(const Duration(milliseconds: 500), () {
        appointmentData.isEmpty
            ? appointmentData = widget.appointment
            : appointmentData = appointmentData;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FootballResultsPage(
              appointment: appointmentData,
              create: false,
            ),
          ),
        );
      });
    }

    // Fallback loading screen while waiting for data
    return const LoadingScreen();
  }
}
