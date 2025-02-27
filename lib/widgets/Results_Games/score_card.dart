import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/screen/football_results_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Results_Games/change_popup.dart';

class ScoreCard extends StatefulWidget {
  const ScoreCard({
    super.key,
    required this.user,
    required this.player,
    required this.p,
    required this.date,
    required this.appointment,
    required this.allTeammateData,
    required this.list1,
  });

  final String user;
  final int player;
  final int p;
  final String date;
  final Map appointment;

  final List allTeammateData;

  final List list1;

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    bool ospite = false;
    if (widget.user == 'ospite') {
      ospite = true;
    }

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: w > 605 ? h * 0.13 : h * 0.1,
                          width: w > 385 ? w * 0.20 : w * 0.22,
                          child: Column(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: profile['profile_pic'],
                                  imageBuilder: (context, imageProvider) =>
                                      Image(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                    width: w > 605 ? w * 0.14 : w * 0.12,
                                    height: w > 605 ? h * 0.08 : h * 0.055,
                                  ),
                                ),
                              ),
                              Text(
                                profile['username'],
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontSize: w > 385
                                        ? profile['username'].length > 10
                                            ? 9
                                            : profile['username'].length > 8
                                                ? 10
                                                : profile['username'].length > 6
                                                    ? 12
                                                    : 14
                                        : profile['username'].length > 10
                                            ? 7
                                            : profile['username'].length > 8
                                                ? 8
                                                : profile['username'].length > 5
                                                    ? 10
                                                    : 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Column(children: [
                          SizedBox(
                            height: h > 700 ? h * 0.02 : h * 0.03,
                            width: h * 0.03,
                            //color: Colors.red,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            horizontal: h * 0.01)),
                                    alignment: Alignment.topCenter,
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                onPressed: () async {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.of(context).push(
                                        HeroDialogRoute(builder: (context) {
                                      return PopUpChange2(
                                        appointment: widget.appointment,
                                        p: widget.p,
                                        teammate: widget.allTeammateData,
                                        h: h,
                                        w: w,
                                        sport: 'football',
                                        ospite: ospite,
                                        list1: widget.list1,
                                      );
                                    }));
                                  });
                                },
                                child: Text(
                                  'X',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w > 605
                                        ? 18
                                        : w > 385
                                            ? 12
                                            : 8,
                                  ),
                                )),
                          ),
                          SizedBox(height: h * 0.01),
                          Container(
                              //margin: EdgeInsets.only(top: h*0.02),
                              alignment: Alignment.topCenter,
                              child: Row(
                                children: [
                                  Container(
                                    height: h > 700 ? h * 0.02 : h * 0.03,
                                    width: w * 0.05,
                                    color: kPrimaryColor,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (goalsCounter != 0) {
                                            goalsCounter = goalsCounter - 1;
                                            totTeam2 = totTeam2 - 1;
                                            print('tot: $totTeam2');
                                            if (widget.player == 0) {
                                              if (t2p1 != 0) {
                                                t2p1 = t2p1 - 1;
                                              }
                                            } else if (widget.player == 1) {
                                              if (t2p2 != 0) {
                                                t2p2 = t2p2 - 1;
                                              }
                                            } else if (widget.player == 2) {
                                              if (t2p3 != 0) {
                                                t2p3 = t2p3 - 1;
                                              }
                                            } else if (widget.player == 3) {
                                              if (t2p4 != 0) {
                                                t2p4 = t2p4 - 1;
                                              }
                                            }
                                          }
                                        });
                                      },
                                      child: Text(
                                        '-1',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w > 605
                                              ? 18
                                              : w > 385
                                                  ? 12
                                                  : 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: h > 700 ? h * 0.02 : h * 0.03,
                                    width: w * 0.04,
                                    color: Colors.white,
                                    child: Text(
                                      goalsCounter.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: w > 605
                                              ? 18
                                              : w > 385
                                                  ? 12
                                                  : 10,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: h > 700 ? h * 0.02 : h * 0.03,
                                    width: w * 0.05,
                                    color: kPrimaryColor,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (goalsCounter < 9) {
                                            goalsCounter = goalsCounter + 1;
                                            totTeam2 = totTeam2 + 1;
                                            if (widget.player == 0) {
                                              t2p1 = t2p1 + 1;
                                            } else if (widget.player == 1) {
                                              t2p2 = t2p2 + 1;
                                            } else if (widget.player == 2) {
                                              t2p3 = t2p3 + 1;
                                            } else if (widget.player == 3) {
                                              t2p4 = t2p4 + 1;
                                            }
                                          }
                                        });
                                        print(goalsCounter);
                                      },
                                      child: Text(
                                        '+1',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w > 605
                                              ? 18
                                              : w > 385
                                                  ? 12
                                                  : 10,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ))
                        ]),
                      ],
                    )
                  ]);
                }
                return Container();
              }))))
    ]);
  }
}

class ScoreCard1 extends StatefulWidget {
  const ScoreCard1({
    super.key,
    required this.user,
    required this.player,
    required this.p,
    required this.date,
    required this.appointment,
    required this.allTeammateData,
    required this.list1,
  });

  final String user;
  final int player;
  final int p;
  final String date;
  final Map appointment;

  final List allTeammateData;

  final List list1;

  @override
  State<ScoreCard1> createState() => _ScoreCard1State();
}

