import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/page/friend_page.dart';
import 'package:sports_hub_ios/page/home_page.dart';

class MenuItems extends StatefulWidget {
  const MenuItems({
    super.key,
  });

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box_outlined),
            title: const Text('Amici'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => FriendsPage(
                        docIds: docIds.first,
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
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone_outlined),
            title: const Text('Contatti'),
            onTap: () {
              //             Navigator.of(context).pushReplacement(MaterialPageRoute(
              //               builder: (context) => const ContactPage()
              //               ));
            },
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Disconnettiti'),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
