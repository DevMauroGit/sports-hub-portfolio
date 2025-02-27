import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/utils/datetime_converter.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';
import 'package:sports_hub_ios/widgets/popup_appointment_club.dart';
import 'package:table_calendar/table_calendar.dart';

class CreaMatch extends StatefulWidget {
  const CreaMatch(
      {super.key,
      required this.pitch,
      required this.daySelected,
      required this.club,
      required this.h,
      required this.w});

  final Map pitch;
  final DateTime daySelected;
  final Map club;
  final double h;
  final double w;

  @override
  State<CreaMatch> createState() => _CreaMatchState();
}

int teamSize = 5;

DatabaseReference ref = FirebaseDatabase.instance.ref();
final databaseRef = FirebaseDatabase.instance.ref();

class _CreaMatchState extends State<CreaMatch> {
  var descriptionController = TextEditingController();

  DateTime today = DateTime.now();
  String time = '';
  String hour = 'no time';
  String min = '';
  String next_hour = '';

  void _onDaySelected(
    DateTime day,
    DateTime focusDay,
  ) {
    setState(() {
      today = day;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreaMatch(
                    pitch: widget.pitch,
                    daySelected: today,
                    club: widget.club,
                    h: widget.h,
                    w: widget.w,
                  )) //AppointmentScreen2(pitch: widget.pitch, daySelected: today)),
          );
    });
  }

  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  void _entryModeChanged(TimePickerEntryMode? value) {
    if (value != entryMode) {
      setState(() {
        entryMode = value!;
      });
    }
  }

  void _orientationChanged(Orientation? value) {
    if (value != orientation) {
      setState(() {
        orientation = value;
      });
    }
  }

  void _textDirectionChanged(TextDirection? value) {
    if (value != textDirection) {
      setState(() {
        textDirection = value!;
      });
    }
  }

  void _tapTargetSizeChanged(MaterialTapTargetSize? value) {
    if (value != tapTargetSize) {
      setState(() {
        tapTargetSize = value!;
      });
    }
  }

  void _use24HourTimeChanged(bool? value) {
    if (value != use24HourTime) {
      setState(() {
        use24HourTime = value!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            body: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('User')
                    .doc(FirebaseAuth.instance.currentUser!.email.toString())
                    .get(),
                builder: (((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> profile =
                        snapshot.data!.data() as Map<String, dynamic>;

                    return CustomScrollView(slivers: [
                      SliverToBoxAdapter(
                          child: Column(children: [
                        //Header(size: size),
                        Container(
                            //height: widget.h,
                            padding: const EdgeInsets.only(
                                left: kDefaultPadding,
                                right: kDefaultPadding,
                                top: 20),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 40),
                                  Text(
                                    widget.pitch['club'],
                                    style: TextStyle(
                                        fontSize: widget.w > 605 ? 35 : 25,
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
                                                size: widget.h * 0.025,
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
                                                size: widget.h * 0.025,
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
                                        fontSize: widget.w > 605
                                            ? 30
                                            : widget.w > 385
                                                ? 23
                                                : 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                calendarStyle: CalendarStyle(
                                    selectedTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: widget.w > 605
                                            ? 22
                                            : widget.w > 385
                                                ? 18
                                                : 14),
                                    todayTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: widget.w > 605
                                            ? 22
                                            : widget.w > 385
                                                ? 18
                                                : 14),
                                    defaultTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: widget.w > 605
                                            ? 22
                                            : widget.w > 385
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ElevatedButton(
                                      child: Text(
                                        'Apri Orologio',
                                        style: TextStyle(
                                            fontSize: widget.w > 605
                                                ? 20
                                                : widget.w > 385
                                                    ? 18
                                                    : 12),
                                      ),
                                      onPressed: () async {
                                        final TimeOfDay? time =
                                            await showTimePicker(
                                          context: context,
                                          initialTime:
                                              selectedTime ?? TimeOfDay.now(),
                                          initialEntryMode: entryMode,
                                          orientation: orientation,
                                          //    builder: (BuildContext context, Widget? child) {
                                          // We just wrap these environmental changes around the
                                          // child in this builder so that we can apply the
                                          // options selected above. In regular usage, this is
                                          // rarely necessary, because the default values are
                                          // usually used as-is.
                                          //      return Theme(
                                          //        data: Theme.of(context).copyWith(
                                          //          materialTapTargetSize: tapTargetSize,
                                          //        ),
                                          //        child: Directionality(
                                          //          textDirection: textDirection,
                                          //          child: MediaQuery(
                                          //            data: MediaQuery.of(context).copyWith(
                                          //              alwaysUse24HourFormat: use24HourTime,
                                          //            ),
                                          //            child: child!,
                                          //          ),
                                          //        ),
                                          //      );
                                          //    },
                                        );
                                        setState(() {
                                          selectedTime = time;
                                        });
                                      },
                                    ),
                                  ),
                                  if (selectedTime != null)
                                    Text(
                                      'Orario: ${selectedTime!.format(context)}',
                                      style: TextStyle(
                                          fontSize: widget.w > 605
                                              ? 20
                                              : widget.w > 385
                                                  ? 16
                                                  : 12),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              //                 Padding(
                              //                 padding: EdgeInsets.symmetric(
                              //                 horizontal: widget.w * 0.05,
                              //vertical: h * 0.01
                              //             ),
                              //           child: TextFormField(
                              //     controller: descriptionController,
                              //   keyboardType: TextInputType.multiline,
                              //                     style: TextStyle(
                              //                       color: Colors.black,
                              //                     fontSize: widget.w > 385 ? 16 : 13),
                              //               decoration: InputDecoration(
                              //
                              //               hintText: "Aggiungi una descrizione o dei dettagli per organizzarsi",
                              //             focusedBorder: const OutlineInputBorder(
                              //               borderSide: BorderSide(
                              //                 color: Colors.black, width: 1.0)),
                              //       enabledBorder: const OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: Colors.black, width: 1.0)),
                              //                           border: OutlineInputBorder(
                              //                             borderRadius: BorderRadius.circular(30))),
                              //                   minLines: 2,
                              //                 maxLines: 8,
                              //               textAlign: TextAlign.start,
                              //           ),
                              //       ),
//                    Padding(padding: const EdgeInsets.only(right: kDefaultPadding, bottom: 20),
                              //                  child: Text('                                                   max 8 righe',
                              //                textAlign: TextAlign.right,
                              //              style: TextStyle(
                              //              color: Colors.grey[600],
                              //            fontSize: widget.w > 385 ? 14 : 12
                              //        ),),),
                              widget.club['premium'] == false
                                  ? TeamSizeSelection(h: widget.h, w: widget.w)
                                  : Container(),
                              //            const Spacer(),
                              const SizedBox(height: 20),
                              Text(
                                'Ricorda di prenotare il campo',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: widget.w > 605
                                        ? 22
                                        : widget.w > 385
                                            ? 18
                                            : 13,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 20),
                              //Text(DateTime.now().toString()),
                              AnimatedButton(
                                  isFixedHeight: false,
                                  height: widget.h * 0.05,
                                  width: widget.w * 0.4,
                                  text: "CONFERMA",
                                  buttonTextStyle: TextStyle(
                                      letterSpacing: 0.5,
                                      color: Colors.black,
                                      fontSize: widget.w > 605 ? 22 : 16,
                                      fontWeight: FontWeight.bold),
                                  color: kPrimaryColor,
                                  pressEvent: () async {
                                    if (selectedTime == null) {
                                      Get.snackbar("", '',
                                          snackPosition: SnackPosition.TOP,
                                          titleText: Text(
                                            'Nessun orario selezionato',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1,
                                              fontSize: widget.w < 380
                                                  ? 13
                                                  : widget.w > 605
                                                      ? 18
                                                      : 15,
                                            ),
                                          ),
                                          messageText: Text(
                                            "Prova a scegliere un orario",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1,
                                              fontSize: widget.w < 380
                                                  ? 13
                                                  : widget.w > 605
                                                      ? 18
                                                      : 15,
                                            ),
                                          ),
                                          duration: const Duration(seconds: 4),
                                          backgroundColor:
                                              Colors.redAccent.withOpacity(0.6),
                                          colorText: Colors.black);
                                    } else {
                                      print('go');

                                      Navigator.of(context).push(
                                          HeroDialogRoute(builder: (context) {
                                        return const LoadingScreen();
                                      }));

                                      time = selectedTime!.hour.toString();
                                      for (int i = 10; i < 24; i++) {
                                        if (time == '$i') {
                                          hour = '$i';
                                          next_hour = '${i + 1}';
                                        }
                                      }
                                      for (int i = 8; i > 0; i--) {
                                        if (time == '$i') {
                                          hour = '0$time';
                                          next_hour = '0${i + 1}';
                                        }
                                      }

                                      if (time == '9') {
                                        hour = '09';
                                        next_hour = '10';
                                      }

                                      if (selectedTime!.minute
                                              .toString()
                                              .length ==
                                          1) {
                                        min = '0${selectedTime!.minute}';
                                      } else {
                                        min = selectedTime!.minute.toString();
                                      }

                                      if (selectedTime!.hour
                                              .toString()
                                              .length ==
                                          1) {
                                        hour = '0${selectedTime!.hour}';
                                      } else {
                                        hour = '${selectedTime!.hour}';
                                      }

                                      time = '$hour:$min - $next_hour:$min';

                                      String monthN =
                                          '${widget.daySelected.month}';
                                      String dayN = '${widget.daySelected.day}';

                                      if (widget.daySelected.month < 10) {
                                        monthN = '0${widget.daySelected.month}';
                                      }

                                      if (widget.daySelected.day < 10) {
                                        dayN = '0${widget.daySelected.day}';
                                      }

                                      if (profile['prenotazioni'] < 4 &&
                                          DateTime.parse(
                                                  '2024-$monthN-$dayN $hour:$min:00')
                                              .isAfter(DateTime.now())) {
                                        // ignore: unused_local_variable
                                        final getDate = DateConverted.getDate(
                                            widget.daySelected);
                                        // ignore: unused_local_variable
                                        final getDay = DateConverted.getDay(
                                                widget.daySelected.weekday)
                                            .toString();

                                        String id = FirebaseAuth
                                            .instance.currentUser!.uid;
                                        String email = FirebaseAuth.instance
                                            .currentUser!.email as String;

                                        //DocumentSnapshot snap = await FirebaseFirestore.instance.collection('Clubs').doc(widget.club['mail']).get()

                                        final String description =
                                            descriptionController.text.trim();

                                        int teamSizeData = 0;

                                        if (widget.club['premium'] == false) {
                                          teamSizeData = teamSize;
                                        } else {
                                          teamSizeData =
                                              widget.pitch['teamSize'] as int;
                                        }

                                        sendToServer(
                                            id,
                                            email,
                                            widget.pitch['club'],
                                            widget.pitch['title'],
                                            '${widget.daySelected.day}/${widget.daySelected.month}/${widget.daySelected.year}',
                                            widget.daySelected.day.toString(),
                                            time,
                                            getMonth,
                                            widget.daySelected.day.toString(),
                                            1,
                                            teamSizeData,
                                            hour,
                                            min,
                                            monthN,
                                            dayN,
                                            profile['username'],
                                            '$getMonth-${widget.daySelected.day.toString()}-$time',
                                            1,
                                            widget.pitch['sport'],
                                            widget.pitch['first_hour'],
                                            widget.pitch['last_hour'],
                                            widget.club['dbURL'],
                                            widget.club['city'],
                                            description);

                                        //b_minutes = 45;

                                        await FirebaseFirestore.instance
                                            .collection("User")
                                            .doc(email)
                                            .update({
                                          'prenotazioni':
                                              profile['prenotazioni'] + 1
                                        });

                                        Navigator.of(context).push(
                                            HeroDialogRoute(builder: (context) {
                                          return PopUpAppointmentCreateClub(
                                            hour: time,
                                            date: '$dayN / $monthN',
                                            w: widget.w,
                                            h: widget.h,
                                            sport: widget.pitch['sport'],
                                            email: email,
                                          );
                                        }));

                                        //Get.offAll(SearchingPage(city: widget.club['city'], h: widget.h, w: widget.w,));
                                      } else {
                                        if (profile['prenotazioni'] >= 4) {
                                          Get.snackbar('', "",
                                              snackPosition: SnackPosition.TOP,
                                              titleText: Text(
                                                'Hai già ${profile['prenotazioni']} prenotazioni in programma o in attesa di risultato',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 1,
                                                    fontSize: widget.w < 380
                                                        ? 13
                                                        : widget.w > 605
                                                            ? 18
                                                            : 15),
                                              ),
                                              messageText: Text(
                                                "Conferma, cancella o archivia una partita per prenotare di nuovo",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 1,
                                                    fontSize: widget.w < 380
                                                        ? 13
                                                        : widget.w > 605
                                                            ? 18
                                                            : 15),
                                              ),
                                              duration:
                                                  const Duration(seconds: 6),
                                              backgroundColor: Colors.redAccent
                                                  .withOpacity(0.6),
                                              colorText: Colors.black);
                                        } else {
                                          if (DateTime.parse(
                                                      '2024-$monthN-$dayN $hour:$min:00')
                                                  .isAfter(DateTime.now()) !=
                                              true) {
                                            Get.snackbar('', "",
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                titleText: Text(
                                                  'Impossibile prenotare questo appuntamento',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      letterSpacing: 1,
                                                      fontSize: widget.w < 380
                                                          ? 13
                                                          : widget.w > 605
                                                              ? 18
                                                              : 15),
                                                ),
                                                messageText: Text(
                                                  "fuori tempo massimo",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 1,
                                                      fontSize: widget.w < 380
                                                          ? 13
                                                          : widget.w > 605
                                                              ? 18
                                                              : 15),
                                                ),
                                                duration:
                                                    const Duration(seconds: 4),
                                                backgroundColor: Colors
                                                    .redAccent
                                                    .withOpacity(0.6),
                                                colorText: Colors.black);
                                          }
                                        }
                                      }
                                    }
                                  }),
                              const SizedBox(height: 20),
                            ]))
                      ]))
                    ]);
                  }
                  return LoadingScreen();
                })))));
  }
}