class _ScoreCard1State extends State<ScoreCard1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    bool ospite = false;
    if (widget.user == 'ospite') {
      ospite = true;
    }

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  //if(databaseRef.child('Prenotazioni').child(profile['id']).child(profile['dateURL']).child('team1P${widget.p+2}') == ''){
                  //  return Container();
                  // }
                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385
                                            ? profile['username'].length > 8
                                                ? 10
                                                : profile['username'].length > 6
                                                    ? 12
                                                    : 14
                                            : profile['username'].length > 8
                                                ? 7
                                                : profile['username'].length > 5
                                                    ? 9
                                                    : 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: h > 700 ? h * 0.02 : h * 0.03,
                                  width: h * 0.03,
                                  //color: Colors.red,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: h * 0.01)),
                                          alignment: Alignment.topCenter,
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red)),
                                      onPressed: () {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          Navigator.of(context).push(
                                              HeroDialogRoute(
                                                  builder: (context) {
                                            return PopUpChange1(
                                                appointment: widget.appointment,
                                                teammate:
                                                    widget.allTeammateData,
                                                h: h,
                                                w: w,
                                                p: widget.p,
                                                sport: 'football',
                                                ospite: ospite,
                                                list1: widget.list1);
                                          }));
                                        });
                                      },
                                      child: Text(
                                        'X',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w > 605
                                                ? 18
                                                : w > 385
                                                    ? 12
                                                    : 8),
                                      )),
                                ),
                                SizedBox(height: h * 0.01),
                                Container(
                                    //margin: EdgeInsets.only(top: h*0.02),
                                    alignment: Alignment.topCenter,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: h > 700 ? h * 0.02 : h * 0.03,
                                          width: w * 0.05,
                                          color: kPrimaryColor,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (goalsCounter != 0) {
                                                  goalsCounter =
                                                      goalsCounter - 1;
                                                  totTeam1 = totTeam1 - 1;
                                                  print('tot: $totTeam2');
                                                  if (widget.player == 0) {
                                                    t1p2 = t1p2 - 1;
                                                  } else if (widget.player ==
                                                      1) {
                                                    t1p3 = t1p3 - 1;
                                                  } else if (widget.player ==
                                                      2) {
                                                    t1p4 = t1p4 - 1;
                                                  }
                                                } else if (widget.player == 3) {
                                                  t1p5 = t1p5 - 1;
                                                }
                                              });
                                            },
                                            child: Text(
                                              '-1',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w > 605
                                              ? 18
                                              : w > 385
                                                  ? 12
                                                  : 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: h > 700 ? h * 0.02 : h * 0.03,
                                          width: w * 0.04,
                                          color: Colors.white,
                                          child: Text(
                                            goalsCounter.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w > 605
                                                  ? 18
                                                  : w > 385
                                                      ? 14
                                                      : 10,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: h > 700 ? h * 0.02 : h * 0.03,
                                          width: w * 0.05,
                                          color: kPrimaryColor,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (goalsCounter < 9) {
                                                  goalsCounter =
                                                      goalsCounter + 1;
                                                  totTeam1 = totTeam1 + 1;
                                                  if (widget.player == 0) {
                                                    t1p2 = t1p2 + 1;
                                                  } else if (widget.player ==
                                                      1) {
                                                    t1p3 = t1p3 + 1;
                                                  } else if (widget.player ==
                                                      2) {
                                                    t1p4 = t1p4 + 1;
                                                  } else if (widget.player ==
                                                      3) {
                                                    t1p5 = t1p5 + 1;
                                                  }
                                                }
                                              });
                                            },
                                            child: Text(
                                              '+1',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w > 605
                                              ? 18
                                              : w > 385
                                                  ? 12
                                                  : 10,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            )
                          ])
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class ScoreCardP1 extends StatefulWidget {
  const ScoreCardP1({
    super.key,
    required this.user,
    required this.team,
  });

  final String user;
  final int team;

  @override
  State<ScoreCardP1> createState() => _ScoreCardP1State();
}

class _ScoreCardP1State extends State<ScoreCardP1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385
                                            ? profile['username'].length > 8
                                                ? 10
                                                : profile['username'].length > 6
                                                    ? 12
                                                    : 14
                                            : profile['username'].length > 8
                                                ? 9
                                                : profile['username'].length > 5
                                                    ? 11
                                                    : 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                //margin: EdgeInsets.only(top: h*0.02),
                                alignment: Alignment.topCenter,
                                child: Row(
                                  children: [
                                    Container(
                                      height: h > 700 ? h * 0.02 : h * 0.03,
                                      width: w * 0.05,
                                      color: kPrimaryColor,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (goalsCounter != 0) {
                                              goalsCounter = goalsCounter - 1;
                                              totTeam1 = totTeam1 - 1;
                                              if (widget.team == 1) {
                                                t1p1 = t1p1 - 1;
                                              }
                                              if (widget.team == 2) {
                                                t1p2 = t1p2 - 1;
                                              }
                                              if (widget.team == 3) {
                                                t1p3 = t1p3 - 1;
                                              }
                                              if (widget.team == 4) {
                                                t1p4 = t1p4 - 1;
                                              }
                                            }
                                          });
                                        },
                                        child: Text(
                                          '-1',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: w > 605
                                                ? 18
                                                : w > 385
                                                    ? 12
                                                    : 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: h > 700 ? h * 0.02 : h * 0.03,
                                      width: w * 0.04,
                                      color: Colors.white,
                                      child: Text(
                                        goalsCounter.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w > 605
                                              ? 18
                                              : w > 385
                                                  ? 12
                                                  : 10,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: h > 700 ? h * 0.02 : h * 0.03,
                                      width: w * 0.05,
                                      color: kPrimaryColor,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (goalsCounter < 9) {
                                              goalsCounter = goalsCounter + 1;
                                              totTeam1 = totTeam1 + 1;
                                              if (widget.team == 1) {
                                                t1p1 = t1p1 + 1;
                                              }
                                              if (widget.team == 2) {
                                                t1p2 = t1p2 + 1;
                                              }
                                              if (widget.team == 3) {
                                                t1p3 = t1p3 + 1;
                                              }
                                              if (widget.team == 4) {
                                                t1p4 = t1p4 + 1;
                                              }
                                            }
                                          });
                                          print(goalsCounter);
                                        },
                                        child: Text(
                                          '+1',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: w > 605
                                                ? 18
                                                : w > 385
                                                    ? 12
                                                    : 10,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                          ]),
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class ScoreCardOspite extends StatefulWidget {
  const ScoreCardOspite({
    super.key,
    required this.user,
    required this.team,
  });

  final String user;
  final int team;

  @override
  State<ScoreCardOspite> createState() => _ScoreCardOspiteState();
}

