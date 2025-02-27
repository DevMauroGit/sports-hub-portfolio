import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class PopUpAppointment extends StatefulWidget {
  const PopUpAppointment({
    super.key,
    required this.h,
    required this.w,
    required this.host,
    required this.hour,
    required this.available,
    required this.month,
    required this.day,
    required this.hourInt,
    required this.pitch,
    required this.club,
    required this.minutes,
  });

  final double h;
  final double w;

  final String host;
  final String hour;

  final String available;

  final String month;
  final int day;
  final String hourInt;
  final String pitch;

  final Map club;

  final int minutes;

  @override
  State<PopUpAppointment> createState() => PopUpAppointmentState();
}

class PopUpAppointmentState extends State<PopUpAppointment> {
  @override
  Widget build(BuildContext context) {
    String time = '';

    widget.minutes == 0 ? time = 'isTimeAvailable' : time = 'half_hour';

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                //height: widget.h > 700 ? widget.h * 0.35 : widget.h * 0.4,
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 240 : 120),
                width: widget.w * 0.85,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    //height: widget.h > 700 ? widget.h * 0.25 : widget.h * 0.3,
                    margin: EdgeInsets.symmetric(
                        vertical: widget.h > 700 ? 60 : 30),
                    padding: EdgeInsets.symmetric(
                        vertical: widget.h > 700 ? 60 : 30),
                    width: widget.w * 0.7,
                    //margin: EdgeInsets.only(top: h*0.02),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: kBackgroundColor2,
                    ),

                    child: Column(
                      children: [
                        SizedBox(height: widget.h * 0.03),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 380 ? 18 : 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          child: const Text(
                            'ORARIO:',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: widget.h * 0.01),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 380 ? 18 : 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          child: Text(
                            widget.hour,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: widget.h * 0.03),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 380 ? 18 : 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          child: const Text(
                            'PRENOTAZIONE:',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: widget.h * 0.01),
                        widget.available == 'true'
                            ? DefaultTextStyle(
                                style: TextStyle(
                                    fontSize: widget.w > 380 ? 18 : 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                                child: const Text(
                                  'LIBERO',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : widget.host.isEmpty
                                ? DefaultTextStyle(
                                    style: TextStyle(
                                        fontSize: widget.w > 380 ? 18 : 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                    child: const Text(
                                      'OCCUPATO',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : DefaultTextStyle(
                                    style: TextStyle(
                                        fontSize: widget.w > 380 ? 18 : 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.host,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        FutureBuilder<DocumentSnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('User')
                                                .doc(widget.host)
                                                .get(),
                                            builder: (((context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                Map<String, dynamic> profile =
                                                    snapshot.data!.data()
                                                        as Map<String, dynamic>;
                                                return Text(
                                                  'TELEFONO:\n${profile['phoneNumber']}',
                                                  textAlign: TextAlign.center,
                                                );
                                              }
                                              return Container();
                                            })))
                                      ],
                                    ),
                                  ),
                        const SizedBox(height: 10),
                        widget.available == 'true'
                            ? Center(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: AnimatedButton(
                                    isFixedHeight: false,
                                    height: 30,
                                    width: 120,
                                    text: "OCCUPA",
                                    buttonTextStyle: TextStyle(
                                        letterSpacing: 0.5,
                                        color: Colors.black,
                                        fontSize: widget.w > 380 ? 16 : 13,
                                        fontWeight: FontWeight.bold),
                                    color: kPrimaryColor,
                                    pressEvent: () {
                                      AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.warning,
                                              animType: AnimType.topSlide,
                                              showCloseIcon: true,
                                              title: "Attento",
                                              titleTextStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      widget.w > 380 ? 30 : 25,
                                                  fontWeight: FontWeight.w700),
                                              desc:
                                                  "Sei sicuro di voler occupare il campo?",
                                              descTextStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      widget.w > 380 ? 20 : 18,
                                                  fontWeight: FontWeight.w700),
                                              btnOkOnPress: () async {
                                                FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL: widget
                                                            .club['dbURL'])
                                                    .ref()
                                                    .child('Calendario')
                                                    .child(widget.month)
                                                    .child('${widget.day}')
                                                    .child(widget.pitch)
                                                    .child(widget.hourInt)
                                                    .update({
                                                  'user':
                                                      widget.club['admin mail'],
                                                  time: false,
                                                });
                                              },
                                              btnOkIcon: Icons.thumb_up,
                                              btnOkText: "PRENOTA",
                                              btnOkColor: kBackgroundColor2)
                                          .show();
                                    },
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: AnimatedButton(
                                    isFixedHeight: false,
                                    height: 30,
                                    width: 120,
                                    text: "LIBERA",
                                    buttonTextStyle: TextStyle(
                                        letterSpacing: 0.5,
                                        color: Colors.black,
                                        fontSize: widget.w > 380 ? 16 : 13,
                                        fontWeight: FontWeight.bold),
                                    color: kPrimaryColor,
                                    pressEvent: () {
                                      AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.warning,
                                              animType: AnimType.topSlide,
                                              showCloseIcon: true,
                                              title: "Attento",
                                              titleTextStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      widget.w > 380 ? 30 : 25,
                                                  fontWeight: FontWeight.w700),
                                              desc:
                                                  "Sei sicuro di voler liberare il campo?\nla attuale prenotazione sarà eliminata",
                                              descTextStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      widget.w > 380 ? 20 : 18,
                                                  fontWeight: FontWeight.w700),
                                              btnOkOnPress: () async {
                                                FirebaseDatabase.instanceFor(
                                                        app: Firebase.app(),
                                                        databaseURL: widget
                                                            .club['dbURL'])
                                                    .ref()
                                                    .child('Calendario')
                                                    .child(widget.month)
                                                    .child('${widget.day}')
                                                    .child(widget.pitch)
                                                    .child(widget.hourInt)
                                                    .update({
                                                  'user': '',
                                                  time: true,
                                                });
                                              },
                                              btnOkIcon: Icons.thumb_up,
                                              btnOkText: "LIBERA",
                                              btnOkColor: kBackgroundColor2)
                                          .show();
                                    },
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ))));
  }
}
