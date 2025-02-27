import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sports_hub_ios/controllers/admin_controller.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/screen/admin_page_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/utils/drawer_head.dart';
import 'package:sports_hub_ios/utils/menu_items.dart';

class AdminPage extends StatefulWidget {
  final DateTime day;

  const AdminPage({super.key, required this.day});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

String city = '';
String userSearched = FirebaseAuth.instance.currentUser!.email.toString();
List<String> docIds = [];
String mtoken = '';

AdminController adminController = Get.put(AdminController());

class _AdminPageState extends State<AdminPage> {
  Future getDocId() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    await FirebaseFirestore.instance
        .collection('Clubs')
        .where('admin email', isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIds.add(document.reference.id);
            }));
  }

  @override
  void initState() {
    requestPermission();
    getToken();
    getDocId();
    getData();
    super.initState();
  }

  Future<AdminController> getData() async {
    adminController = await Get.put(AdminController());
    Get.lazyPut(() => FirebaseStorageService());

    return adminController;
  }

  @override
  Widget build(BuildContext context) {
    getDocId(); //  list1 = [];

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBarHome(context),
            //bottomNavigationBar: BottomBar(w, h, context,),
            //drawer: const NavigationDrawer(),
            body: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Clubs')
                  .doc(FirebaseAuth.instance.currentUser!.email.toString())
                  .get(),
              builder: (((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> club =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return AdminPageScreen(
                      adminClub: club, daySelected: widget.day);
                } else {
                  return Container();
                }
              })),
            )));
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: kBackgroundColor2,
      leading: Image.asset("assets/images/Sport_hub_logo_1.png"),
      title: const Text('SPORT HUB'),
    );
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

void getToken() async {
  await FirebaseMessaging.instance.getToken().then((token) {
    mtoken = token!;
    print('My token is $mtoken');

    saveToken(token);
  });
}

void saveToken(String token) async {
  await FirebaseFirestore.instance
      .collection('Clubs')
      .doc(FirebaseAuth.instance.currentUser!.email.toString())
      .update({'token': token});
}
