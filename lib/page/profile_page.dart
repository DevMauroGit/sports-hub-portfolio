import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_close_app/flutter_close_app.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:sports_hub_ios/controllers/auth_controller.dart';
import 'package:sports_hub_ios/controllers/games_controller.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/page/edit_profile_page.dart';
import 'package:sports_hub_ios/page/football_management_page.dart';
import 'package:sports_hub_ios/page/friend_page.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/tennis_management_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/utils/drawer_head.dart';
import 'package:sports_hub_ios/utils/menu_items.dart';
import 'package:sports_hub_ios/widgets/stats_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key,
      required this.docIds,
      required this.avviso,
      required this.sport});

  final String docIds;
  final bool avviso;
  final String sport;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 240;
  final double profileHeight = 144;

  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String profile = docIds.first;
  CollectionReference user = FirebaseFirestore.instance.collection('User');

  @override
  Widget build(BuildContext context) {
    selectedPage = iconList.elementAt(2);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    userSearched = FirebaseAuth.instance.currentUser!.email.toString();

    //   list1 = [];

    UserController userController = Get.put(UserController());
    GameController gameController = Get.put(GameController());

    userController.allGames.clear;
    userController.allRequest.clear;
    gameController.allGames.clear();
    gameController.allTennisGames.clear();

    @override
    void initState() {
      userController.allRequest.clear();
      userController.getAllRequests();
      super.initState();
    }

    userController.getAllRequests();

    Future.delayed(const Duration(milliseconds: 100)).then(
      (value) => (widget.avviso == true)
          ? showDialog(
              barrierDismissible: false,
              useSafeArea: false,
              context: context,
              builder: (context) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.2)),
                  child: AlertDialog(
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.offAll(ProfilePage(
                                docIds: profile,
                                avviso: false,
                                sport: 'football'));
                            //Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontSize: w > 385 ? 25 : 23,
                              color: Colors.black,
                            ),
                          ))
                    ],
                    title: Text(
                      'Attenzione',
                      style: TextStyle(
                        fontSize: w > 605
                            ? 35
                            : w > 385
                                ? 28
                                : 25,
                        color: Colors.black,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(20),
                    content: Text(
                      'Stiamo caricando i tuoi dati sul server, per favore aspetta qualche minuto prima di confermare un altro risultato.',
                      style: TextStyle(
                        fontSize: w > 605
                            ? 30
                            : w > 385
                                ? 20
                                : 16,
                        color: Colors.black,
                      ),
                    ),
                  )))
          : Container(),
    );

    return PopScope(
        canPop: false,
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.2)),
            child: Scaffold(
                appBar: TopBarProfile(w),
                //endDrawer: FriendsIcon(),
                bottomNavigationBar: BottomBar(
                  context,
                ),
                body: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    buildTop(profile, widget.sport),
                    //buildContent(),
                    SizedBox(
                        height: w > 605
                            ? h * 0.08
                            : h > 700
                                ? h * 0.02
                                : h * 0.04),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 28),
                        GetUserName(documentId: profile),
                        const SizedBox(width: 10),
                        GestureDetector(
                            onTap: () {},
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfilePage(
                                              docIds: docIds.first)));
                                },
                                child: buildEditIcon(kBackgroundColor2, w)))
                      ],
                    )),
                    SizedBox(height: h * 0.01),
                    widget.sport == 'football'
                        ? buildFootballStatsWidget(profile)
                        : buildTennisStatsWidget(profile),
                    SizedBox(height: w > 385 ? h * 0.02 : h * 0.025),
                    Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: Text('Gestisci le tue partite ufficiali:',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: w > 605
                                  ? 25
                                  : w > 385
                                      ? 18
                                      : 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: w > 385 ? h * 0.02 : h * 0.025),

                    widget.sport == 'football'
                        ? buildGameManagement(h, w, profile, gameController)
                        : buildTennisGameManagement(
                            h, w, profile, gameController),

                    widget.sport == 'football'
                        ? SizedBox(height: w > 385 ? h * 0.02 : h * 0.025)
                        : Container(),
                    widget.sport == 'football'
                        ? Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: Text('Gestisci le tue partite create:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: w > 605
                                        ? 25
                                        : w > 385
                                            ? 18
                                            : 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          )
                        : Container(),
                    widget.sport == 'football'
                        ? SizedBox(height: w > 385 ? h * 0.02 : h * 0.025)
                        : Container(),

                    widget.sport == 'football'
                        ? buildCreateGameManagement(
                            h, w, profile, gameController)
                        : Container(),
                    //buildCreateTennisGameManagement(h, w, profile, gameController),

                    SizedBox(height: h * 0.03),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: w * 0.35),
                      child: AnimatedButton(
                        isFixedHeight: false,
                        height: h > 700 ? h * 0.03 : h * 0.05,
                        width: w * 0.1,
                        text: "LogOut",
                        buttonTextStyle: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.black,
                            fontSize: w > 605
                                ? 22
                                : w > 385
                                    ? 16
                                    : 12,
                            fontWeight: FontWeight.bold),
                        color: kPrimaryColor,
                        pressEvent: () {
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.topSlide,
                                  showCloseIcon: true,
                                  title: "Attento",
                                  titleTextStyle: TextStyle(
                                      fontSize: w > 605
                                          ? 35
                                          : w > 385
                                              ? 30
                                              : 25,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                  desc: "Sei sicuro di voler uscire?",
                                  descTextStyle: TextStyle(
                                      fontSize: w > 605
                                          ? 30
                                          : w > 385
                                              ? 20
                                              : 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                  btnOkOnPress: () async {
                                    FirebaseAuth.instance.signOut();
                                    //                FlutterExitApp.exitApp(iosForceExit: true);
                                    Future.delayed(
                                            const Duration(milliseconds: 355))
                                        .then((value) => FlutterCloseApp.close()
                                            //SystemNavigator.pop()
                                            );
                                  },
                                  btnOkIcon: Icons.thumb_up,
                                  btnOkText: "DISCONNETTITI",
                                  btnOkColor: kBackgroundColor2)
                              .show();
                        },
                      ),
                    ),
                    SizedBox(
                      height: w > 435 ? h * 0.01 : h * 0.02,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        FutureBuilder<DocumentSnapshot>(
                            future: user.doc(profile).get(),
                            builder: (((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> profile = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                return GestureDetector(
                                  onTap: () {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            animType: AnimType.topSlide,
                                            showCloseIcon: true,
                                            title: "Attento",
                                            titleTextStyle: TextStyle(
                                                fontSize: w > 385 ? 30 : 25,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                            desc:
                                                "Sei sicuro di voler richiedere l'eliminazione del tuo account? Richiederà qualche giorno",
                                            descTextStyle: TextStyle(
                                                fontSize: w > 385 ? 20 : 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                            btnOkOnPress: () async {
                                              await FirebaseAuth
                                                  .instance.currentUser!
                                                  .reauthenticateWithCredential(
                                                      EmailAuthProvider
                                                          .credential(
                                                              email: profile[
                                                                  'email'],
                                                              password: profile[
                                                                  'password']))
                                                  .then((value) async =>
                                                      //deleteUserAccount()
                                                      await AuthController
                                                          .instance
                                                          .createDeleteRequest(
                                                              profile))
                                                  .then((value) => FirebaseAuth
                                                      .instance
                                                      .signOut())
                                                  .then((value) =>
                                                      FlutterCloseApp.close());
                                            },
                                            btnOkIcon: Icons.thumb_up,
                                            btnOkText: "ELIMINA ACCOUNT",
                                            btnOkColor: kBackgroundColor2)
                                        .show();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "Elimina Account",
                                      style: TextStyle(
                                        letterSpacing: 0.5,
                                        color: Colors.grey,
                                        fontSize: w > 385 ? 11 : 9,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            })))
                      ],
                    ),
                    SizedBox(
                      height: w > 435 ? h * 0.01 : h * 0.02,
                    )
                  ],
                ))));
  }

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      print(e);

      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      print(e);

      // Handle general exception
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }

  Stack buildTop(String profile, String sport) {
    final bottom = profileHeight / 2;

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
            top: h * 0.27,
            left: w * 0.05,
            child: Container(
              width: w * 0.12,
              height: h * 0.06,
              decoration: const BoxDecoration(
                  color: kBackgroundColor2,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                children: [
                  SizedBox(height: h * 0.01),
                  Container(
                      decoration: BoxDecoration(
                          color: sport == 'football'
                              ? kPrimaryColor
                              : Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: GestureDetector(
                          onTap: () {
                            context.go('/profile', extra: {
                              'docIds': widget.docIds,
                              'avviso': false,
                              'sport': 'football'
                            });
                          },
                          child: Icon(
                            Icons.sports_soccer,
                            size: h * 0.04,
                          ))),
                ],
              ),
            )),
        Positioned(
            top: h * 0.27,
            right: w * 0.05,
            child: Container(
              width: w * 0.12,
              height: h * 0.06,
              decoration: const BoxDecoration(
                  color: kBackgroundColor2,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                children: [
                  SizedBox(height: h * 0.01),

                  GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onTap: () {
                        context.go('/profile', extra: {
                          'docIds': widget.docIds,
                          'avviso': false,
                          'sport': 'tennis'
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: sport == 'tennis'
                                  ? kPrimaryColor
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Icon(Icons.sports_tennis, size: h * 0.04))),
                  //  SizedBox(height: h*0.01),
                  //Icon(Icons.sports_basketball, size: h*0.04)
                ],
              ),
            )),
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: buildCoverImage(h, w)),
        Positioned(top: h * 0.17, child: buildProfileImage(profile, w)),
      ],
    );
  }

  Widget buildCoverImage(double h, double w) => FutureBuilder<DocumentSnapshot>(
      future: user.doc(profile).get(),
      builder: (((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> profile =
              snapshot.data!.data() as Map<String, dynamic>;

          String cover_pic = '';

          if (profile['profile_pic'] == null) {
            cover_pic =
                'https://firebasestorage.googleapis.com/v0/b/sports-hub-2710.appspot.com/o/utility_images%2Fstadium_black.jpg?alt=media&token=ac177528-62f5-4c35-a823-78d106364583';
          } else {
            cover_pic = profile['cover_pic'];
          }
          return CachedNetworkImage(
            imageUrl: cover_pic,
            imageBuilder: (context, imageProvider) => Container(
              color: Colors.grey,
              child: Image(
                image: imageProvider,
                width: double.infinity,
                height: h * 0.25,
                fit: BoxFit.cover,
              ),
            ),
          );
        }
        return Container(
          color: Colors.grey,
          child: Image(
            image: const AssetImage('assets/images/stadium_black.jpg'),
            width: double.infinity,
            height: h * 0.25,
            fit: BoxFit.cover,
          ),
        );
      })));

  Widget buildProfileImage(String profile, double w) =>
      FutureBuilder<DocumentSnapshot>(
          future: user.doc(profile).get(),
          builder: (((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> profile =
                  snapshot.data!.data() as Map<String, dynamic>;

              String profile_pic = '';

              if (profile['profile_pic'] == null) {
                profile_pic =
                    'https://firebasestorage.googleapis.com/v0/b/sports-hub-2710.appspot.com/o/utility_images%2Ffootballer.png?alt=media&token=9339bbc1-047c-4309-9509-9d643554daca';
              } else {
                profile_pic = profile['profile_pic'];
              }
              return Container(
                  height: w > 605 ? 250 : 150,
                  width: w > 605 ? 250 : 150,
                  decoration: const BoxDecoration(
                      color: kPrimaryColor, shape: BoxShape.circle),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: profile_pic,
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ));
            }
            return Container(
              color: kPrimaryColor,
              height: w > 605 ? 250 : 150,
              width: w > 605 ? 250 : 150,
              child: const ClipOval(
                child: Image(
                  image: AssetImage('assets/images/footballer.png'),
                  fit: BoxFit.contain,
                ),
              ),
            );
          })));

  Widget buildEditIcon(Color color, double w) => CircleAvatar(
        radius: w > 605 ? 20 : 10,
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.edit,
          size: w > 605 ? 30 : 15,
          color: color,
        ),
      );

  Widget buildGameManagement(h, w, profile, gameController) => GestureDetector(
        onTap: () {
          Get.to(
              () => FootballManagementPage(
                  profile: profile, gameController: gameController),
              transition: Transition.fadeIn);
        },
        child: Center(
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: h * 0.18,
            width: w * 0.9,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(color: kBackgroundColor2, blurRadius: 5)
                ]),
            child: ClipRRect(
              child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/sfondo_football_2.png'),
                          fit: BoxFit.fill))),
            ),
          ),
        ),
      );

  Widget buildTennisGameManagement(h, w, profile, gameController) =>
      GestureDetector(
        onTap: () {
          Get.to(
              () => TennisManagementPage(
                  profile: profile, gameController: gameController),
              transition: Transition.fadeIn);
        },
        child: Center(
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: h * 0.18,
            width: w * 0.9,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(color: kBackgroundColor2, blurRadius: 5)
                ]),
            child: ClipRRect(
              child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/sfondo_tennis_1.png'),
                          fit: BoxFit.fill))),
            ),
          ),
        ),
      );

  Widget buildCreateGameManagement(h, w, profile, gameController) =>
      GestureDetector(
        onTap: () {
          context.go('/create-management',
              extra: {'profile': profile, 'gameController': gameController});
        },
        child: Center(
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: h * 0.18,
            width: w * 0.9,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(color: kBackgroundColor2, blurRadius: 5)
                ]),
            child: ClipRRect(
              child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/sfondo_crea_2.png'),
                          fit: BoxFit.cover))),
            ),
          ),
        ),
      );

  // Builds the "Create Tennis Game" button with a background image and navigation to the creation page.
  Widget buildCreateTennisGameManagement(h, w, profile, gameController) =>
      GestureDetector(
        onTap: () {
          Get.to(
              () => TennisCreateManagementPage(
                  profile: profile, gameController: gameController),
              transition: Transition.fadeIn);
        },
        child: Center(
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: h * 0.18,
            width: w * 0.9,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(color: kBackgroundColor2, blurRadius: 5)
                ]),
            child: ClipRRect(
              child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/sfondo_tennis_1.png'),
                          fit: BoxFit.fill))),
            ),
          ),
        ),
      );

