import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/models/friend_model.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/utils/drawer_head.dart';
import 'package:sports_hub_ios/utils/menu_items.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';
import 'package:sports_hub_ios/widgets/stats_widget.dart';

class VisitProfilePage extends StatefulWidget {
  const VisitProfilePage(
      {super.key, required this.userFriend, required this.showRequest});

  final String userFriend;
  final bool showRequest;

  @override
  State<VisitProfilePage> createState() => _VisitProfilePageState();
}

class _VisitProfilePageState extends State<VisitProfilePage> {
  final double coverHeight = 250;
  final double profileHeight = 144;

  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String profile = docIds.first;
  CollectionReference user = FirebaseFirestore.instance.collection('User');
  late FriendModel thisUser;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 200));
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    final controller = Get.put(UserController());

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBar(),
            //endDrawer: NavigationDrawer(),
            bottomNavigationBar: BottomBar(
              context,
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      buildTop(widget.userFriend),
                      //buildContent(),
                      SizedBox(
                          height: w > 605
                              ? h * 0.08
                              : h > 700
                                  ? h * 0.02
                                  : h * 0.05),
                      Center(child: GetUserName(documentId: widget.userFriend)),
                      SizedBox(height: h * 0.02),
                      Container(
                        width: w * 0.85,
                        decoration: const BoxDecoration(
                            color: kBackgroundColor2,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(color: kBackgroundColor2, blurRadius: 5)
                            ]),
                        child: Column(
                          children: [
                            SizedBox(height: h * 0.02),
                            buildFootballStatsWidget(widget.userFriend),
                            SizedBox(height: h * 0.02),
                            buildTennisStatsWidget(widget.userFriend),
                            SizedBox(height: h * 0.02),
                          ],
                        ),
                      ),

                      SizedBox(height: h * 0.03),
                      Center(
                        child: Text('Invia richiesta di amicizia:',
                            style: TextStyle(
                                fontSize: w > 605
                                    ? 30
                                    : w > 385
                                        ? 18
                                        : 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: h * 0.03),

                      FutureBuilder(
                          future: user.doc(email).get(),
                          builder: (((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> profile =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              FriendModel onUser = FriendModel(
                                  username: profile['username'],
                                  id: profile['id'],
                                  email: profile['email'],
                                  password: profile['password'],
                                  profile_pic: profile['profile_pic'],
                                  cover_pic: profile['cover_pic'],
                                  isEmailVerified: profile['isEmailVerified'],
                                  isRequested: "true",
                                  games: profile['games'],
                                  goals: profile['goals'],
                                  win: profile['win'],
                                  games_tennis: profile['games_tennis'],
                                  set_vinti: profile['set_vinti'],
                                  win_tennis: profile['win_tennis'],
                                  token: profile['token']);

                              thisUser = onUser;
                            }
                            return Container();
                          }))),

                      widget.showRequest == true
                          ? FutureBuilder<DocumentSnapshot>(
                              future: user.doc(widget.userFriend).get(),
                              builder: (((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> profile = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  return AnimatedButton(
                                    isFixedHeight: false,
                                    height: h * 0.06,
                                    width: w * 0.5,
                                    text: "AGGIUNGI AGLI AMICI",
                                    buttonTextStyle: TextStyle(
                                        letterSpacing: 0.5,
                                        color: Colors.black,
                                        fontSize: w > 605
                                            ? 40
                                            : w > 605
                                                ? 30
                                                : 16,
                                        fontWeight: FontWeight.bold),
                                    color: kPrimaryColor,
                                    pressEvent: () {
                                      AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.success,
                                              animType: AnimType.topSlide,
                                              showCloseIcon: true,
                                              title: "Richiedi amicizia",
                                              titleTextStyle: TextStyle(
                                                  fontSize: w > 605
                                                      ? 40
                                                      : w > 385
                                                          ? 30
                                                          : 25,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                              desc:
                                                  "Diventando amici potrete aggiungervi come giocatori nelle vostre partite",
                                              descTextStyle: TextStyle(
                                                  fontSize: w > 605
                                                      ? 30
                                                      : w > 385
                                                          ? 20
                                                          : 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                              btnOkOnPress: () async {
                                                Navigator.of(context).push(
                                                    HeroDialogRoute(
                                                        builder: (context) {
                                                  return const LoadingScreen();
                                                }));

                                                if (profile['isRequested'] !=
                                                    'false') {
                                                  FriendModel userFriend =
                                                      FriendModel(
                                                          username: profile[
                                                              'username'],
                                                          id: profile['id'],
                                                          email:
                                                              profile['email'],
                                                          password: profile[
                                                              'password'],
                                                          profile_pic: profile[
                                                              'profile_pic'],
                                                          cover_pic: profile[
                                                              'cover_pic'],
                                                          isEmailVerified: profile[
                                                              'isEmailVerified'],
                                                          isRequested: 'no',
                                                          games:
                                                              profile['games'],
                                                          goals:
                                                              profile['goals'],
                                                          win: profile['win'],
                                                          games_tennis: profile[
                                                              'games_tennis'],
                                                          set_vinti: profile[
                                                              'set_vinti'],
                                                          win_tennis: profile[
                                                              'win_tennis'],
                                                          token:
                                                              profile['token']);
                                                  controller.updateUserFriends(
                                                      thisUser, userFriend);
                                                  Future.delayed(const Duration(
                                                      seconds: 1));
                                                }
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePage(
                                                              docIds: email,
                                                              avviso: false,
                                                              sport: 'football',
                                                            )));

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfilePage(
                                                              docIds: email,
                                                              avviso: false,
                                                              sport: 'football',
                                                            )));
                                              },
                                              btnOkIcon: Icons.thumb_up,
                                              btnOkText: "CONFERMA",
                                              btnOkColor: kBackgroundColor2)
                                          .show();
                                    },
                                  );
                                }
                                return Container();
                              })))
                          : Center(
                              child: Text(
                              'Siete già amici',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: w > 605
                                      ? 30
                                      : w > 385
                                          ? 18
                                          : 16,
                                  fontWeight: FontWeight.w400),
                            )),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  )),
            )));
  }

  Stack buildTop(String profile) {
    final bottom = profileHeight / 2;

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: buildCoverImage(profile, h, w)),
        Positioned(top: h * 0.17, child: buildProfileImage(profile, w)),
      ],
    );
  }

  Widget buildCoverImage(String profile, double h, double w) =>
      FutureBuilder<DocumentSnapshot>(
          future: user.doc(profile).get(),
          builder: (((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> profile =
                  snapshot.data!.data() as Map<String, dynamic>;
              return CachedNetworkImage(
                  imageUrl: profile['cover_pic'],
                  imageBuilder: (context, imageProvider) => Container(
                        color: Colors.grey,
                        child: Image(
                          image: imageProvider,
                          width: double.infinity,
                          height: h * 0.25,
                          fit: BoxFit.cover,
                        ),
                      ));
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
              return SizedBox(
                height: w > 605 ? 250 : 150,
                width: w > 605 ? 250 : 150,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: profile['profile_pic'],
                    imageBuilder: (context, imageProvider) => Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
            return Container(
              color: kPrimaryColor,
              height: w > 605 ? 300 : 150,
              width: w > 605 ? 300 : 150,
              child: const ClipOval(
                child: Image(
                  image: AssetImage('assets/images/footballer.png'),
                  fit: BoxFit.contain,
                ),
              ),
            );
          })));

  Widget buildFootballStatsWidget(String profile) =>
      FutureBuilder<DocumentSnapshot>(
          future: user.doc(profile).get(),
          builder: (((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> profile =
                  snapshot.data!.data() as Map<String, dynamic>;
              return FootballStatsWidget(
                profile: profile,
                visit: true,
              );
            }
            return Container(
              height: 24,
            );
          })));

  Widget buildTennisStatsWidget(String profile) =>
      FutureBuilder<DocumentSnapshot>(
          future: user.doc(profile).get(),
          builder: (((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> profile =
                  snapshot.data!.data() as Map<String, dynamic>;
              return TennisStatsWidget(
                profile: profile,
                visit: true,
              );
            }
            return Container(
              height: 24,
            );
          })));
}

class GetUserName extends StatelessWidget {
  final String documentId;

  const GetUserName({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('User');
    //double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

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
                      ? 40
                      : w > 385
                          ? 30
                          : 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            );
          }
          return const Text('loading');
        })));
  }
}

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
