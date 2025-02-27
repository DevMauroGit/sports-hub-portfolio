import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sports_hub_ios/controllers/pitch_controller.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Club/pitch_carousel.dart';
import 'package:sports_hub_ios/widgets/Crea_Match/crea_match.dart';

class ClubPageScreen extends StatefulWidget {
  const ClubPageScreen({
    super.key,
    required this.clubs,
    required this.ospite,
  });

  final Map clubs;
  final bool ospite;

  @override
  State<ClubPageScreen> createState() => _ClubPageScreenState();
}

class _ClubPageScreenState extends State<ClubPageScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  late PitchController pitchController;

  @override
  void initState() {
    setState(() {
      Get.delete<PitchController>();
      pitchController = Get.put(PitchController(widget.clubs));
      Get.lazyPut(() => FirebaseStorageService());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final allPitch = <Map<String, dynamic>>[];

    return SingleChildScrollView(
        child: Column(
      children: [
        Column(
          children: <Widget>[
            //Header(size: size),
            Container(
              //width: double.maxFinite,
              //height: MediaQuery.of(context).size.height/3,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: StreamBuilder(
                stream: null,
                builder: ((BuildContext context, AsyncSnapshot snapshot) {
                  Future.delayed(const Duration(seconds: 2));

                  if (snapshot.hasError) {
                    return Image.asset('assets/images/arena.jpg');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/arena.jpg'),
                              fit: BoxFit.fill),
                        ),
                        child: const CircularProgressIndicator());
                  }

                  return CachedNetworkImage(
                    imageUrl: widget.clubs['image'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: h * 0.01),
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.clubs['title'],
                          style: TextStyle(
                              fontSize: w > 605 ? 35 : 28,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                        widget.clubs['description'],
                        style: TextStyle(
                            fontSize: w > 605
                                ? 22
                                : w > 385
                                    ? 18
                                    : 14,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 30),
                      widget.clubs['premium']
                          ? Text('Campi',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: w > 605
                                      ? 28
                                      : w > 385
                                          ? 24
                                          : 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))
                          : Container(),
                    ])),
            //            Center(child: CalendarButton(model: widget.model)),
          ],
        ),
        widget.clubs['premium']
            ? Column(
                children: [
                  const SizedBox(height: 15),
                  SizedBox(
                    height: h > 700 ? h * 0.3 : h * 0.4,
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('Clubs')
                          .doc(widget.clubs['admin mail'])
                          .collection('pitches')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print('errore caricamento dati');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: h > 700 ? h * 0.25 : h * 0.3,
                            width: w,
                            decoration: BoxDecoration(
                                color: kBackgroundColor2.withOpacity(0.4)),
                            margin: const EdgeInsets.all(kDefaultPadding),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            final pitchList =
                                snapshot.data!.docs.elementAt(i).data();
                            //allClubs.assignAll(clubList);
                            //print(clubList);
                            allPitch.add(pitchList);
                          }
                        }

                        return Container(
                            height: h > 700 ? h * 0.25 : h * 0.3,
                            width: w,
                            decoration: BoxDecoration(
                                color: kBackgroundColor2.withOpacity(0.4)),
                            child: PitchCarousel(
                              pitch: pitchController,
                              clubs: allPitch,
                              club: widget.clubs,
                              ospite: widget.ospite,
                              h: h,
                              w: w,
                            ));
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Ci Trovi Qui!',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: w > 605
                              ? 28
                              : w > 385
                                  ? 24
                                  : 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: h > 700 ? 30 : 15),
                  StreamBuilder(
                    stream: null,
                    builder: ((BuildContext context, AsyncSnapshot snapshot) {
                      Future.delayed(const Duration(seconds: 2));

                      if (snapshot.hasError) {
                        return Image.asset('assets/images/arena.jpg');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/arena.jpg'),
                                  fit: BoxFit.fill),
                            ),
                            child: const CircularProgressIndicator());
                      }

                      return MaterialButton(
                        onPressed: () => openMapsSheet(context, widget.clubs),
                        child: CachedNetworkImage(
                          imageUrl: widget.clubs['image_maps'],
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Container(
                            height: 300,
                            alignment: Alignment.center,
                            child: Image.asset("assets/images/maps_logo.png"),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.clubs['address'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: w > 605
                            ? 20
                            : w > 385
                                ? 16
                                : 13,
                        color: Colors.black,
                        letterSpacing: 1),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/whatsapp.png",
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 5),
                      Text(widget.clubs['phone_number'].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: w > 605
                                  ? 22
                                  : w > 385
                                      ? 18
                                      : 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        'Questo Club non gestisce le prenotazioni tramite la nostra App.\nCrea una partita ma ricordati di prenotare il campo!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: w > 605
                                ? 26
                                : w > 385
                                    ? 20
                                    : 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (widget.ospite == true) {
                        } else {
                          final Map pitch = {
                            'club': widget.clubs['title'],
                            'title': 'Campo 1',
                            'teamSize': 5,
                            'sport': 'football',
                            'first_hour': 9,
                            'last_hour': 15
                          };

                          Get.to(() => CreaMatch(
                                pitch: pitch,
                                daySelected: DateTime.now(),
                                club: widget.clubs,
                                h: h,
                                w: w,
                              ));
                        }
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
                                top: w > 385 ? 50 : 30,
                              ),
                              child: Text('CREA PARTITA',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    backgroundColor:
                                        kBackgroundColor2.withOpacity(0.7),
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
      ],
    ));
  }
}

openMapsSheet(context, Map club) async {
  try {
    final coords = Coords(45.18598859644016, 9.177002655013458);
    final title = club['title'];
    final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showMarker(
                        coords: coords,
                        title: title,
                      ),
                      title: Text(map.mapName),
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  } catch (e) {
    print(e);
  }
}
