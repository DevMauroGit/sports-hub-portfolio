import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/page/offer_to_play_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/register_memo.dart';

Widget AvailableGameCard(
    {required Map appointment, h, w, context, sport, required bool ospite}) {
  String b_hour = '';
  String a_hour = '';
  String b_minutes = '30';
  String minutes = '00';

  List calendar1 = [];
  List calendar2 = [];

  if (appointment['minutes'] == 0) {
    for (int i = 0; i < 21; i++) {
      if (appointment['hour'] == '$i') {
        a_hour = '${i + 1}';
        b_hour = '${i - 1}';
      }
      if (appointment['hour'] == '09') {
        b_hour = '08';
        a_hour = '10';
      }
      if (appointment['hour'] == '10') {
        b_hour = '09';
        a_hour = '11';
      }
    }
  }

  if (appointment['minutes'] == 30) {
    minutes = '30';
    b_minutes = '00';
    for (int i = 0; i < 21; i++) {
      if (appointment['hour'] == '$i') {
        a_hour = '${i + 1}';
        b_hour = '${i}';
      }
      if (appointment['hour'] == '09') {
        b_hour = '09';
        a_hour = '10';
      }
    }
  }

  String day = appointment['day'].toString();

  if (appointment['caricato'] == false &&
      DateTime.parse(
              '2024-${appointment['meseN']}-${appointment['dayN']} ${appointment['hour']}:${appointment['minutes']}:00')
          .isAfter(DateTime.now())) {
    return Column(children: [
      SizedBox(height: h * 0.02),
      Center(
          child: GestureDetector(
        onTap: () {
          ospite
              ? Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                  return RegisterMemo(
                    h: h,
                    w: w,
                  );
                }))
              : Get.to(
                  () => OfferToPlay(
                        appointment: appointment,
                        h: h,
                        w: w,
                      ),
                  transition: Transition.fadeIn);
        },
        child: Container(
            height: h > 700 ? h * 0.25 : h * 0.26,
            width: w * 0.8,
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: kBackgroundColor2,
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(children: [
                  SizedBox(height: h * 0.02),
                  SizedBox(
                    child: Image.asset("assets/images/tabellone.png"),
                  ),
                  SizedBox(height: h * 0.01),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: w * 0.365,
                              child: Text(appointment['club'].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: w > 385
                                          ? appointment['club'].length > 10
                                              ? 15
                                              : appointment['club'].length > 6
                                                  ? 16
                                                  : 18
                                          : appointment['club'].length > 10
                                              ? 9
                                              : appointment['club'].length > 6
                                                  ? 10
                                                  : 12,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic)),
                            ),
                            appointment['sport'] == 'football'
                                ? Container(
                                    width: w * 0.07,
                                    height: h * 0.035,
                                    decoration: const BoxDecoration(
                                        color: kBackgroundColor2,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Icon(
                                          Icons.sports_soccer,
                                          size: h * 0.025,
                                        )))
                                : Container(
                                    width: w * 0.07,
                                    height: h * 0.035,
                                    decoration: const BoxDecoration(
                                        color: kBackgroundColor2,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Icon(
                                          Icons.sports_tennis,
                                          size: h * 0.025,
                                        ))),
                            SizedBox(
                              width: w * 0.365,
                              child: Text(
                                  '${appointment['teamSize'].toString()} vs ${appointment['teamSize'].toString()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: w > 605
                                          ? 20
                                          : w > 385
                                              ? 17
                                              : 12,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic)),
                            ),
                          ],
                        ),
                        SizedBox(height: h * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(appointment['date'].toString(),
                                style: TextStyle(
                                    fontSize: w > 605
                                        ? 20
                                        : w > 390
                                            ? 15
                                            : 10,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic)),
                            Text(appointment['time'].toString(),
                                style: TextStyle(
                                    fontSize: w > 605
                                        ? 20
                                        : w > 385
                                            ? 15
                                            : 9,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic)),
                          ],
                        ),
                        SizedBox(height: h * 0.02),
                        Text(
                            '${appointment['playerCount1'] + appointment['playerCount2']} giocatori su ${appointment['teamSize'] * 2}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: w > 605
                                    ? 20
                                    : w > 385
                                        ? 17
                                        : 12,
                                color: Colors.white,
                                fontStyle: FontStyle.italic)),
                        SizedBox(
                          height: 0,
                          width: 0,
                          child: FirebaseAnimatedList(
                              query: FirebaseDatabase.instanceFor(
                                      app: Firebase.app(),
                                      databaseURL: appointment['dbURL'])
                                  .ref()
                                  .child('Calendario')
                                  .child(appointment['month'])
                                  .child(day)
                                  .child(appointment['campo']),
                              itemBuilder: (BuildContext context,
                                  DataSnapshot snapshot,
                                  Animation<double> animation,
                                  int index) {
                                (calendar1).add(snapshot.child('user').value);
                                (calendar2)
                                    .add(snapshot.child('user_half').value);

                                return Container();
                              }),
                        ),
                      ],
                    ),
                  ),
                ]))),
      ))
    ]);
  }
  return Container();
}

