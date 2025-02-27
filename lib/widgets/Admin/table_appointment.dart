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
  final DateTime daySelected;
  final Map club;

  const TableAppointment(
      {super.key, required this.daySelected, required this.club});

  @override
  State<TableAppointment> createState() => _TableAppointmentState();
}

class _TableAppointmentState extends State<TableAppointment> {
  AdminController adminController = Get.put(AdminController());

  late Future<AdminController> dataFuture;

  @override
  void initState() {
    super.initState();

    dataFuture = getData();
  }

  Future<AdminController> getData() async {
    adminController = await Get.put(AdminController());
    Get.lazyPut(() => FirebaseStorageService());

    return adminController;
  }

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

    TextStyle titles = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: w > 385 ? 18 : 14,
    );

    TextStyle prenotato = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: w > 385 ? 11 : 8);

    TextStyle libero = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: w > 385 ? 14 : 10);

    ScrollController scrollController2 = ScrollController();

    return SizedBox(
      width: w * 0.75,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              SizedBox(
                  height: h * 0.05,
                  width: w * 0.25 * widget.club['slot'] * 2,
                  child: Row(
                    children: [
                      for (int i = 0; i < widget.club['slot']; i++)
                        Row(
                          children: [
                            Container(
                                width: w * 0.2,
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.symmetric(
                                  horizontal: h * 0.01,
                                ),
                                child: Text(
                                  '${widget.club['orari']['h${i + 1}']}:00',
                                  style: titles,
                                )),
                            Container(
                                width: w * 0.2,
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.symmetric(
                                  horizontal: h * 0.01,
                                ),
                                child: Text(
                                  '${widget.club['orari']['h${i + 1}']}:30',
                                  style: titles,
                                )),
                          ],
                        ),
                    ],
                  )),
              for (int i = 0; i < widget.club['pitches_number']; i++)
                Container(
                  height: h * 0.07,
                  width: w * 0.25 * widget.club['slot'] * 2,
                  color: Colors.green[800],
                  alignment: Alignment.topCenter,
                  child: FirebaseAnimatedList(
                      controller: scrollController2,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      query: FirebaseDatabase.instanceFor(
                              app: Firebase.app(),
                              databaseURL: widget.club['dbURL'])
                          .ref()
                          .child('Calendario')
                          .child(getMonth)
                          .child("${widget.daySelected.day}")
                          .child('Campo ${i + 1}'),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Map day = snapshot.value as Map;
                        day['key'] = snapshot.key;

                        var availableTime = [];
                        var availableNextTime = [];

                        if (snapshot
                                .child('isTimeAvailable')
                                .value
                                .toString() ==
                            'true') {
                          availableTime.add('libero');
                        } else {
                          availableTime.add('prenotato');
                        }

                        if (snapshot.child('half_hour').value.toString() ==
                            'true') {
                          availableNextTime.add('libero');
                        } else {
                          availableNextTime.add('prenotato');
                        }

                        return Center(
                            child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(HeroDialogRoute(builder: (context) {
                                  return PopUpAppointment(
                                    host:
                                        snapshot.child('user').value.toString(),
                                    hour: '${snapshot.key.toString()}:00',
                                    available: snapshot
                                        .child('isTimeAvailable')
                                        .value
                                        .toString(),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: h * 0.01),
                                  decoration: BoxDecoration(
                                      color: availableTime[0] == 'libero'
                                          ? Colors.green[600]
                                          : Colors.red,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                      child: Text(availableTime[0],
                                          style: availableTime[0] == 'libero'
                                              ? libero
                                              : prenotato))),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(HeroDialogRoute(builder: (context) {
                                  return PopUpAppointment(
                                    host: snapshot
                                        .child('user_half')
                                        .value
                                        .toString(),
                                    hour: '${snapshot.key.toString()}:30',
                                    available: snapshot
                                        .child('half_hour')
                                        .value
                                        .toString(),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: h * 0.01),
                                  decoration: BoxDecoration(
                                      color: availableNextTime[0] == 'libero'
                                          ? Colors.green[600]
                                          : Colors.red,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                      child: Text(availableNextTime[0],
                                          style:
                                              availableNextTime[0] == 'libero'
                                                  ? libero
                                                  : prenotato))),
                            ),
                          ],
                        ));
                      }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