void sendToServer(
    String id,
    String email,
    String club,
    String campo,
    String date,
    String day,
    String time,
    String month,
    String giorno,
    int playerCount,
    int teamSize,
    String hour,
    String minutes,
    String meseN,
    String dayN,
    String host,
    String dateURL,
    int counter,
    String sport,
    int first_hour,
    int last_hour,
    String dbURL,
    String city,
    String description) {
  FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: dbPrenotazioniURL)
      .ref()
      .child('Prenotazioni')
      .child(id)
      .child(sport)
      .child('Crea_Match')
      .child('$month-$day-$time')
      .set({
    'id': id,
    'email': email,
    'club': club,
    'campo': campo,
    'date': date,
    'day': day,
    'month': month,
    'meseN': meseN,
    'dayN': dayN,
    'time': time,
    'hour': hour,
    'minutes': minutes,
    'playerCount1': playerCount,
    'playerCount2': playerCount - 1,
    'playerCount1Tot': playerCount,
    'playerCount2Tot': playerCount - 1,
    'teamSize': teamSize,
    'caricato': false,
    'host': host,
    'dateURL': dateURL,
    'permissions': counter,
    'team1_P1': email,
    'sport': sport,
    'first_hour': first_hour,
    'last_hour': last_hour,
    'dbURL': dbURL,
    't1p1 goals': 0,
    'crea_match': true,
    'candidatiTot': 0,
    'commentiTot': 0,
    'city': city,
    'description': description
  });

  FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbCreaMatchURL)
      .ref()
      .child('Prenotazioni')
      .child('Crea_Match')
      .child(city)
      .child(sport)
      .child('$month-$day-$time')
      .set({
    'id': id,
    'email': email,
    'club': club,
    'campo': campo,
    'date': date,
    'day': day,
    'month': month,
    'meseN': meseN,
    'dayN': dayN,
    'time': time,
    'hour': hour,
    'minutes': minutes,
    'playerCount1': playerCount,
    'playerCount2': playerCount - 1,
    'playerCount1Tot': playerCount,
    'playerCount2Tot': playerCount - 1,
    'teamSize': teamSize,
    'caricato': false,
    'host': host,
    'dateURL': dateURL,
    'permissions': counter,
    'team1_P1': email,
    'sport': sport,
    'first_hour': first_hour,
    'last_hour': last_hour,
    'dbURL': dbURL,
    't1p1 goals': 0,
    'crea_match': true,
    'candidatiTot': 0,
    'commentiTot': 0,
    'city': city,
    'description': description
  });
}

