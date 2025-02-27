import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/searching_page_2.dart';
import 'package:sports_hub_ios/screen/home_page_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Search_Club/searched_club_carousel.dart';
import 'package:sports_hub_ios/widgets/available_game_card.dart';

class OspitePage extends StatefulWidget {
  const OspitePage(
      {super.key,
      required this.city,
      required this.h,
      required this.w,
      required this.page});

  final String city;
  final double h;
  final double w;
  final String page;

  @override
  State<OspitePage> createState() => _OspitePageState();
}

final formKey = GlobalKey<FormState>();

class _OspitePageState extends State<OspitePage> {
  var cityController = TextEditingController();
  var cityCreateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('OSPITE PAGE');

    final allClubs = <Map<String, dynamic>>[];

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            //resizeToAvoidBottomInset: false,
            appBar: TopBar(),
            body: Stack(children: [
              SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      //height: h*0.8,
                      width: widget.w * 0.95,
                      child: Column(children: [
                        SizedBox(
                          width: widget.w * 0.8,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Cerca i Clubs della tua Città o Provincia',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: widget.w > 380 ? 19 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                SizedBox(height: widget.h * 0.01),
                                TextFormField(
                                  inputFormatters: <TextInputFormatter>[
                                    UpperCaseTextFormatter()
                                  ],
                                  controller: cityController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: 'Città',
                                      prefixIcon: const Icon(
                                          Icons.location_city,
                                          color: kPrimaryColor),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0)),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      textStyle: const TextStyle(fontSize: 15),
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: () {
                                      city = cityController.text.trim();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) => OspitePage(
                                                  city: city,
                                                  h: widget.h,
                                                  w: widget.w,
                                                  page: 'clubs'))));
                                    },
                                    child: const Text(
                                      "Cerca",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                    width: widget.w * 0.8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Partite disponibili a ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize:
                                                    widget.w > 380 ? 19 : 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        SizedBox(height: widget.h * 0.01),
                                        TextFormField(
                                          inputFormatters: <TextInputFormatter>[
                                            UpperCaseTextFormatter()
                                          ],
                                          controller: cityCreateController,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              hintText: widget.city,
                                              prefixIcon: const Icon(
                                                  Icons.location_city,
                                                  color: kPrimaryColor),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 1.0)),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 1.0)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30))),
                                        ),
                                        const SizedBox(height: 20),
                                        Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kPrimaryColor,
                                              textStyle:
                                                  const TextStyle(fontSize: 15),
                                              shape: const StadiumBorder(),
                                            ),
                                            onPressed: () {
                                              cityCreate = cityCreateController
                                                  .text
                                                  .trim();

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          OspitePage(
                                                            city: cityCreate,
                                                            h: widget.h,
                                                            w: widget.w,
                                                            page: 'games',
                                                          ))));
                                            },
                                            child: const Text(
                                              "Cerca",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        widget.page == 'games'
                                            ? Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                height: widget.h * 0.6,
                                                child: FirebaseAnimatedList(
                                                    query: FirebaseDatabase
                                                            .instanceFor(
                                                                app: Firebase
                                                                    .app(),
                                                                databaseURL:
                                                                    dbCreaMatchURL)
                                                        .ref()
                                                        .child('Prenotazioni')
                                                        .child('Crea_Match')
                                                        .child(cityCreate == ''
                                                            ? widget.city
                                                            : cityCreate)
                                                        .child('football'),
                                                    itemBuilder: (BuildContext
                                                            context,
                                                        DataSnapshot snapshot,
                                                        Animation<double>
                                                            animation,
                                                        int index) {
                                                      Map appointment =
                                                          snapshot.value as Map;
                                                      appointment['key'] =
                                                          snapshot.key;

                                                      return AvailableGameCard(
                                                          appointment:
                                                              appointment,
                                                          h: widget.h,
                                                          w: widget.w,
                                                          context: context,
                                                          sport: 'football',
                                                          ospite: true);
                                                    }))
                                            : widget.page == 'clubs'
                                                ? FutureBuilder(
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection('Clubs')
                                                        .where('city',
                                                            isEqualTo: city)
                                                        .orderBy(
                                                          'id',
                                                        )
                                                        .get(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasError) {
                                                        print(
                                                            'errore caricamento dati');
                                                      } else if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Container(
                                                          margin: const EdgeInsets
                                                              .all(
                                                              kDefaultPadding),
                                                          child: const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        );
                                                      } else if (snapshot
                                                          .hasData) {
                                                        for (int i = 0;
                                                            i <
                                                                snapshot
                                                                    .data!
                                                                    .docs
                                                                    .length;
                                                            i++) {
                                                          final clubList =
                                                              snapshot
                                                                  .data!.docs
                                                                  .elementAt(i)
                                                                  .data();
                                                          //allClubs.assignAll(clubList);
                                                          //print(clubList);
                                                          allClubs
                                                              .add(clubList);
                                                        }
                                                        //print('has data ${allClubs}');
                                                      }

                                                      return allClubs.isEmpty
                                                          ? Container(
                                                              height: widget.h *
                                                                  0.4,
                                                              width: widget.w *
                                                                  0.75,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal: 45,
                                                                vertical:
                                                                    widget.w >
                                                                            380
                                                                        ? 45
                                                                        : 20,
                                                              ),
                                                              decoration: const BoxDecoration(
                                                                  color:
                                                                      kBackgroundColor2,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              child: Center(
                                                                  child: Text(
                                                                'Ci dispiace ma nessun campo della tua città è su Sports Hub\n\nInvitali ad entrare nella nostra Community!',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        widget.w > 380
                                                                            ? 16
                                                                            : 13,
                                                                    letterSpacing:
                                                                        0.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .white),
                                                              )))
                                                          : SizedBox(
                                                              height: widget.h *
                                                                  0.8,
                                                              width: widget.w *
                                                                  0.75,
                                                              //color: kSecondaryColor,
                                                              child:
                                                                  SearchedClubCarousel(
                                                                clubs: allClubs,
                                                                ospite: true,
                                                              ));
                                                    })
                                                : Container(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    )),
                              ]),
                        )
                      ])))
            ])));
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
