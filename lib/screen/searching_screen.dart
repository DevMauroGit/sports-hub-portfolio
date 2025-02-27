import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/searching_page_2.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Search_Club/searched_club_carousel.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({super.key, required this.city, required this.ospite});

  final String city;
  final bool ospite;

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

ScrollController scrollController = ScrollController();

class _SearchingScreenState extends State<SearchingScreen> {
  var cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    final allClubs = <Map<String, dynamic>>[];

    //print(clubController.allClubs);
    return Stack(children: [
      SingleChildScrollView(
          controller: scrollController,
          child: Container(
            margin: EdgeInsets.only(
                top: h * 0.03,
                bottom: h * 0.03,
                left: w * 0.02,
                right: h * 0.02),
            //height: h*0.8,
            width: w * 0.95,
            child: Column(children: [
              TextandSave(
                h: h,
                w: w,
                city: widget.city,
                ospite: widget.ospite,
              ),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Clubs')
                      .where('city', isEqualTo: widget.city)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print('errore caricamento dati');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        margin: const EdgeInsets.all(kDefaultPadding),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        final clubList =
                            snapshot.data!.docs.elementAt(i).data();
                        //allClubs.assignAll(clubList);
                        //print(clubList);
                        allClubs.add(clubList);
                      }
                      //print('has data ${allClubs}');
                    }

                    return allClubs.isEmpty
                        ? Container(
                            height: h * 0.4,
                            width: w * 0.75,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 45, vertical: 45),
                            decoration: const BoxDecoration(
                                color: kBackgroundColor2,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Center(
                                child: Text(
                              'Ci dispiace ma nessun campo della tua città è su Sports Hub\n\nInvitali ad entrare nella nostra Community!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )))
                        : Container(
                            height: h * 0.8,
                            width: w * 0.75,
                            //color: kSecondaryColor,
                            child: SearchedClubCarousel(
                              clubs: allClubs,
                              ospite: widget.ospite,
                            ));
                  })
            ]),
          ))
    ]);
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

class TextandSave extends StatefulWidget {
  const TextandSave({
    super.key,
    required this.h,
    required this.w,
    required this.city,
    required this.ospite,
  });

  final double h;
  final double w;
  final String city;
  final bool ospite;

  @override
  State<TextandSave> createState() => _TextandSaveState();
}

class _TextandSaveState extends State<TextandSave> {
  var cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.h * 0.20,
        width: widget.w * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cerca i Clubs della tua Città o Provincia',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            SizedBox(height: widget.h * 0.01),
            TextFormField(
              inputFormatters: <TextInputFormatter>[UpperCaseTextFormatter()],
              controller: cityController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: widget.city,
                  prefixIcon: const Icon(Icons.person, color: kPrimaryColor),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0)),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
            ElevatedButton(
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
                        builder: ((context) => SearchingPage2(
                              city: city,
                              ospite: widget.ospite,
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
          ],
        ));
  }
}