class TeamSizeSelection extends StatefulWidget {
  const TeamSizeSelection({
    super.key,
    required this.h,
    required this.w,
  });

  final double h;
  final double w;

  @override
  State<TeamSizeSelection> createState() => _TeamSizeSelectionState();
}

class _TeamSizeSelectionState extends State<TeamSizeSelection> {
  int teamSizeData = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 45,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
              color: kBackgroundColor2,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            children: [
              Container(
                  width: 40,
                  height: 25,
                  decoration: BoxDecoration(
                      color: teamSizeData == 5 ? kPrimaryColor : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          teamSize = 5;
                          teamSizeData = 5;
                        });
                      },
                      child: Text(
                        '5v5',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: widget.w > 385 ? 14 : 12),
                      ))),
            ],
          ),
        ),
        Container(
          width: 60,
          height: 45,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
              color: kBackgroundColor2,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            children: [
              Container(
                  width: 40,
                  height: 25,
                  decoration: BoxDecoration(
                      color: teamSizeData == 7 ? kPrimaryColor : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          teamSize = 7;
                          teamSizeData = 7;
                        });
                      },
                      child: Text(
                        '7v7',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: widget.w > 385 ? 14 : 12),
                      ))),
            ],
          ),
        ),
        Container(
          width: 60,
          height: 45,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
              color: kBackgroundColor2,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            children: [
              Container(
                  width: 40,
                  height: 25,
                  decoration: BoxDecoration(
                      color: teamSizeData == 11 ? kPrimaryColor : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          teamSize = 11;
                          teamSizeData = 11;
                        });
                      },
                      child: Text(
                        '11v11',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: widget.w > 385 ? 12 : 9),
                      ))),
            ],
          ),
        ),
      ],
    );
  }
}