// Loads and displays football statistics using Firestore data.
  Widget buildFootballStatsWidget(String profile) =>
      FutureBuilder<DocumentSnapshot>(
          future: user.doc(profile).get(),
          builder: (((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> profile =
                  snapshot.data!.data() as Map<String, dynamic>;
              return FootballStatsWidget(
                profile: profile,
                visit: false,
              );
            }
            return Container(
              height: 24,
            );
          })));

// Loads and displays tennis statistics using Firestore data.
  Widget buildTennisStatsWidget(String profile) =>
      FutureBuilder<DocumentSnapshot>(
          future: user.doc(profile).get(),
          builder: (((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> profile =
                  snapshot.data!.data() as Map<String, dynamic>;
              return TennisStatsWidget(
                profile: profile,
                visit: false,
              );
            }
            return Container(
              height: 24,
            );
          })));
}

// Displays the user's username fetched from Firestore with responsive text style.
class GetUserName extends StatelessWidget {
  final String documentId;

  const GetUserName({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    CollectionReference user = FirebaseFirestore.instance.collection('User');

    return FutureBuilder<DocumentSnapshot>(
        future: user.doc(documentId).get(),
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> profile =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text(
              profile['username'],
              style: TextStyle(
                  letterSpacing: 2,
                  fontSize: w > 605
                      ? 35
                      : w > 385
                          ? 30
                          : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            );
          }
          return Text('loading',
              style: TextStyle(
                  fontSize: w > 605
                      ? 35
                      : w > 385
                          ? 30
                          : 25,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold));
        })));
  }
}