class _ScoreCardOspiteState extends State<ScoreCardOspite> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385 ? 14 : 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                //margin: EdgeInsets.only(top: h*0.02),
                                alignment: Alignment.topCenter,
                                child: Row(
                                  children: [
                                    Container(
                                      height: h > 700 ? h * 0.02 : h * 0.03,
                                      width: w * 0.05,
                                      color: kPrimaryColor,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (widget.team == 1) {
                                              if (goalsCounter != 0) {
                                                goalsCounter = goalsCounter - 1;
                                                totTeam1 = totTeam1 - 1;
                                              }
                                            } else if (widget.team == 2) {
                                              if (goalsCounter != 0) {
                                                goalsCounter = goalsCounter - 1;
                                                totTeam2 = totTeam2 - 1;
                                              }
                                            }
                                          });
                                        },
                                        child: Text(
                                          '-1',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: w > 605
                                                ? 18
                                                : w > 385
                                                    ? 12
                                                    : 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: h > 700 ? h * 0.02 : h * 0.03,
                                      width: w * 0.04,
                                      color: Colors.white,
                                      child: Text(
                                        goalsCounter.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w > 605
                                              ? 18
                                              : w > 385
                                                  ? 12
                                                  : 10,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: h > 700 ? h * 0.02 : h * 0.03,
                                      width: w * 0.05,
                                      color: kPrimaryColor,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (widget.team == 1) {
                                              if (goalsCounter < 9) {
                                                goalsCounter = goalsCounter + 1;
                                                totTeam1 = totTeam1 + 1;
                                              }
                                            } else if (widget.team == 2) {
                                              if (goalsCounter < 9) {
                                                goalsCounter = goalsCounter + 1;
                                                totTeam2 = totTeam2 + 1;
                                              }
                                            }
                                          });
                                          print(goalsCounter);
                                        },
                                        child: Text(
                                          '+1',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: w > 605
                                                ? 18
                                                : w > 385
                                                    ? 12
                                                    : 10,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                          ]),
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class TennisScoreCardP1 extends StatefulWidget {
  const TennisScoreCardP1({
    super.key,
    required this.user,
    required this.team,
  });

  final String user;
  final int team;

  @override
  State<TennisScoreCardP1> createState() => _TennisScoreCardP1State();
}

class _TennisScoreCardP1State extends State<TennisScoreCardP1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.1 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: Column(children: [
            FutureBuilder<DocumentSnapshot>(
                future: users.doc(widget.user).get(),
                builder: (((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> profile =
                        snapshot.data!.data() as Map<String, dynamic>;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profile['profile_pic'],
                            imageBuilder: (context, imageProvider) => Image(
                              image: imageProvider,
                              fit: BoxFit.fill,
                              width: w > 605 ? w * 0.14 : w * 0.12,
                              height: w > 605 ? h * 0.08 : h * 0.055,
                            ),
                          ),
                        ),
                        SizedBox(width: w > 605 ? 20 : w * 0.01),
                        SizedBox(
                          child: Text(
                            profile['username'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: w > 385
                                    ? profile['username'].length > 8
                                        ? 10
                                        : profile['username'].length > 6
                                            ? 12
                                            : 14
                                    : profile['username'].length > 8
                                        ? 9
                                        : profile['username'].length > 5
                                            ? 11
                                            : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                }))),
          ]))
    ]);
  }
}

class TennisScoreCard1 extends StatefulWidget {
  const TennisScoreCard1({
    super.key,
    required this.user,
    required this.player,
    required this.p,
    required this.date,
    required this.appointment,
    required this.allTeammateData,
    required this.list1,
  });

  final String user;
  final int player;
  final int p;
  final String date;
  final Map appointment;

  final List allTeammateData;

  final List list1;

  @override
  State<TennisScoreCard1> createState() => _TennisScoreCard1State();
}

