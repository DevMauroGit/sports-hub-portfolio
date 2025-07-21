import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class PopUpAppointment extends StatefulWidget {
  // Constructor with required parameters for popup dimensions and appointment info
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

  final double h;          // Screen height for responsive layout
  final double w;          // Screen width for responsive layout

  final String host;       // Host user ID or name
  final String hour;       // Hour label as string
  final String available;  // Availability status ("true" or other)
  final String month;      // Month string for database reference
  final int day;           // Day number for database reference
  final String hourInt;    // Hour identifier for database reference
  final String pitch;      // Pitch identifier
  final Map club;          // Club data including database URL and admin email
  final int minutes;       // Minutes (used to determine half-hour or full hour)

  @override
  State<PopUpAppointment> createState() => PopUpAppointmentState();
}

class PopUpAppointmentState extends State<PopUpAppointment> {
  @override
  Widget build(BuildContext context) {
    // Determine database key based on whether it is a full hour or half hour slot
    String time = widget.minutes == 0 ? 'isTimeAvailable' : 'half_hour';

    return MediaQuery(
      // Apply custom text scaling for better readability
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.2)),
      child: Center(
        child: Container(
          // Outer container with margin and background color with transparency
          margin: EdgeInsets.symmetric(vertical: widget.h > 700 ? 240 : 120),
          width: widget.w * 0.85,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: kPrimaryColor.withOpacity(0.7),
          ),
          child: Center(
            child: Container(
              // Inner container with padding, margin and solid background color
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: widget.h > 700 ? 60 : 30),
              padding: EdgeInsets.symmetric(vertical: widget.h > 700 ? 60 : 30),
              width: widget.w * 0.7,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: kBackgroundColor2,
              ),
              child: Column(
                children: [
                  SizedBox(height: widget.h * 0.03),

                  // Display "ORARIO:" (Time) title with bold white text
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: widget.w > 380 ? 18 : 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    child: const Text(
                      'ORARIO:',
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: widget.h * 0.01),

                  // Display the hour value in white regular font
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: widget.w > 380 ? 18 : 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    child: Text(
                      widget.hour,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: widget.h * 0.03),

                  // Display "PRENOTAZIONE:" (Booking) title with bold white text
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: widget.w > 380 ? 18 : 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    child: const Text(
                      'PRENOTAZIONE:',
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: widget.h * 0.01),

                  // Conditional display based on availability and host presence
                  widget.available == 'true'
                      // Show "LIBERO" (Available) if slot is free
                      ? DefaultTextStyle(
                          style: TextStyle(
                            fontSize: widget.w > 380 ? 18 : 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          child: const Text(
                            'LIBERO',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : widget.host.isEmpty
                          // Show "OCCUPATO" (Occupied) if no host info is available
                          ? DefaultTextStyle(
                              style: TextStyle(
                                fontSize: widget.w > 380 ? 18 : 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              child: const Text(
                                'OCCUPATO',
                                textAlign: TextAlign.center,
                              ),
                            )
                          // If host is present, display host name and phone number retrieved from Firestore
                          : DefaultTextStyle(
                              style: TextStyle(
                                fontSize: widget.w > 380 ? 18 : 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    widget.host,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),

                                  // Fetch host phone number from Firestore and display it
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(widget.host)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        Map<String, dynamic> profile =
                                            snapshot.data!.data() as Map<String, dynamic>;
                                        return Text(
                                          'TELEFONO:\n${profile['phoneNumber']}',
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                      return Container(); // Empty container while loading
                                    },
                                  )
                                ],
                              ),
                            ),

                  const SizedBox(height: 10),

                  // Show button to book or free the pitch based on availability
                  widget.available == 'true'
                      ? Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            child: AnimatedButton(
                              isFixedHeight: false,
                              height: 30,
                              width: 120,
                              text: "OCCUPA", // Button text: "Book"
                              buttonTextStyle: TextStyle(
                                letterSpacing: 0.5,
                                color: Colors.black,
                                fontSize: widget.w > 380 ? 16 : 13,
                                fontWeight: FontWeight.bold,
                              ),
                              color: kPrimaryColor,
                              pressEvent: () {
                                // Confirmation dialog to book the pitch
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.topSlide,
                                  showCloseIcon: true,
                                  title: "Attento", // "Attention"
                                  titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: widget.w > 380 ? 30 : 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  desc: "Sei sicuro di voler occupare il campo?", // Confirm booking text
                                  descTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: widget.w > 380 ? 20 : 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  btnOkOnPress: () async {
                                    // Update Firebase Realtime Database to mark pitch as booked
                                    FirebaseDatabase.instanceFor(
                                      app: Firebase.app(),
                                      databaseURL: widget.club['dbURL'],
                                    )
                                        .ref()
                                        .child('Calendario')
                                        .child(widget.month)
                                        .child('${widget.day}')
                                        .child(widget.pitch)
                                        .child(widget.hourInt)
                                        .update({
                                      'user': widget.club['admin mail'],
                                      time: false,
                                    });
                                  },
                                  btnOkIcon: Icons.thumb_up,
                                  btnOkText: "PRENOTA", // "Book"
                                  btnOkColor: kBackgroundColor2,
                                ).show();
                              },
                            ),
                          ),
                        )
                      : Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: AnimatedButton(
                              isFixedHeight: false,
                              height: 30,
                              width: 120,
                              text: "LIBERA", // Button text: "Free"
                              buttonTextStyle: TextStyle(
                                letterSpacing: 0.5,
                                color: Colors.black,
                                fontSize: widget.w > 380 ? 16 : 13,
                                fontWeight: FontWeight.bold,
                              ),
                              color: kPrimaryColor,
                              pressEvent: () {
                                // Confirmation dialog to free the pitch
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.topSlide,
                                  showCloseIcon: true,
                                  title: "Attento", // "Attention"
                                  titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: widget.w > 380 ? 30 : 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  desc:
                                      "Sei sicuro di voler liberare il campo?\nla attuale prenotazione sarà eliminata", // Confirm freeing text
                                  descTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: widget.w > 380 ? 20 : 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  btnOkOnPress: () async {
                                    // Update Firebase Realtime Database to mark pitch as free
                                    FirebaseDatabase.instanceFor(
                                      app: Firebase.app(),
                                      databaseURL: widget.club['dbURL'],
                                    )
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
                                  btnOkText: "LIBERA", // "Free"
                                  btnOkColor: kBackgroundColor2,
                                ).show();
                              },
                            ),
                          ),
                        ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
