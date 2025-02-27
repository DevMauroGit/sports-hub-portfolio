import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Friend/friend_card.dart';
import 'package:sports_hub_ios/widgets/Results_Games/change_card.dart';
import 'package:sports_hub_ios/widgets/Results_Games/teammate_card.dart';

class TeammateCarousel1 extends StatefulWidget {
  const TeammateCarousel1({
    super.key,
    required this.appointment,
    required this.allTeammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final List allTeammate;
  final String sport;

  final List list1;

  @override
  State<TeammateCarousel1> createState() => _TeammateCarousel1State();
}

class _TeammateCarousel1State extends State<TeammateCarousel1> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('friends: ${userController.allFriends}');

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
              aspectRatio: h > 800
                  ? 0.7
                  : h > 700
                      ? 0.65
                      : 0.7,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.allTeammate.length,
                itemBuilder: (
                  BuildContext context,
                  index,
                ) =>
                    TeammateCard1(
                  appointment: widget.appointment,
                  teammate: widget.allTeammate[index],
                  sport: widget.sport,
                  list1: widget.list1,
                ),
              ),
            ));
      },
      stream: null,
    );
  }
}

class TeammateCarousel2 extends StatefulWidget {
  const TeammateCarousel2({
    super.key,
    required this.appointment,
    required this.allTeammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final List allTeammate;

  final String sport;

  final List list1;

  @override
  State<TeammateCarousel2> createState() => _TeammateCarouselState();
}

class _TeammateCarouselState extends State<TeammateCarousel2> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('friends: ${userController.allFriends}');

        return Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
              aspectRatio: h > 800
                  ? 0.7
                  : h > 700
                      ? 0.65
                      : 0.7,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.allTeammate.length,
                itemBuilder: (
                  BuildContext context,
                  index,
                ) =>
                    TeammateCard2(
                  appointment: widget.appointment,
                  teammate: widget.allTeammate[index],
                  sport: widget.sport,
                  list1: widget.list1,
                ),
              ),
            ));
      },
      stream: null,
    );
  }
}

class TeammateCreateCarousel1 extends StatefulWidget {
  const TeammateCreateCarousel1({
    super.key,
    required this.appointment,
    required this.allTeammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final List allTeammate;
  final String sport;

  final List list1;

  @override
  State<TeammateCreateCarousel1> createState() =>
      _TeammateCreateCarousel1State();
}

class _TeammateCreateCarousel1State extends State<TeammateCreateCarousel1> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('friends: ${userController.allFriends}');

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
              aspectRatio: h > 800
                  ? 0.7
                  : h > 700
                      ? 0.65
                      : 0.7,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.allTeammate.length,
                itemBuilder: (
                  BuildContext context,
                  index,
                ) =>
                    TeammateCreateCard1(
                  appointment: widget.appointment,
                  teammate: widget.allTeammate[index],
                  sport: widget.sport,
                  list1: widget.list1,
                ),
              ),
            ));
      },
      stream: null,
    );
  }
}

class TeammateCreateCarousel2 extends StatefulWidget {
  const TeammateCreateCarousel2({
    super.key,
    required this.appointment,
    required this.allTeammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final List allTeammate;

  final String sport;

  final List list1;

  @override
  State<TeammateCreateCarousel2> createState() =>
      _TeammateCreateCarouselState();
}

class _TeammateCreateCarouselState extends State<TeammateCreateCarousel2> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('friends: ${userController.allFriends}');

        return Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
              aspectRatio: h > 800
                  ? 0.7
                  : h > 700
                      ? 0.65
                      : 0.7,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.allTeammate.length,
                itemBuilder: (
                  BuildContext context,
                  index,
                ) =>
                    TeammateCreateCard2(
                  appointment: widget.appointment,
                  teammate: widget.allTeammate[index],
                  sport: widget.sport,
                  list1: widget.list1,
                ),
              ),
            ));
      },
      stream: null,
    );
  }
}

class TeammateCandidatoCarousel extends StatefulWidget {
  const TeammateCandidatoCarousel({
    super.key,
    required this.appointment,
    required this.list1,
  });

  final Map appointment;
  final List list1;

  @override
  State<TeammateCandidatoCarousel> createState() =>
      _TeammateCandidatoCarouselState();
}