class _TennisScoreCard1State extends State<TennisScoreCard1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    bool ospite = false;
    if (widget.user == 'ospite') {
      ospite = true;
    }

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w * 0.7,
          color: kBackgroundColor2,
          child: Row(children: [
            Column(children: [
              FutureBuilder<DocumentSnapshot>(
                  future: users.doc(widget.user).get(),
                  builder: (((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> profile =
                          snapshot.data!.data() as Map<String, dynamic>;

                      //if(databaseRef.child('Prenotazioni').child(profile['id']).child(profile['dateURL']).child('team1P${widget.p+2}') == ''){
                      //  return Container();
                      // }
                      return Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: w > 605 ? h * 0.13 : h * 0.1,
                                  width: w * 0.20,
                                  child: Column(
                                    children: [
                                      ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: profile['profile_pic'],
                                          imageBuilder:
                                              (context, imageProvider) => Image(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                            width:
                                                w > 605 ? w * 0.14 : w * 0.12,
                                            height:
                                                w > 605 ? h * 0.08 : h * 0.055,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        profile['username'],
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            fontSize: w > 385
                                                ? profile['username'].length > 8
                                                    ? 10
                                                    : profile['username']
                                                                .length >
                                                            6
                                                        ? 12
                                                        : 14
                                                : profile['username'].length > 8
                                                    ? 9
                                                    : profile['username']
                                                                .length >
                                                            5
                                                        ? 11
                                                        : 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: h > 700 ? h * 0.02 : h * 0.03,
                                      width: h * 0.03,
                                      //color: Colors.red,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.symmetric(
                                                          horizontal:
                                                              h * 0.01)),
                                              alignment: Alignment.topCenter,
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
                                          onPressed: () async {
                                            Navigator.of(context).push(
                                                HeroDialogRoute(
                                                    builder: (context) {
                                              return PopUpChange1(
                                                  appointment:
                                                      widget.appointment,
                                                  teammate:
                                                      widget.allTeammateData,
                                                  h: h,
                                                  w: w,
                                                  p: widget.p,
                                                  sport: 'tennis',
                                                  ospite: ospite,
                                                  list1: widget.list1);
                                            }));
                                          },
                                          child: Text(
                                            'X',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: w > 605
                                                    ? 18
                                                    : w > 385
                                                        ? 12
                                                        : 8),
                                          )),
                                    ),
                                  ],
                                )
                              ])
                        ],
                      );
                    }
                    return Container();
                  }))),
            ])
          ]))
    ]);
  }
}

class TennisScoreCard2 extends StatefulWidget {
  const TennisScoreCard2({
    super.key,
    required this.user,
    required this.player,
    required this.p,
    required this.date,
    required this.appointment,
    required this.allTeammateData,
    required this.list1,
  });

  final String user;
  final int player;
  final int p;
  final String date;
  final Map appointment;

  final List allTeammateData;

  final List list1;

  @override
  State<TennisScoreCard2> createState() => _TennisScoreCard2State();
}

class _TennisScoreCard2State extends State<TennisScoreCard2> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    bool ospite = false;
    if (widget.user == 'ospite') {
      ospite = true;
    }

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w * 0.7,
          color: kBackgroundColor2,
          child: Row(children: [
            Container(
                child: Column(children: [
              FutureBuilder<DocumentSnapshot>(
                  future: users.doc(widget.user).get(),
                  builder: (((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> profile =
                          snapshot.data!.data() as Map<String, dynamic>;

                      //if(databaseRef.child('Prenotazioni').child(profile['id']).child(profile['dateURL']).child('team1P${widget.p+2}') == ''){
                      //  return Container();
                      // }

                      return Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: w > 605 ? h * 0.13 : h * 0.1,
                                  width: w * 0.20,
                                  child: Column(
                                    children: [
                                      ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: profile['profile_pic'],
                                          imageBuilder:
                                              (context, imageProvider) => Image(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                            width:
                                                w > 605 ? w * 0.14 : w * 0.12,
                                            height:
                                                w > 605 ? h * 0.08 : h * 0.055,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        profile['username'],
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            fontSize: w > 385
                                                ? profile['username'].length > 8
                                                    ? 10
                                                    : profile['username']
                                                                .length >
                                                            6
                                                        ? 12
                                                        : 14
                                                : profile['username'].length > 8
                                                    ? 9
                                                    : profile['username']
                                                                .length >
                                                            5
                                                        ? 11
                                                        : 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: h > 700 ? h * 0.02 : h * 0.03,
                                      width: h * 0.03,
                                      //color: Colors.red,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.symmetric(
                                                          horizontal:
                                                              h * 0.01)),
                                              alignment: Alignment.topCenter,
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
                                          onPressed: () async {
                                            Navigator.of(context).push(
                                                HeroDialogRoute(
                                                    builder: (context) {
                                              return PopUpChange2(
                                                appointment: widget.appointment,
                                                teammate:
                                                    widget.allTeammateData,
                                                h: h,
                                                w: w,
                                                p: widget.p,
                                                sport: 'tennis',
                                                ospite: ospite,
                                                list1: widget.list1,
                                              );
                                            }));
                                          },
                                          child: Text(
                                            'X',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: w > 605
                                                    ? 18
                                                    : w > 385
                                                        ? 12
                                                        : 8),
                                          )),
                                    ),
                                  ],
                                )
                              ])
                        ],
                      );
                    }
                    return Container();
                  }))),
            ]))
          ]))
    ]);
  }
}

class ScoreCreateCard extends StatefulWidget {
  const ScoreCreateCard({
    super.key,
    required this.user,
    required this.player,
    required this.p,
    required this.date,
    required this.appointment,
    required this.allTeammateData,
    required this.list1,
  });

  final String user;
  final int player;
  final int p;
  final String date;
  final Map appointment;

  final List allTeammateData;

  final List list1;

  @override
  State<ScoreCreateCard> createState() => _ScoreCreateCardState();
}