// Basic navigation drawer layout containing the header and menu items.
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHead(),
            MenuItems(),
          ],
        ),
      ),
    );
  }
}

// Icon that navigates to the Friends page with filtered Firestore friend data.
class FriendsIcon extends StatelessWidget {
  const FriendsIcon({
    super.key,
    required this.profile,
  });

  final String profile;

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Get.to(
            () => FriendsPage(
                  docIds: profile,
                  h: h,
                  w: w,
                  future: FirebaseFirestore.instance
                      .collection('User')
                      .doc(email)
                      .collection('Friends')
                      .where('isRequested', isEqualTo: 'false')
                      .get(),
                ),
            transition: Transition.upToDown);
      },
      child: const Icon(
        Icons.people_rounded,
        color: kPrimaryColor,
      ),
    );
  }
}

// Icon that navigates directly to the user's football profile page.
class FriendsIcon2 extends StatelessWidget {
  const FriendsIcon2({
    super.key,
    required this.profile,
  });

  final String profile;

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    return GestureDetector(
      onTap: () {
        Get.to(
            () => ProfilePage(docIds: email, avviso: false, sport: 'football'),
            transition: Transition.downToUp);
      },
      child: const Icon(
        Icons.people_rounded,
        color: Colors.black,
      ),
    );
  }
}
