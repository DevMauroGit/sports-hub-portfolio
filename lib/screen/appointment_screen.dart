// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/utils/datetime_converter.dart';
import 'package:sports_hub_ios/widgets/pitch_table_appointment.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_database/firebase_database.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({
    super.key,
    required this.pitch,
    required this.daySelected,
  });

  //final PitchModel pitch;
  final Map pitch;
  final DateTime daySelected;

  @override
  State<AppointmentScreen> createState() => AppointmentScreenState();
}

class AppointmentScreenState extends State<AppointmentScreen> {
  DateTime today = DateTime.now();
  String time = '';
  String hour = 'no time';
  int min = 0;
  void _onDaySelected(
    DateTime day,
    DateTime focusDay,
  ) {
    setState(() {
      today = day;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AppointmentScreen(
                    pitch: widget.pitch,
                    daySelected: today,
                  )) //AppointmentScreen2(pitch: widget.pitch, daySelected: today)),
          );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final GlobalKey<FormState> _key = GlobalKey();
  final databaseRef = FirebaseDatabase.instance.ref();
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Calendario');

  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    String data = "";
    if (widget.daySelected.month < 10) {
      setState(() {
        data = "0";
      });
    }
    final getMonth =
        "$data${widget.daySelected.month}_${DateConverted.getMonth(widget.daySelected.month)}";

    initializeDateFormatting('it');

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBar(),
            bottomNavigationBar: BottomBar(context),
            body: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                  child: Form(
                      key: _key,
                      child: Column(children: [
                        //Header(size: size),
                        Container(
                          padding: const EdgeInsets.only(
                              left: kDefaultPadding,
                              right: kDefaultPadding,
                              top: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 40),
                                  Text(
                                    widget.pitch['club'],
                                    style: TextStyle(
                                        fontSize: w > 605 ? 35 : 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  widget.pitch['sport'] == 'football'
                                      ? Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                              color: kBackgroundColor2,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Icon(
                                                Icons.sports_soccer,
                                                size: h * 0.025,
                                              )))
                                      : Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                              color: kBackgroundColor2,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Icon(
                                                Icons.sports_tennis,
                                                size: h * 0.025,
                                              ))),
                                ],
                              ),
                              TableCalendar(
                                locale: "it",
                                weekendDays: const [],
                                headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    titleTextStyle: TextStyle(
                                        fontSize: w > 605
                                            ? 30
                                            : w > 385
                                                ? 23
                                                : 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                calendarStyle: CalendarStyle(
                                    selectedTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: w > 605
                                            ? 22
                                            : w > 385
                                                ? 18
                                                : 14),
                                    todayTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: w > 605
                                            ? 22
                                            : w > 385
                                                ? 18
                                                : 14),
                                    defaultTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: w > 605
                                            ? 22
                                            : w > 385
                                                ? 18
                                                : 14)),
                                selectedDayPredicate: (day) =>
                                    isSameDay(day, widget.daySelected),
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                focusedDay: today,
                                firstDay: DateTime.now(),
                                lastDay: DateTime.utc(DateTime.now().year,
                                    DateTime.now().month + 1, 31),
                                onDaySelected: _onDaySelected,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Seleziona uno degli Orari Disponibili per PRENOTARE',
                                        style: TextStyle(
                                            fontSize: w > 605
                                                ? 25
                                                : w > 385
                                                    ? 20
                                                    : 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 20)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ]))),
              SliverToBoxAdapter(
                child: Form(
                    child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Clubs')
                            .doc(widget.pitch['club_mail'])
                            .get(),
                        builder: (((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> club =
                                snapshot.data!.data() as Map<String, dynamic>;

                            return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: PitchTableAppointment(
                                    daySelected: widget.daySelected,
                                    club: club,
                                    pitch: widget.pitch));
                          }
                          return Container();
                        })))),
              ),
            ])));
  }
}
