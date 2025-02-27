import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/searching_page_2.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Search_Club/searched_club_carousel.dart';

class SearchingScreen2 extends StatefulWidget {
  const SearchingScreen2({super.key, required this.city, required this.ospite});

  final String city;
  final bool ospite;

  @override
  State<SearchingScreen2> createState() => _SearchingScreen2State();
}

ScrollController scrollController = ScrollController();

class _SearchingScreen2State extends State<SearchingScreen2> {
  var cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    final allClubs = <Map<String, dynamic>>[];

    //print(clubController.allClubs);
    return SingleChildScrollView(
        controller: scrollController,
        child: Container(
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          //height: h*0.8,
          width: w * 0.95,
          child: Column(children: [
            TextandSave(
              h: h,
              w: w,
              city: city,
              ospite: widget.ospite,
            ),
            const SizedBox(height: 20),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Clubs')
                    .where('city', isEqualTo: city)
                    .orderBy(
                      'id',
                    )
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
                      final clubList = snapshot.data!.docs.elementAt(i).data();
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 45,
                            vertical: w > 380 ? 45 : 20,
                          ),
                          decoration: const BoxDecoration(
                              color: kBackgroundColor2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            'Ci dispiace ma nessun campo della tua città è su Sports Hub\n\nInvitali ad entrare nella nostra Community!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: w > 380 ? 16 : 13,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )))
                      : SizedBox(
                          height: h * 0.8,
                          width: w * 0.75,
                          //color: kSecondaryColor,
                          child: SearchedClubCarousel(
                            clubs: allClubs,
                            ospite: widget.ospite,
                          ));
                })
          ]),
        ));
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
    return SizedBox(
        width: widget.w * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cerca i Clubs della tua Città o Provincia',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: widget.w > 380 ? 19 : 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  textStyle: const TextStyle(fontSize: 15),
                  shape: const StadiumBorder(),
                ),
                onPressed: () async {
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
            ),
          ],
        ));
  }
}
