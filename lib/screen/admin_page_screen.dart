// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unused_field

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sports_hub_ios/page/admin_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/utils/datetime_converter.dart';
import 'package:sports_hub_ios/widgets/Admin/pitch_column.dart';
import 'package:sports_hub_ios/widgets/Admin/table_appointment.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminPageScreen extends StatefulWidget {
  // Receives admin club data and the initially selected day
  final Map adminClub;
  final DateTime daySelected;

  const AdminPageScreen(
      {super.key, required this.adminClub, required this.daySelected});

  @override
  State<AdminPageScreen> createState() => _AdminPageScreenState();
}

// Scroll controller for managing scrolling in the page
ScrollController scrollController = ScrollController();

class _AdminPageScreenState extends State<AdminPageScreen> {
  // State to track if a time slot has been selected
  late bool _timeSelected;

  // Today's date initialized with current date/time
  DateTime today = DateTime.now();

  // Variables to store selected time information
  String time = 'no time';
  String hour = 'no time';
  int min = 0;

  // Handler for when a new calendar day is selected
  void _onDaySelected(
    DateTime day,
    DateTime focusDay,
  ) {
    setState(() {
      today = day; // Update selected day
      _timeSelected = true; // Mark time as selected
      // Navigate to AdminPage with the newly selected day
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPage(day: today)),
      );
    });
  }

  // Handler for when a time slot is selected from UI components
  void _onTimeSelected(String slot, String hours, int minutes) {
    setState(() {
      time = slot;
      hour = hours;
      min = minutes;
    });
  }

  @override
  void initState() {
    // Initialization code (commented out for now)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive UI sizing
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;

    // Format month string with leading zero if needed
    String data = "";
    if (widget.daySelected.month < 10) {
      setState(() {
        data = "0";
      });
    }

    // Compose string with month number and month name for display
    final getMonth =
        "$data${widget.daySelected.month}_${DateConverted.getMonth(widget.daySelected.month)}";

    // Initialize date formatting localization for Italian
    initializeDateFormatting('it');

    // Main scrollable content of the admin page
    return SingleChildScrollView(
        controller: scrollController,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Top header section with club title and logo
              Container(
                  margin: const EdgeInsets.only(bottom: kDefaultPadding * 2.5),
                  height: size.height * 0.24,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: kDefaultPadding + 10,
                                right: kDefaultPadding + 10,
                                bottom: kDefaultPadding),
                            height: size.height * 0.2,
                            decoration: BoxDecoration(
                              color: kBackgroundColor2.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(36),
                                bottomRight: Radius.circular(36),
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: kDefaultPadding + 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    // Display main app title with styling
                                    Text(
                                      'SPORTS HUB',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  size.width > 380 ? 40 : 30,
                                              fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Spacer(),
                                    // Display club logo image
                                    Image.asset(
                                      "assets/images/Sport_hub_logo_1.png",
                                      height: size.width > 380 ? 80 : 60,
                                      width: size.width > 380 ? 80 : 60,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Positioned container for the club title banner at the bottom of the header
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 10),
                                  blurRadius: 50,
                                  color: kSecondaryColor),
                            ],
                          ),
                          // Display the title of the admin club
                          child: Text(widget.adminClub['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: size.width > 380 ? 28 : 20)),
                        ),
                      )
                    ],
                  )),
              // Calendar widget allowing the admin to select days
              TableCalendar(
                locale: "it",
                weekendDays: [], // No weekend days highlighted
                headerStyle: HeaderStyle(
                    formatButtonVisible: false, // Hide format toggle button
                    titleCentered: true, // Center the month title
                    titleTextStyle: TextStyle(
                        fontSize: w > 380 ? 23 : 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                calendarStyle: CalendarStyle(
                    selectedTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: w > 380 ? 18 : 14),
                    todayTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: w > 380 ? 18 : 14),
                    defaultTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: w > 380 ? 18 : 14)),
                selectedDayPredicate: (day) => isSameDay(
                    day, widget.daySelected), // Highlight selected day
                startingDayOfWeek: StartingDayOfWeek.monday,
                focusedDay: today, // Current focused day
                firstDay: DateTime.utc(
                    DateTime.now().year,
                    DateTime.now().month - 1,
                    1), // Limit calendar to last month
                lastDay: DateTime.utc(
                    DateTime.now().year,
                    DateTime.now().month + 1,
                    31), // Limit calendar to next month
                onDaySelected: _onDaySelected, // Handle day selection
              ),
              SizedBox(height: h * 0.02),
              // Row containing pitch column and appointments table side-by-side
              Row(
                children: [
                  // Widget displaying pitch details for the selected day
                  PitchColumn(
                    daySelected: widget.daySelected,
                    pitches_number: widget.adminClub['pitches_number'],
                  ),
                  // Widget displaying scheduled appointments for the day and club
                  TableAppointment(
                      daySelected: widget.daySelected, club: widget.adminClub),
                ],
              ),
              SizedBox(height: h * 0.03),
              // Logout button centered at the bottom of the page
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: w * 0.35),
                  child: AnimatedButton(
                    isFixedHeight: false,
                    height: 40,
                    width: 120,
                    text: "LogOut",
                    buttonTextStyle: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.black,
                        fontSize: w > 380 ? 16 : 13,
                        fontWeight: FontWeight.bold),
                    color: kPrimaryColor,
                    pressEvent: () {
                      // Show confirmation dialog before logging out
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.topSlide,
                              showCloseIcon: true,
                              title: "Attento",
                              titleTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: w > 380 ? 30 : 25,
                                  fontWeight: FontWeight.w700),
                              desc: "Sei sicuro di voler uscire?",
                              descTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: w > 380 ? 20 : 18,
                                  fontWeight: FontWeight.w700),
                              btnOkOnPress: () async {
                                // Sign out user and close the app after short delay
                                FirebaseAuth.instance.signOut();
                                Future.delayed(Duration(milliseconds: 600))
                                    .then((value) => SystemChannels.platform
                                        .invokeMethod('SystemNavigator.pop'));
                              },
                              btnOkIcon: Icons.thumb_up,
                              btnOkText: "DISCONNETTITI",
                              btnOkColor: kBackgroundColor2)
                          .show();
                    },
                  ),
                ),
              ),
              SizedBox(height: h * 0.02),
            ]));
  }
}
