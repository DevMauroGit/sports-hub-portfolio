import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/page/friend_page.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/page/searching_page.dart';
import 'package:sports_hub_ios/utils/app_icon.dart';
import 'package:sports_hub_ios/utils/drawer_head.dart';
import 'package:sports_hub_ios/utils/menu_items.dart';

const kPrimaryColor = Color.fromARGB(255, 91, 222, 226);

const kTextColor = Color.fromARGB(0, 226, 110, 32);
const kBackgroundColor = Colors.white;
const kBackgroundColor2 = Color.fromARGB(255, 62, 65, 64);
final kSecondaryColor = kBackgroundColor2.withOpacity(0.5);
const double kDefaultPadding = 20.0;

final double hc = 0;

String dbPrenotazioniURL =
    'https://sports-hub-2710-db-prenotazioni.europe-west1.firebasedatabase.app/';

String dbCreaMatchURL =
    'https://sports-hub-crea-match-db.europe-west1.firebasedatabase.app/';

List<AppIcon> iconList = [
  AppIcon(
      icon: Icons.search, backgroundColor: kBackgroundColor2.withOpacity(1)),
  AppIcon(icon: Icons.home, backgroundColor: kBackgroundColor2.withOpacity(1)),
  AppIcon(icon: Icons.man_2, backgroundColor: kBackgroundColor2.withOpacity(1))
];

var selectedPage = iconList.elementAt(1);

Widget BottomBar(
  BuildContext context,
) {
  double w = MediaQuery.of(context).size.width;
  double h = MediaQuery.of(context).size.height;
  return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('User').doc(docIds.first).get(),
      builder: (((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> profile =
              snapshot.data!.data() as Map<String, dynamic>;

          return Container(
            decoration: BoxDecoration(color: kBackgroundColor2.withOpacity(1)),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: w * 0.1, vertical: h * 0.01),
              margin: EdgeInsets.only(
                  left: w * 0.10,
                  right: w * 0.10,
                  bottom: h * 0.01,
                  top: h * 0.01),
              decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.6),
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...List.generate(
                    iconList.length,
                    (index) => GestureDetector(
                      onTap: () {
                        Future.delayed(const Duration(seconds: 1), () {
                          if (iconList[index] == iconList.elementAt(0)) {
                            Get.to(
                                () => SearchingPage(
                                      city: profile['city'],
                                      h: h,
                                      w: w,
                                      ospite: false,
                                    ),
                                transition: Transition.fadeIn);
                            selectedPage = iconList.elementAt(0);
                            //list1 = [];
                          }
                        });
                        Future.delayed(const Duration(seconds: 1), () {
                          if (iconList[index] == iconList.elementAt(1)) {
                            Get.to(() => const HomePage(),
                                transition: Transition.fadeIn);
                            selectedPage = iconList.elementAt(1);
                            //list1 = [];
                          }
                        });
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (iconList[index] == iconList.elementAt(2)) {
                            Get.to(
                                () => ProfilePage(
                                      docIds: docIds.first,
                                      avviso: false,
                                      sport: 'football',
                                    ),
                                transition: Transition.fadeIn);
                            selectedPage = iconList.elementAt(2);
                            //list1 = [];
                          }
                        });
                      },
                      child: SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                              opacity:
                                  iconList[index] == selectedPage ? 1 : 0.5,
                              child: iconList[index])),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return Container();
      })));
}

AppBar TopBar() {
  return AppBar(
      backgroundColor: kBackgroundColor2,
      leading: Container(
          margin: const EdgeInsets.only(bottom: 5, top: 5, left: 10),
          child: Image.asset(
            "assets/images/Sport_hub_logo_1.png",
          )),
      title: const Text(
        'SPORTS HUB',
        style: TextStyle(
            color: kBackgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontStyle: FontStyle.italic),
      ),
      bottomOpacity: 0);
}

AppBar TopBarFriends(context) {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  Size size = MediaQuery.of(context).size;
  double h = size.height;
  double w = size.width;
  return AppBar(
      backgroundColor: kBackgroundColor2,
      leading: Container(
          margin: const EdgeInsets.only(bottom: 5, top: 5, left: 10),
          child: Image.asset(
            "assets/images/Sport_hub_logo_1.png",
          )),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(1),
            child: Text(
              w > 380 ? 'SPORTS HUB' : 'SPORTS HUB',
              style: TextStyle(
                  color: kBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: w > 380 ? 25 : 23,
                  fontStyle: FontStyle.italic),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendsPage(
                            docIds: email,
                            h: h,
                            w: w,
                            future: FirebaseFirestore.instance
                                .collection('User')
                                .doc(email)
                                .collection('Friends')
                                .where('isRequested', isEqualTo: 'false')
                                .get(),
                          )));
            },
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: FriendsIcon2(profile: email)),
          )
        ],
      ),
      bottomOpacity: 0);
}

AppBar TopBarGames(w) {
  //String email = FirebaseAuth.instance.currentUser!.email.toString();
  return AppBar(
      backgroundColor: kBackgroundColor2,
      leading: Container(
          margin: const EdgeInsets.only(bottom: 5, top: 5, left: 10),
          child: Image.asset(
            "assets/images/Sport_hub_logo_1.png",
          )),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(1),
            child: Text(
              w > 380 ? 'SPORTS HUB                 ' : 'SPORTS HUB       ',
              style: TextStyle(
                  color: kBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: w > 380 ? 25 : 23,
                  fontStyle: FontStyle.italic),
            ),
          ),

          ///GestureDetector(
          // onTap: () {
          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>GamesManagementPage(profile: email, userController: userController, gameController: gameController,)));
          //},
          //child: Icon(Icons.replay_outlined),
          //  )
        ],
      ),
      bottomOpacity: 0);
}

AppBar TopBarTennisGames(context, gameController, w) {
  return AppBar(
      backgroundColor: kBackgroundColor2,
      leading: Container(
          margin: const EdgeInsets.only(bottom: 5, top: 5, left: 10),
          child: Image.asset(
            "assets/images/Sport_hub_logo_1.png",
          )),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(1),
            child: Text(
              w > 380 ? 'SPORTS HUB                 ' : 'SPORTS HUB       ',
              style: TextStyle(
                  color: kBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: w > 380 ? 25 : 23,
                  fontStyle: FontStyle.italic),
            ),
          ),
          //    GestureDetector(
          //    onTap: () {
          //          Navigator.push(
          //            context,
          //                MaterialPageRoute(
          //        builder: (context) => TennisManagementPage(
          //                    profile: email,
          //                  gameController: gameController,
          //              )));
          //    },
          //  child: const Icon(Icons.replay_outlined),
          //   )
        ],
      ),
      bottomOpacity: 0);
}

AppBar TopBarProfile(double w) {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  return AppBar(
      elevation: 0,
      backgroundColor: kBackgroundColor2,
      leading: Container(
          margin: const EdgeInsets.only(bottom: 5, top: 5, left: 10),
          child: Image.asset(
            "assets/images/Sport_hub_logo_1.png",
          )),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(1),
            child: Text(
              w > 380 ? 'SPORTS HUB               ' : 'SPORTS HUB       ',
              style: TextStyle(
                  color: kBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: w > 380 ? 25 : 23,
                  fontStyle: FontStyle.italic),
            ),
          ),
          FriendsIcon(profile: email)
        ],
      ),
      bottomOpacity: 0);
}

AppBar TopBarHome(
  BuildContext context,
) {
  return AppBar(
      leading: Container(),
      backgroundColor: kBackgroundColor2,
      bottomOpacity: 0);
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