class _ScoreCreateCardState extends State<ScoreCreateCard> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    bool ospite = false;
    if (widget.user == 'ospite') {
      ospite = true;
    }

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: w > 605 ? h * 0.13 : h * 0.1,
                          width: w > 385 ? w * 0.20 : w * 0.22,
                          child: Column(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: profile['profile_pic'],
                                  imageBuilder: (context, imageProvider) =>
                                      Image(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                    width: w > 605 ? w * 0.14 : w * 0.12,
                                    height: w > 605 ? h * 0.08 : h * 0.055,
                                  ),
                                ),
                              ),
                              Text(
                                profile['username'],
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontSize: w > 385
                                        ? profile['username'].length > 10
                                            ? 9
                                            : profile['username'].length > 8
                                                ? 10
                                                : profile['username'].length > 6
                                                    ? 12
                                                    : 14
                                        : profile['username'].length > 10
                                            ? 7
                                            : profile['username'].length > 8
                                                ? 8
                                                : profile['username'].length > 5
                                                    ? 10
                                                    : 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Column(children: [
                          SizedBox(
                            height: h > 700 ? h * 0.02 : h * 0.03,
                            width: h * 0.03,
                            //color: Colors.red,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            horizontal: h * 0.01)),
                                    alignment: Alignment.topCenter,
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                onPressed: () async {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.of(context).push(
                                        HeroDialogRoute(builder: (context) {
                                      return PopUpCreateChange2(
                                        appointment: widget.appointment,
                                        p: widget.p,
                                        teammate: widget.allTeammateData,
                                        h: h,
                                        w: w,
                                        sport: 'football',
                                        ospite: ospite,
                                        list1: widget.list1,
                                      );
                                    }));
                                  });
                                },
                                child: Text(
                                  'X',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w > 605
                                        ? 18
                                        : w > 385
                                            ? 12
                                            : 8,
                                  ),
                                )),
                          ),
                          Text(
                            'P: ${profile['games']}',
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: w > 385 ? 10 : 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'G: ${profile['goals']}',
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: w > 385 ? 10 : 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'W: ${profile['win']}',
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: w > 385 ? 10 : 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ]),
                      ],
                    )
                  ]);
                }
                return Container();
              }))))
    ]);
  }
}

class ScoreCreateCard1 extends StatefulWidget {
  const ScoreCreateCard1({
    super.key,
    required this.user,
    required this.player,
    required this.p,
    required this.date,
    required this.appointment,
    required this.allTeammateData,
    required this.list1,
  });

  final String user;
  final int player;
  final int p;
  final String date;
  final Map appointment;

  final List allTeammateData;

  final List list1;

  @override
  State<ScoreCreateCard1> createState() => _ScoreCreateCard1State();
}

class _ScoreCreateCard1State extends State<ScoreCreateCard1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    bool ospite = false;
    if (widget.user == 'ospite') {
      ospite = true;
    }

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  //if(databaseRef.child('Prenotazioni').child(profile['id']).child(profile['dateURL']).child('team1P${widget.p+2}') == ''){
                  //  return Container();
                  // }
                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385
                                            ? profile['username'].length > 10
                                                ? 9
                                                : profile['username'].length > 8
                                                    ? 10
                                                    : profile['username']
                                                                .length >
                                                            6
                                                        ? 12
                                                        : 14
                                            : profile['username'].length > 10
                                                ? 7
                                                : profile['username'].length > 8
                                                    ? 8
                                                    : profile['username']
                                                                .length >
                                                            5
                                                        ? 10
                                                        : 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: h > 700 ? h * 0.02 : h * 0.03,
                                  width: h * 0.03,
                                  //color: Colors.red,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: h * 0.01)),
                                          alignment: Alignment.topCenter,
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red)),
                                      onPressed: () {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          Navigator.of(context).push(
                                              HeroDialogRoute(
                                                  builder: (context) {
                                            return PopUpCreateChange1(
                                                appointment: widget.appointment,
                                                teammate:
                                                    widget.allTeammateData,
                                                h: h,
                                                w: w,
                                                p: widget.p,
                                                sport: 'football',
                                                ospite: ospite,
                                                list1: widget.list1);
                                          }));
                                        });
                                      },
                                      child: Text(
                                        'X',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w > 605
                                                ? 16
                                                : w > 385
                                                    ? 10
                                                    : 8),
                                      )),
                                ),
                                Text(
                                  'P: ${profile['games']}',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 10 : 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'G: ${profile['goals']}',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 10 : 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'W: ${profile['win']}',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 10 : 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ])
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class ScoreCreateCardP1 extends StatefulWidget {
  const ScoreCreateCardP1({
    super.key,
    required this.user,
    required this.team,
  });

  final String user;
  final int team;

  @override
  State<ScoreCreateCardP1> createState() => _ScoreCreateCardP1State();
}

class _ScoreCreateCardP1State extends State<ScoreCreateCardP1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385
                                            ? profile['username'].length > 10
                                                ? 9
                                                : profile['username'].length > 8
                                                    ? 10
                                                    : profile['username']
                                                                .length >
                                                            6
                                                        ? 12
                                                        : 14
                                            : profile['username'].length > 10
                                                ? 6
                                                : profile['username'].length > 8
                                                    ? 7
                                                    : profile['username']
                                                                .length >
                                                            5
                                                        ? 9
                                                        : 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'P: ${profile['games']}',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 10 : 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'G: ${profile['goals']}',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 10 : 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'W: ${profile['win']}',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 10 : 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ]),
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class ScoreCreateCardOspite extends StatefulWidget {
  const ScoreCreateCardOspite({
    super.key,
    required this.user,
    required this.team,
  });

  final String user;
  final int team;

  @override
  State<ScoreCreateCardOspite> createState() => _ScoreCreateCardOspiteState();
}

class _ScoreCreateCardOspiteState extends State<ScoreCreateCardOspite> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385 ? 14 : 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class TennisCreateScoreCardP1 extends StatefulWidget {
  const TennisCreateScoreCardP1({
    super.key,
    required this.user,
    required this.team,
  });

  final String user;
  final int team;

  @override
  State<TennisCreateScoreCardP1> createState() =>
      _TennisCreateScoreCardP1State();
}

