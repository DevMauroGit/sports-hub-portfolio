import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/admin_controller.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/utils/datetime_converter.dart';
import 'package:sports_hub_ios/widgets/Admin/popup_appointment.dart';

class TableAppointment extends StatefulWidget {
  // Constructor requires the selected day and club info map
  final DateTime daySelected;
  final Map club;

  const TableAppointment({
    super.key,
    required this.daySelected,
    required this.club,
  });

  @override
  State<TableAppointment> createState() => _TableAppointmentState();
}

class _TableAppointmentState extends State<TableAppointment> {
  // Instantiate AdminController using GetX package for state management
  AdminController adminController = Get.put(AdminController());

  late Future<AdminController> dataFuture;

  @override
  void initState() {
    super.initState();
    // Initialize async data loading
    dataFuture = getData();
  }

  // Async function to get or create AdminController and related services
  Future<AdminController> getData() async {
    adminController = await Get.put(AdminController());
    Get.lazyPut(() => FirebaseStorageService());
    return adminController;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height and width for responsive UI
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    // Format month string with leading zero if month < 10
    String data = "";
    if (widget.daySelected.month < 10) {
      setState(() {
        data = "0";
      });
    }
    // Construct database path segment using month number and name
    final getMonth =
        "$data${widget.daySelected.month}_${DateConverted.getMonth(widget.daySelected.month)}";

    // Define text styles for titles and status labels
    TextStyle titles = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: w > 385 ? 18 : 14,
    );

    TextStyle prenotato = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: w > 385 ? 11 : 8,
    );

    TextStyle libero = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: w > 385 ? 14 : 10,
    );

    ScrollController scrollController2 = ScrollController();

    return SizedBox(
      width: w * 0.75,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enable horizontal scroll for wide content
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              // Row showing time slots for each hour and half-hour in the club schedule
              SizedBox(
                height: h * 0.05,
                width: w * 0.25 * widget.club['slot'] * 2,
                child: Row(
                  children: [
                    // Loop through the number of time slots defined in the club
                    for (int i = 0; i < widget.club['slot']; i++)
                      Row(
                        children: [
                          // Display the hour mark (e.g. "9:00")
                          Container(
                            width: w * 0.2,
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.symmetric(horizontal: h * 0.01),
                            child: Text(
                              '${widget.club['orari']['h${i + 1}']}:00',
                              style: titles,
                            ),
                          ),
                          // Display the half-hour mark (e.g. "9:30")
                          Container(
                            width: w * 0.2,
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.symmetric(horizontal: h * 0.01),
                            child: Text(
                              '${widget.club['orari']['h${i + 1}']}:30',
                              style: titles,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // Create a list of rows, one for each pitch (field)
              for (int i = 0; i < widget.club['pitches_number']; i++)
                Container(
                  height: h * 0.07,
                  width: w * 0.25 * widget.club['slot'] * 2,
                  color: Colors.green[800], // Background color for pitch row
                  alignment: Alignment.topCenter,
                  child: FirebaseAnimatedList(
                    controller: scrollController2,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside list
                    // Query Firebase Realtime Database for pitch schedule of selected day and month
                    query: FirebaseDatabase.instanceFor(
                      app: Firebase.app(),
                      databaseURL: widget.club['dbURL'],
                    )
                        .ref()
                        .child('Calendario')
                        .child(getMonth)
                        .child("${widget.daySelected.day}")
                        .child('Campo ${i + 1}'),
                    // Build each time slot widget from Firebase data snapshot
                    itemBuilder:
                        (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                      Map day = snapshot.value as Map;
                      day['key'] = snapshot.key;

                      var availableTime = [];
                      var availableNextTime = [];

                      // Check if full hour slot is available or booked
                      if (snapshot.child('isTimeAvailable').value.toString() == 'true') {
                        availableTime.add('libero'); // Available
                      } else {
                        availableTime.add('prenotato'); // Booked
                      }

                      // Check if half-hour slot is available or booked
                      if (snapshot.child('half_hour').value.toString() == 'true') {
                        availableNextTime.add('libero'); // Available
                      } else {
                        availableNextTime.add('prenotato'); // Booked
                      }

                      return Center(
                        child: Row(
                          children: [
                            // Full hour time slot cell with tap gesture to open detailed popup
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                  return PopUpAppointment(
                                    host: snapshot.child('user').value.toString(),
                                    hour: '${snapshot.key.toString()}:00',
                                    available: snapshot.child('isTimeAvailable').value.toString(),
                                    w: w,
                                    h: h,
                                    month: getMonth,
                                    day: widget.daySelected.day,
                                    hourInt: snapshot.key.toString(),
                                    pitch: 'Campo ${i + 1}',
                                    club: widget.club,
                                    minutes: 0,
                                  );
                                }));
                              },
                              child: Container(
                                height: h * 0.75,
                                width: w * 0.2,
                                margin: EdgeInsets.all(h * 0.01),
                                padding: EdgeInsets.symmetric(horizontal: h * 0.01),
                                decoration: BoxDecoration(
                                  color: availableTime[0] == 'libero' ? Colors.green[600] : Colors.red,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(
                                    availableTime[0],
                                    style: availableTime[0] == 'libero' ? libero : prenotato,
                                  ),
                                ),
                              ),
                            ),

                            // Half-hour time slot cell with tap gesture to open detailed popup
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                  return PopUpAppointment(
                                    host: snapshot.child('user_half').value.toString(),
                                    hour: '${snapshot.key.toString()}:30',
                                    available: snapshot.child('half_hour').value.toString(),
                                    w: w,
                                    h: h,
                                    month: getMonth,
                                    day: widget.daySelected.day,
                                    hourInt: snapshot.key.toString(),
                                    pitch: 'Campo ${i + 1}',
                                    club: widget.club,
                                    minutes: 30,
                                  );
                                }));
                              },
                              child: Container(
                                height: h * 0.75,
                                width: w * 0.2,
                                margin: EdgeInsets.all(h * 0.01),
                                padding: EdgeInsets.symmetric(horizontal: h * 0.01),
                                decoration: BoxDecoration(
                                  color: availableNextTime[0] == 'libero' ? Colors.green[600] : Colors.red,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(
                                    availableNextTime[0],
                                    style: availableNextTime[0] == 'libero' ? libero : prenotato,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
