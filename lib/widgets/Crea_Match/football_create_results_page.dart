import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/models/friend_model.dart';
import 'package:sports_hub_ios/screen/football_create_results_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';

class FootballCreateResultsPage extends StatefulWidget {
  const FootballCreateResultsPage({
    super.key,
    required this.appointment,
  });

  final Map appointment;

  @override
  State<FootballCreateResultsPage> createState() =>
      _FootballCreateResultsPageState();
}

class _FootballCreateResultsPageState extends State<FootballCreateResultsPage> {
  get allTeammate => null;

  @override
  Widget build(BuildContext context) {
    List list1 = [];

    final double h = MediaQuery.of(context).size.height; // Screen height
    final double w = MediaQuery.of(context).size.width;  // Screen width
    String email = FirebaseAuth.instance.currentUser!.email.toString();

    List allTeammate = [];       // List to store teammates (friends)
    List allTeammateData = [];   // List to store teammates' detailed data

    Map appointmentData = {};    // Map to hold appointment details

    // Check if total player count for team 1 is defined
    if (widget.appointment['playerCount1Tot'] != null) {
      // Collect players from team 1 who are not guests
      for (int i = 0; i < widget.appointment['playerCount1Tot']; i++) {
        if (widget.appointment['team1_P${i + 1}'] != 'ospite') {
          list1.add(widget.appointment['team1_P${i + 1}']);
        }
      }

      // Collect players from team 2 who are not guests
      for (int i = 0; i < widget.appointment['playerCount2Tot']; i++) {
        if (widget.appointment['team2_P${i + 1}'] != 'ospite') {
          list1.add(widget.appointment['team2_P${i + 1}']);
        }
      }

      // Listen for realtime updates from Firebase Realtime Database
      FirebaseDatabase.instanceFor(
              app: Firebase.app(), databaseURL: dbPrenotazioniURL)
          .ref(
              'Prenotazioni/${FirebaseAuth.instance.currentUser!.uid}/football/Crea_Match/${widget.appointment['dateURL']}')
          .onValue
          .listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map;

        list1.clear();

        // Refresh list1 with updated players from team 1
        for (int i = 0; i < widget.appointment['playerCount1Tot']; i++) {
          if (widget.appointment['team1_P${i + 1}'] != 'ospite') {
            list1.add(widget.appointment['team1_P${i + 1}']);
          }
        }

        // Refresh list1 with updated players from team 2
        for (int i = 0; i < widget.appointment['playerCount2Tot']; i++) {
          if (widget.appointment['team2_P${i + 1}'] != 'ospite') {
            list1.add(widget.appointment['team2_P${i + 1}']);
          }
        }

        // Update appointment data with latest from database
        appointmentData.assignAll(data);
      });

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
                        .where('isRequested', isEqualTo: 'false') // Only accepted friends
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('Error loading data');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          margin: const EdgeInsets.all(kDefaultPadding),
                          child: const Center(
                            child: CircularProgressIndicator(), // Show loading spinner
                          ),
                        );
                      } else if (snapshot.hasData) {
                        // Convert query docs into FriendModel instances
                        final friendList = snapshot.data!.docs
                            .map((friends) => FriendModel.fromSnapshot(friends))
                            .toList();
                        allTeammate.assignAll(friendList);
                      }

                      return SingleChildScrollView(
                          child: Column(children: [
                        SizedBox(height: h * 0.02),
                        // For each teammate, fetch their detailed data asynchronously
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
                                    return Container(); // Show nothing while loading
                                  } else if (snapshot.hasData) {
                                    // Retrieve friend detailed data and add to list
                                    final friend =
                                        snapshot.data!.docs.elementAt(0).data();

                                    allTeammateData.add(friend);
                                  }

                                  return Container(); // Placeholder
                                }),
                        // Show football results screen with all data passed in
                        FootballCreateResultsScreen(
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
    } else {
      // If player count info is missing, fetch appointment data from Firebase Realtime Database
      Map appointmentData = {};
      String uid = FirebaseAuth.instance.currentUser!.uid.toString();

      FirebaseDatabase.instanceFor(
              app: Firebase.app(), databaseURL: dbPrenotazioniURL)
          .ref(
              'Prenotazioni/$uid/football/Crea_Match/${widget.appointment['dateURL']}')
          .onValue
          .listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map;
        appointmentData.assignAll(data);
      });

      // After a short delay, check if data is empty and navigate accordingly
      Future.delayed(const Duration(milliseconds: 500), () {
        appointmentData.isEmpty
            ? appointmentData = widget.appointment
            : Container();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FootballCreateResultsPage(appointment: appointmentData)));
      });
    }
    // Show loading screen if no data is ready yet
    return const LoadingScreen();
  }
}