class _TennisCreateScoreCardP1State extends State<TennisCreateScoreCardP1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.1 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: profile['profile_pic'],
                          imageBuilder: (context, imageProvider) => Image(
                            image: imageProvider,
                            fit: BoxFit.fill,
                            width: w > 605 ? w * 0.14 : w * 0.12,
                            height: w > 605 ? h * 0.08 : h * 0.055,
                          ),
                        ),
                      ),
                      SizedBox(width: w > 605 ? 20 : w * 0.01),
                      SizedBox(
                        child: Text(
                          profile['username'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 2,
                              fontSize: w > 385
                                  ? profile['username'].length > 10
                                      ? 9
                                      : profile['username'].length > 8
                                          ? 10
                                          : profile['username'].length > 6
                                              ? 12
                                              : 14
                                  : profile['username'].length > 10
                                      ? 6
                                      : profile['username'].length > 8
                                          ? 7
                                          : profile['username'].length > 5
                                              ? 9
                                              : 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class TennisCreateScoreCard1 extends StatefulWidget {
  const TennisCreateScoreCard1({
    super.key,
    required this.user,
    required this.player,
    required this.p,
    required this.date,
    required this.appointment,
    required this.allTeammateData,
    required this.list1,
  });

  final String user;
  final int player;
  final int p;
  final String date;
  final Map appointment;

  final List allTeammateData;

  final List list1;

  @override
  State<TennisCreateScoreCard1> createState() => _TennisCreateScoreCard1State();
}

class _TennisCreateScoreCard1State extends State<TennisCreateScoreCard1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    bool ospite = false;
    if (widget.user == 'ospite') {
      ospite = true;
    }

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w * 0.7,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  //if(databaseRef.child('Prenotazioni').child(profile['id']).child(profile['dateURL']).child('team1P${widget.p+2}') == ''){
                  //  return Container();
                  // }
                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385
                                            ? profile['username'].length > 10
                                                ? 9
                                                : profile['username'].length > 8
                                                    ? 10
                                                    : profile['username']
                                                                .length >
                                                            6
                                                        ? 12
                                                        : 14
                                            : profile['username'].length > 10
                                                ? 6
                                                : profile['username'].length > 8
                                                    ? 7
                                                    : profile['username']
                                                                .length >
                                                            5
                                                        ? 9
                                                        : 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: h > 700 ? h * 0.02 : h * 0.03,
                                  width: h * 0.03,
                                  //color: Colors.red,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: h * 0.01)),
                                          alignment: Alignment.topCenter,
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red)),
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                            HeroDialogRoute(builder: (context) {
                                          return PopUpChange1(
                                              appointment: widget.appointment,
                                              teammate: widget.allTeammateData,
                                              h: h,
                                              w: w,
                                              p: widget.p,
                                              sport: 'tennis',
                                              ospite: ospite,
                                              list1: widget.list1);
                                        }));
                                      },
                                      child: Text(
                                        'X',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w > 605
                                                ? 18
                                                : w > 385
                                                    ? 12
                                                    : 8),
                                      )),
                                ),
                              ],
                            )
                          ])
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class TennisCreateScoreCard2 extends StatefulWidget {
  const TennisCreateScoreCard2({
    super.key,
    required this.user,
    required this.player,
    required this.p,
    required this.date,
    required this.appointment,
    required this.allTeammateData,
    required this.list1,
  });

  final String user;
  final int player;
  final int p;
  final String date;
  final Map appointment;

  final List allTeammateData;

  final List list1;

  @override
  State<TennisCreateScoreCard2> createState() => _TennisCreateScoreCard2State();
}

class _TennisCreateScoreCard2State extends State<TennisCreateScoreCard2> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    bool ospite = false;
    if (widget.user == 'ospite') {
      ospite = true;
    }

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w * 0.7,
          color: kBackgroundColor2,
          child: Column(children: [
            FutureBuilder<DocumentSnapshot>(
                future: users.doc(widget.user).get(),
                builder: (((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> profile =
                        snapshot.data!.data() as Map<String, dynamic>;

                    //if(databaseRef.child('Prenotazioni').child(profile['id']).child(profile['dateURL']).child('team1P${widget.p+2}') == ''){
                    //  return Container();
                    // }

                    return Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: w > 605 ? h * 0.13 : h * 0.1,
                                width: w > 385 ? w * 0.20 : w * 0.22,
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: profile['profile_pic'],
                                        imageBuilder:
                                            (context, imageProvider) => Image(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                          width: w > 605 ? w * 0.14 : w * 0.12,
                                          height:
                                              w > 605 ? h * 0.08 : h * 0.055,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      profile['username'],
                                      style: TextStyle(
                                          letterSpacing: 2,
                                          fontSize: w > 385
                                              ? profile['username'].length > 10
                                                  ? 9
                                                  : profile['username'].length >
                                                          8
                                                      ? 10
                                                      : profile['username']
                                                                  .length >
                                                              6
                                                          ? 12
                                                          : 14
                                              : profile['username'].length > 10
                                                  ? 7
                                                  : profile['username'].length >
                                                          8
                                                      ? 8
                                                      : profile['username']
                                                                  .length >
                                                              5
                                                          ? 10
                                                          : 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: h > 700 ? h * 0.02 : h * 0.03,
                                    width: h * 0.03,
                                    //color: Colors.red,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    horizontal: h * 0.01)),
                                            alignment: Alignment.topCenter,
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red)),
                                        onPressed: () async {
                                          Navigator.of(context).push(
                                              HeroDialogRoute(
                                                  builder: (context) {
                                            return PopUpChange2(
                                              appointment: widget.appointment,
                                              teammate: widget.allTeammateData,
                                              h: h,
                                              w: w,
                                              p: widget.p,
                                              sport: 'tennis',
                                              ospite: ospite,
                                              list1: widget.list1,
                                            );
                                          }));
                                        },
                                        child: Text(
                                          'X',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: w > 605
                                                  ? 18
                                                  : w > 385
                                                      ? 12
                                                      : 8),
                                        )),
                                  ),
                                ],
                              )
                            ])
                      ],
                    );
                  }
                  return Container();
                }))),
          ]))
    ]);
  }
}

