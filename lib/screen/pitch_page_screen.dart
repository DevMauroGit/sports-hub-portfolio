import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/screen/appointment_screen.dart';
import 'package:sports_hub_ios/widgets/Crea_Match/crea_match.dart';
import 'package:sports_hub_ios/widgets/icon_and_text_widget.dart';

class PitchPageScreen extends StatefulWidget {
  const PitchPageScreen({super.key, required this.pitch, required this.club});

  final Map pitch;
  final Map club;

  @override
  State<PitchPageScreen> createState() => _PitchPageScreenState();
}

class _PitchPageScreenState extends State<PitchPageScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height / 3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.pitch['image']!,
              fit: BoxFit.fill,
              placeholder: (context, url) => Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
          SizedBox(height: h * 0.02),
          Container(
              //height: h > 900 ? h * 0.7 : h * 0.8,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Campo ${widget.pitch['id']}",
                      style: TextStyle(
                          fontSize: w > 605
                              ? 35
                              : w > 385
                                  ? 28
                                  : 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: h * 0.02),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconAndTextWidget(
                          icon: Icons.accessibility,
                          text: widget.pitch['players'],
                          iconColor: const Color.fromARGB(255, 42, 238, 245),
                          w: w,
                        ),
                        IconAndTextWidget(
                          icon: Icons.aspect_ratio,
                          text: widget.pitch['size'],
                          iconColor: const Color.fromARGB(255, 11, 158, 23),
                          w: w,
                        ),
                        IconAndTextWidget(
                          icon: Icons.euro,
                          text: widget.pitch['price'],
                          iconColor: const Color.fromARGB(255, 7, 8, 7),
                          w: w,
                        )
                      ]),
                  SizedBox(height: h * 0.02),
                  Text("Specifiche",
                      style: TextStyle(
                          fontSize: w > 605
                              ? 30
                              : w > 385
                                  ? 24
                                  : 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: h * 0.02),
                  Text(
                    widget.pitch['description'],
                    style: TextStyle(
                        fontSize: w > 605
                            ? 22
                            : w > 385
                                ? 18
                                : 14,
                        color: Colors.black),
                  ),
                  SizedBox(height: h * 0.04),
                  widget.club['premium']
                      ? widget.pitch['sport'] == 'football'
                          ? Column(
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => AppointmentScreen(
                                            pitch: widget.pitch,
                                            daySelected: DateTime.now(),
                                          ));
                                    },
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      height: h * 0.18,
                                      width: w * 0.9,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/stadium_2.jpg'),
                                                  fit: BoxFit.fill)),
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(top: h * 0.06),
                                            child: Text('PRENOTA',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: w > 605 ? 45 : 30,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'oppure crea un match per cercare altri giocatori ma ricordati di prenotare il campo!',
                                  style: TextStyle(
                                      fontSize: w > 605
                                          ? 21
                                          : w > 385
                                              ? 17
                                              : 13,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => CreaMatch(
                                            pitch: widget.pitch,
                                            daySelected: DateTime.now(),
                                            club: widget.club,
                                            h: h,
                                            w: w,
                                          ));
                                    },
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      height: h * 0.18,
                                      width: w * 0.9,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/sfondo_crea_2.png'),
                                                  fit: BoxFit.fill)),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: w > 385 ? 60 : 30),
                                            child: const Text('CREA PARTITA',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Center(
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => AppointmentScreen(
                                        pitch: widget.pitch,
                                        daySelected: DateTime.now(),
                                      ));
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: h * 0.18,
                                  width: w * 0.9,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/sfondo_tennis.jpg'),
                                              fit: BoxFit.fill)),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: w > 385 ? 60 : 30),
                                        child: const Text('PRENOTA',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                      : Column(
                          children: [
                            Text(
                                'Questo Club non gestisce le prenotazioni tramite la nostra App.\nCrea una partita ma ricordati di prenotare il campo!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: w > 605
                                        ? 26
                                        : w > 385
                                            ? 20
                                            : 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => CreaMatch(
                                        pitch: widget.pitch,
                                        daySelected: DateTime.now(),
                                        club: widget.club,
                                        h: h,
                                        w: w,
                                      ));
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: h * 0.18,
                                  width: w * 0.9,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/sfondo_crea_2.png'),
                                              fit: BoxFit.fill)),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: w > 385 ? 60 : 30),
                                        child: const Text('CREA PARTITA',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                  const SizedBox(
                    height: 20,
                  )
                  //BookingButton(pitch: widget.pitch)),
                  //const SizedBox(height: 100),
                ],
              ))
        ],
      ),
    );
  }
}
