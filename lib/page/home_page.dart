import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sports_hub_ios/controllers/profile_controller.dart';
import 'package:sports_hub_ios/models/user_model.dart';
import 'package:sports_hub_ios/notification_Service/notification_service.dart';
import 'package:sports_hub_ios/page/signup_page.dart';
import 'package:sports_hub_ios/screen/home_page_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/utils/drawer_head.dart';
import 'package:sports_hub_ios/utils/menu_items.dart';
import 'package:timezone/timezone.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String city = '';
String cityCreate = '';
String userSearched = FirebaseAuth.instance.currentUser!.email.toString();
List<String> docIds = [];
String mtoken = '';

class _HomePageState extends State<HomePage> {
  Future getDocId() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    await FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIds.add(document.reference.id);
            }));
  }

  Future updateInfo() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    final controller = Get.put(ProfileController());
    final snapshot = await FirebaseFirestore.instance
        .collection("User")
        .where('email', isEqualTo: email)
        .get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    final user = UserModel(
      id: userData.id,
      email: userData.email,
      phoneNumber: userData.phoneNumber,
      password: newPassword.length > 5 ? newPassword : userData.password,
      username: userData.username,
      city: userData.city,
      profile_pic: userData.profile_pic,
      cover_pic: userData.cover_pic,
      isEmailVerified: true,
      games: userData.games,
      goals: userData.goals,
      win: userData.win,
      games_tennis: userData.games_tennis,
      set_vinti: userData.set_vinti,
      win_tennis: userData.win_tennis,
      prenotazioni: userData.prenotazioni,
      prenotazioniPremium: userData.prenotazioniPremium,
      token: userData.token,
    );

    await controller.updateUser(user);
  }

  @override
  void initState() {
    requestPermission();
    getToken();
    getDocId();
    NotificationService().initNotification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedPage = iconList.elementAt(1);
    Future.delayed(const Duration(milliseconds: 355));

    getDocId();

    updateInfo();

    CollectionReference user = FirebaseFirestore.instance.collection('User');
    String email = FirebaseAuth.instance.currentUser!.email.toString();

    return PopScope(
        canPop: false,
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.2)),
            child: FutureBuilder<DocumentSnapshot>(
                future: user.doc(email).get(),
                builder: (((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> profile =
                        snapshot.data!.data() as Map<String, dynamic>;

                    return Scaffold(
                      appBar: TopBarHome(context),
                      bottomNavigationBar: BottomBar(
                        context,
                      ),
                      //drawer: const NavigationDrawer(),
                      body: HomePageScreen(user: profile),
                    );
                  }
                  return Container();
                })))));
  }
}

void getToken() async {
  await FirebaseMessaging.instance.getToken().then((token) {
    mtoken = token!;
    print('My token is $mtoken');

    saveToken(token);
  });
}

void saveToken(String token) async {
  await FirebaseFirestore.instance
      .collection('User')
      .doc(FirebaseAuth.instance.currentUser!.email.toString())
      .update({'token': token});
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permissions');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permissions');
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