class ScoreSearchCard extends StatefulWidget {
  const ScoreSearchCard({
    super.key,
    required this.user,
    required this.appointment,
  });

  final String user;
  final Map appointment;

  @override
  State<ScoreSearchCard> createState() => _ScoreSearchCardState();
}

class _ScoreSearchCardState extends State<ScoreSearchCard> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    //   bool ospite = false;
    //   if (widget.user == 'ospite') {
    //     ospite = true;
    //   }

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: w > 605 ? h * 0.13 : h * 0.1,
                          width: w > 385 ? w * 0.20 : w * 0.22,
                          child: Column(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: profile['profile_pic'],
                                  imageBuilder: (context, imageProvider) =>
                                      Image(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                    width: w > 605 ? w * 0.14 : w * 0.12,
                                    height: w > 605 ? h * 0.08 : h * 0.055,
                                  ),
                                ),
                              ),
                              Text(
                                profile['username'],
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontSize: w > 385
                                        ? profile['username'].length > 10
                                            ? 9
                                            : profile['username'].length > 8
                                                ? 10
                                                : profile['username'].length > 6
                                                    ? 12
                                                    : 14
                                        : profile['username'].length > 10
                                            ? 7
                                            : profile['username'].length > 8
                                                ? 8
                                                : profile['username'].length > 5
                                                    ? 10
                                                    : 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Column(children: [
                          Text(
                            'P: ${profile['games']}',
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: w > 385 ? 13 : 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'G: ${profile['goals']}',
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: w > 385 ? 13 : 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'W: ${profile['win']}',
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: w > 385 ? 13 : 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ]),
                      ],
                    )
                  ]);
                }
                return Container();
              }))))
    ]);
  }
}

class ScoreSearchCard1 extends StatefulWidget {
  const ScoreSearchCard1({
    super.key,
    required this.user,
    required this.appointment,
  });

  final String user;
  final Map appointment;

  @override
  State<ScoreSearchCard1> createState() => _ScoreSearchCard1State();
}

class _ScoreSearchCard1State extends State<ScoreSearchCard1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    //bool ospite = false;
    //if (widget.user == 'ospite') {
    //    ospite = true;
    //  }

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  //if(databaseRef.child('Prenotazioni').child(profile['id']).child(profile['dateURL']).child('team1P${widget.p+2}') == ''){
                  //  return Container();
                  // }
                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385
                                            ? profile['username'].length > 10
                                                ? 9
                                                : profile['username'].length > 8
                                                    ? 10
                                                    : profile['username']
                                                                .length >
                                                            6
                                                        ? 12
                                                        : 14
                                            : profile['username'].length > 10
                                                ? 6
                                                : profile['username'].length > 8
                                                    ? 7
                                                    : profile['username']
                                                                .length >
                                                            5
                                                        ? 9
                                                        : 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'P: ${profile['games']}',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 13 : 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'G: ${profile['goals']}',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 13 : 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'W: ${profile['win']}',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 13 : 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ])
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class ScoreSearchCardP1 extends StatefulWidget {
  const ScoreSearchCardP1({
    super.key,
    required this.user,
    required this.team,
  });

  final String user;
  final int team;

  @override
  State<ScoreSearchCardP1> createState() => _ScoreSearchCardP1State();
}

class _ScoreSearchCardP1State extends State<ScoreSearchCardP1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385
                                            ? profile['username'].length > 10
                                                ? 9
                                                : profile['username'].length > 8
                                                    ? 10
                                                    : profile['username']
                                                                .length >
                                                            6
                                                        ? 12
                                                        : 14
                                            : profile['username'].length > 10
                                                ? 6
                                                : profile['username'].length > 8
                                                    ? 7
                                                    : profile['username']
                                                                .length >
                                                            5
                                                        ? 9
                                                        : 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'P: ${profile['games']}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 13 : 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'G: ${profile['goals']}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 13 : 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'W: ${profile['win']}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: w > 385 ? 13 : 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ]),
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class ScoreSearchCardOspite extends StatefulWidget {
  const ScoreSearchCardOspite({
    super.key,
    required this.user,
    required this.team,
  });

  final String user;
  final int team;

  @override
  State<ScoreSearchCardOspite> createState() => _ScoreSearchCardOspiteState();
}

class _ScoreSearchCardOspiteState extends State<ScoreSearchCardOspite> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385 ? 14 : 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class TennisSearchScoreCardP1 extends StatefulWidget {
  const TennisSearchScoreCardP1({
    super.key,
    required this.user,
    required this.team,
  });

  final String user;
  final int team;

  @override
  State<TennisSearchScoreCardP1> createState() =>
      _TennisSearchScoreCardP1State();
}