class _TeammateCandidatoCarouselState extends State<TeammateCandidatoCarousel> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('friends: ${userController.allFriends}');

        return Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
                aspectRatio: h > 800
                    ? 0.7
                    : h > 700
                        ? 0.65
                        : 0.7,
                child: SizedBox(
                    height: h * 0.6,
                    child: FirebaseAnimatedList(
                        query: FirebaseDatabase.instanceFor(
                                app: Firebase.app(),
                                databaseURL: dbPrenotazioniURL)
                            .ref()
                            .child('Prenotazioni')
                            .child(FirebaseAuth.instance.currentUser!.uid)
                            .child('football')
                            .child('Crea_Match')
                            .child(widget.appointment['dateURL'])
                            .child('candidati'),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          var candidati = snapshot.value;
                          String candidato = candidati.toString();

                          if (widget.appointment['sport'] == 'football') {
                            return FootballCandidateCard(
                              profile: candidato,
                              list1: widget.list1,
                              appointment: widget.appointment,
                            );
                          } else {
                            return Container();
                          }
                        }))));
      },
      stream: null,
    );
  }
}

class ChangeCarousel1 extends StatefulWidget {
  const ChangeCarousel1({
    super.key,
    required this.appointment,
    required this.allTeammate,
    required this.p,
    required this.sport,
    required this.ospite,
    required this.list1,
  });

  final Map appointment;
  final List allTeammate;
  final int p;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<ChangeCarousel1> createState() => _ChangeCarousel1State();
}

class _ChangeCarousel1State extends State<ChangeCarousel1> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('friends: ${userController.allFriends}');

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
              aspectRatio: h > 800
                  ? 0.7
                  : h > 700
                      ? 0.65
                      : 0.7,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.allTeammate.length,
                itemBuilder: (
                  BuildContext context,
                  index,
                ) =>
                    ChangeCard1(
                  appointment: widget.appointment,
                  teammate: widget.allTeammate[index],
                  p: widget.p,
                  sport: widget.sport,
                  ospite: widget.ospite,
                  list1: widget.list1,
                ),
              ),
            ));
      },
      stream: null,
    );
  }
}

class ChangeCarousel2 extends StatefulWidget {
  const ChangeCarousel2({
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
  final List teammate;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<ChangeCarousel2> createState() => _ChangeCarouselState();
}

class _ChangeCarouselState extends State<ChangeCarousel2> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('friends: ${userController.allFriends}');
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
              aspectRatio: h > 800
                  ? 0.7
                  : h > 700
                      ? 0.65
                      : 0.7,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.teammate.length,
                itemBuilder: (
                  BuildContext context,
                  index,
                ) =>
                    ChangeCard2(
                  appointment: widget.appointment,
                  p: widget.p,
                  teammate: widget.teammate[index],
                  sport: widget.sport,
                  ospite: widget.ospite,
                  list1: widget.list1,
                ),
              ),
            ));
      },
      stream: null,
    );
  }
}

class ChangeCreateCarousel1 extends StatefulWidget {
  const ChangeCreateCarousel1({
    super.key,
    required this.appointment,
    required this.allTeammate,
    required this.p,
    required this.sport,
    required this.ospite,
    required this.list1,
  });

  final Map appointment;
  final List allTeammate;
  final int p;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<ChangeCreateCarousel1> createState() => _ChangeCreateCarousel1State();
}

class _ChangeCreateCarousel1State extends State<ChangeCreateCarousel1> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('friends: ${userController.allFriends}');

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
              aspectRatio: h > 800
                  ? 0.7
                  : h > 700
                      ? 0.65
                      : 0.7,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.allTeammate.length,
                itemBuilder: (
                  BuildContext context,
                  index,
                ) =>
                    ChangeCreateCard1(
                  appointment: widget.appointment,
                  teammate: widget.allTeammate[index],
                  p: widget.p,
                  sport: widget.sport,
                  ospite: widget.ospite,
                  list1: widget.list1,
                ),
              ),
            ));
      },
      stream: null,
    );
  }
}

class ChangeCreateCarousel2 extends StatefulWidget {
  const ChangeCreateCarousel2({
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
  final List teammate;

  final String sport;

  final bool ospite;

  final List list1;

  @override
  State<ChangeCreateCarousel2> createState() => _ChangeCreateCarouselState();
}

class _ChangeCreateCarouselState extends State<ChangeCreateCarousel2> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('friends: ${userController.allFriends}');
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
              aspectRatio: h > 800
                  ? 0.7
                  : h > 700
                      ? 0.65
                      : 0.7,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.teammate.length,
                itemBuilder: (
                  BuildContext context,
                  index,
                ) =>
                    ChangeCreateCard2(
                  appointment: widget.appointment,
                  p: widget.p,
                  teammate: widget.teammate[index],
                  sport: widget.sport,
                  ospite: widget.ospite,
                  list1: widget.list1,
                ),
              ),
            ));
      },
      stream: null,
    );
  }
}