Future<void> updateToServer(
    String sport,
    String id,
    String day,
    String time,
    String month,
    String pitch,
    String hour,
    int minutes,
    List list1,
    List list2,
    int firstHour,
    int lastHour,
    String club,
    String dbURL) async {
  int hourInt = 09;
  String prevHour = '';
  String nextHour = '';

  for (int i = 0; i < 10; i++) {
    if (hour == '0$i') {
      hourInt = i;
    }
  }

  for (int i = 10; i < 24; i++) {
    if (hour == '$i') {
      hourInt = i;
    }
  }

  if (hourInt <= 10) {
    prevHour = '0${hourInt - 1}';
  } else {
    prevHour = '${hourInt - 1}';
  }
  if (hourInt < 9) {
    nextHour = '0${hourInt + 1}';
  } else {
    nextHour = '${hourInt + 1}';
  }

  if (minutes == 0) {
    FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
        .ref()
        .child('Calendario')
        .child(month)
        .child(day)
        .child(pitch)
        .child(hour)
        .update({
      'isTimeAvailable': true,
      'user': '',
    });

    if (sport == 'football') {
      if (hourInt < lastHour) {
        if (list1[hourInt - firstHour + 1] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(hour)
              .update({
            'half_hour': true,
          });
        }
      }

      if (hourInt > firstHour) {
        if (list1[hourInt - (firstHour + 1)] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(prevHour)
              .update({
            'half_hour': true,
          });
        }
      }
    } else if (sport == 'tennis') {
      if (hourInt < lastHour - 1) {
        if (list1[hourInt - firstHour + 1] == '' &&
            list2[hourInt - firstHour + 1] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(hour)
              .update({
            'half_hour': true,
          });
        }

        if (list2[hourInt - firstHour + 1] == '' &&
            list1[hourInt - firstHour + 2] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(nextHour)
              .update({
            'isTimeAvailable': true,
          });
        }
      } else if (hourInt == lastHour - 1) {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(hour)
            .update({
          'half_hour': true,
        });
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(nextHour)
            .update({
          'isTimeAvailable': true,
        });
      } else {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(hour)
            .update({
          'half_hour': true,
        });
      }

      if (hourInt > firstHour + 1) {
        if ((list2[hourInt - (firstHour + 2)] == '' ||
                list2[hourInt - (firstHour + 2)] == null) &&
            (list1[hourInt - (firstHour + 1)] == '' ||
                list1[hourInt - (firstHour + 1)] == null)) {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(prevHour)
              .update({
            'half_hour': true,
          });
          if ((list2[hourInt - (firstHour + 2)] == '' ||
                  list2[hourInt - (firstHour + 2)] == null) &&
              (list1[hourInt - (firstHour + 2)] == '' ||
                  list1[hourInt - (firstHour + 2)] == null)) {
            FirebaseDatabase.instanceFor(
                    app: Firebase.app(), databaseURL: dbURL)
                .ref()
                .child('Calendario')
                .child(month)
                .child(day)
                .child(pitch)
                .child(prevHour)
                .update({
              'isTimeAvailable': true,
            });
          }
        }
      } else if (hourInt == firstHour + 1) {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(prevHour)
            .update({
          'half_hour': true,
        });
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(prevHour)
            .update({
          'isTimeAvailable': true,
        });
        //}
        //}
      }
    }
  } else {
    FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
        .ref()
        .child('Calendario')
        .child(month)
        .child(day)
        .child(pitch)
        .child(hour)
        .update({'half_hour': true, 'user_half': ''});

    if (sport == 'football') {
      if (hourInt > firstHour) {
        if (list2[hourInt - (firstHour + 1)] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(hour)
              .update({
            'isTimeAvailable': true,
          });
        }
      } else {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(hour)
            .update({
          'isTimeAvailable': true,
        });
      }

      if (hourInt < lastHour) {
        if (list2[hourInt - firstHour + 1] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(nextHour)
              .update({
            'isTimeAvailable': true,
          });
        }
      }
    } else if (sport == 'tennis') {
      if (hourInt < lastHour - 1) {
        if (list2[hourInt - firstHour + 1] == '' &&
            list1[hourInt - firstHour + 2] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(nextHour)
              .update({
            'isTimeAvailable': true,
          });
        }

        if (list1[hourInt - firstHour + 2] == '' &&
            list2[hourInt - firstHour + 2] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(nextHour)
              .update({
            'half_hour': true,
          });
        }
      } else if (hourInt == lastHour - 1) {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(nextHour)
            .update({
          'isTimeAvailable': true,
          'half_hour': true,
        });
      }

      if (hourInt > firstHour + 1) {
        if (list2[hourInt - (firstHour + 1)] == '' &&
            list1[hourInt - (firstHour + 1)] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(hour)
              .update({
            'isTimeAvailable': true,
          });

          if (list1[hourInt - (firstHour + 1)] == '' &&
              list2[hourInt - (firstHour + 2)] == '') {
            FirebaseDatabase.instanceFor(
                    app: Firebase.app(), databaseURL: dbURL)
                .ref()
                .child('Calendario')
                .child(month)
                .child(day)
                .child(pitch)
                .child(prevHour)
                .update({
              'half_hour': true,
            });
          }
        }
      } else if (hourInt == firstHour + 1) {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(hour)
            .update({
          'isTimeAvailable': true,
        });
        if (list1[hourInt - (firstHour + 1)] == '') {
          FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
              .ref()
              .child('Calendario')
              .child(month)
              .child(day)
              .child(pitch)
              .child(prevHour)
              .update({
            'half_hour': true,
          });
        }
      } else if (hourInt == firstHour) {
        FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbURL)
            .ref()
            .child('Calendario')
            .child(month)
            .child(day)
            .child(pitch)
            .child(hour)
            .update({
          'isTimeAvailable': true,
        });
      }
    }
  }

  FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child(sport)
      .child('$month-$day-$time')
      .remove();
}