class _TennisSearchScoreCardP1State extends State<TennisSearchScoreCardP1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.1 : h * 0.1,
          width: w > 385 ? w * 0.35 : w * 0.38,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: profile['profile_pic'],
                          imageBuilder: (context, imageProvider) => Image(
                            image: imageProvider,
                            fit: BoxFit.fill,
                            width: w > 605 ? w * 0.14 : w * 0.12,
                            height: w > 605 ? h * 0.08 : h * 0.055,
                          ),
                        ),
                      ),
                      SizedBox(width: w > 605 ? 20 : w * 0.01),
                      SizedBox(
                        child: Text(
                          profile['username'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 2,
                              fontSize: profile['username'].length > 8
                                  ? 10
                                  : profile['username'].length > 6
                                      ? 12
                                      : 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class TennisSearchScoreCard1 extends StatefulWidget {
  const TennisSearchScoreCard1({
    super.key,
    required this.user,
    required this.player,
    required this.p,
    required this.date,
    required this.appointment,
    required this.allTeammateData,
    required this.list1,
  });

  final String user;
  final int player;
  final int p;
  final String date;
  final Map appointment;

  final List allTeammateData;

  final List list1;

  @override
  State<TennisSearchScoreCard1> createState() => _TennisSearchScoreCard1State();
}

class _TennisSearchScoreCard1State extends State<TennisSearchScoreCard1> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    bool ospite = false;
    if (widget.user == 'ospite') {
      ospite = true;
    }

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w * 0.7,
          color: kBackgroundColor2,
          child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(widget.user).get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profile =
                      snapshot.data!.data() as Map<String, dynamic>;

                  //if(databaseRef.child('Prenotazioni').child(profile['id']).child(profile['dateURL']).child('team1P${widget.p+2}') == ''){
                  //  return Container();
                  // }
                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: w > 605 ? h * 0.13 : h * 0.1,
                              width: w > 385 ? w * 0.20 : w * 0.22,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: profile['profile_pic'],
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                        width: w > 605 ? w * 0.14 : w * 0.12,
                                        height: w > 605 ? h * 0.08 : h * 0.055,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    profile['username'],
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: w > 385
                                            ? profile['username'].length > 8
                                                ? 10
                                                : profile['username'].length > 6
                                                    ? 12
                                                    : 14
                                            : profile['username'].length > 8
                                                ? 9
                                                : profile['username'].length > 5
                                                    ? 11
                                                    : 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: h > 700 ? h * 0.02 : h * 0.03,
                                  width: h * 0.03,
                                  //color: Colors.red,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: h * 0.01)),
                                          alignment: Alignment.topCenter,
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red)),
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                            HeroDialogRoute(builder: (context) {
                                          return PopUpChange1(
                                              appointment: widget.appointment,
                                              teammate: widget.allTeammateData,
                                              h: h,
                                              w: w,
                                              p: widget.p,
                                              sport: 'tennis',
                                              ospite: ospite,
                                              list1: widget.list1);
                                        }));
                                      },
                                      child: Text(
                                        'X',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w > 605
                                                ? 18
                                                : w > 385
                                                    ? 12
                                                    : 8),
                                      )),
                                ),
                              ],
                            )
                          ])
                    ],
                  );
                }
                return Container();
              }))))
    ]);
  }
}

class TennisSearchScoreCard2 extends StatefulWidget {
  const TennisSearchScoreCard2({
    super.key,
    required this.user,
    required this.player,
    required this.p,
    required this.date,
    required this.appointment,
    required this.allTeammateData,
    required this.list1,
  });

  final String user;
  final int player;
  final int p;
  final String date;
  final Map appointment;

  final List allTeammateData;

  final List list1;

  @override
  State<TennisSearchScoreCard2> createState() => _TennisSearchScoreCard2State();
}

class _TennisSearchScoreCard2State extends State<TennisSearchScoreCard2> {
  var goalsCounter = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    bool ospite = false;
    if (widget.user == 'ospite') {
      ospite = true;
    }

    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Stack(children: [
      Container(
          height: w > 605 ? h * 0.15 : h * 0.1,
          width: w * 0.7,
          color: kBackgroundColor2,
          child: Column(children: [
            FutureBuilder<DocumentSnapshot>(
                future: users.doc(widget.user).get(),
                builder: (((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> profile =
                        snapshot.data!.data() as Map<String, dynamic>;

                    //if(databaseRef.child('Prenotazioni').child(profile['id']).child(profile['dateURL']).child('team1P${widget.p+2}') == ''){
                    //  return Container();
                    // }

                    return Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: w > 605 ? h * 0.13 : h * 0.1,
                                width: w > 385 ? w * 0.20 : w * 0.22,
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: profile['profile_pic'],
                                        imageBuilder:
                                            (context, imageProvider) => Image(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                          width: w > 605 ? w * 0.14 : w * 0.12,
                                          height:
                                              w > 605 ? h * 0.08 : h * 0.055,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      profile['username'],
                                      style: TextStyle(
                                          letterSpacing: 2,
                                          fontSize: w > 385
                                              ? profile['username'].length > 8
                                                  ? 10
                                                  : profile['username'].length >
                                                          6
                                                      ? 12
                                                      : 14
                                              : profile['username'].length > 8
                                                  ? 9
                                                  : profile['username'].length >
                                                          5
                                                      ? 11
                                                      : 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: h > 700 ? h * 0.02 : h * 0.03,
                                    width: h * 0.03,
                                    //color: Colors.red,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    horizontal: h * 0.01)),
                                            alignment: Alignment.topCenter,
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red)),
                                        onPressed: () async {
                                          Navigator.of(context).push(
                                              HeroDialogRoute(
                                                  builder: (context) {
                                            return PopUpChange2(
                                              appointment: widget.appointment,
                                              teammate: widget.allTeammateData,
                                              h: h,
                                              w: w,
                                              p: widget.p,
                                              sport: 'tennis',
                                              ospite: ospite,
                                              list1: widget.list1,
                                            );
                                          }));
                                        },
                                        child: Text(
                                          'X',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: w > 605
                                                  ? 18
                                                  : w > 385
                                                      ? 12
                                                      : 8),
                                        )),
                                  ),
                                ],
                              )
                            ])
                      ],
                    );
                  }
                  return Container();
                }))),
          ]))
    ]);
  }
}
