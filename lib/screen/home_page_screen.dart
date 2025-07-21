// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sports_hub_ios/controllers/club_controller.dart';
import 'package:sports_hub_ios/cubit/auth_cubit.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/page/searching_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Club/club_carousel.dart';
import 'package:sports_hub_ios/widgets/app_tutorial.dart';
import 'package:sports_hub_ios/widgets/header.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({
    super.key,
    required this.user,
  });

  final Map user;

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

ScrollController scrollController = ScrollController();

class _HomePageScreenState extends State<HomePageScreen> {
  ClubController clubController = Get.put(ClubController());
  late Future<ClubController> dataFuture;

  @override
  void initState() {
    super.initState();

    dataFuture = getData();
  }

  Future<ClubController> getData() async {
    clubController = await Get.put(ClubController());
    Get.lazyPut(() => FirebaseStorageService());

    return clubController;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;

    print(w);
    print(h);
    print(DateTime.now());

    final allClubs = <Map<String, dynamic>>[];

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Header(
              size: size,
              phone: false,
              mail: false,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: w * 0.05, right: w * 0.05, top: h * 0.03),
                    child: Text("  Clubs",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: w > 605
                                ? 30
                                : w > 385
                                    ? 25
                                    : 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w800))),
              ],
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Clubs')
                  .where('city', isEqualTo: widget.user['city'])
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
                    height: h > 700 ? h * 0.23 : h * 0.32,
                    //width: w,
                    decoration: BoxDecoration(
                        color: kBackgroundColor2.withOpacity(0.4)),
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
                }

                return Container(
                    height: h > 700
                        ? h * 0.24
                        : h < 675
                            ? h * 0.3
                            : h * 0.32,
                    width: w,
                    decoration: BoxDecoration(
                        color: kBackgroundColor2.withOpacity(0.4)),
                    child: allClubs.isEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Center(
                                child: Text(
                              'Ci dispiace ma nessun campo nella tua città è su Sports Hub\n\nInvitali ad entrare nella nostra Community!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: w > 605
                                      ? 16
                                      : w > 385
                                          ? 14
                                          : 12,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w600),
                            )))
                        : ClubCarousel(
                            club: clubController,
                            clubs: allClubs,
                            ospite: false,
                          ));
              },
            ),
            SizedBox(height: h > 700 ? h * 0.02 : h * 0.025),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                          () => SearchingPage(
                                city: widget.user['city'],
                                h: h,
                                w: w,
                                ospite: false,
                              ),
                          transition: Transition.fadeIn);
                    },
                    child: Center(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: h * 0.12,
                        width: w * 0.35,
                        decoration: BoxDecoration(
                          color: kBackgroundColor2,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 15,
                                color: kPrimaryColor.withOpacity(0.5)),
                          ],
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Cerca partite e Clubs',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: w > 605
                                      ? 18
                                      : w > 385
                                          ? 14
                                          : 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go('/profile', extra: {
                        'docIds': widget.user['email'],
                              'avviso': false,
                              'sport': 'football'
                      });
                      
                    },
                    child: Center(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: h * 0.12,
                        width: w * 0.35,
                        decoration: BoxDecoration(
                          color: kBackgroundColor2,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 15,
                                color: kPrimaryColor.withOpacity(0.5)),
                          ],
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Vai al tuo Profilo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: w > 605
                                      ? 18
                                      : w > 385
                                          ? 14
                                          : 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h > 700 ? h * 0.03 : h * 0.03),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                  return AppTutorial(
                    h: h,
                    w: w,
                  );
                }));
              },
              child: Center(
                child: Container(
                  width: w * 0.8,
                  padding: EdgeInsets.all(h * 0.015),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 15,
                            color: kPrimaryColor.withOpacity(0.7)),
                      ],
                      color: kBackgroundColor2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  child: Text(
                    'HELP  CENTER / APP TUTORIAL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                      fontSize: w > 605
                          ? 18
                          : w > 385
                              ? 14
                              : 11,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: h > 700 ? h * 0.04 : h * 0.035),
          ]),
    );
  }
}

//cambiato future con streambuilder