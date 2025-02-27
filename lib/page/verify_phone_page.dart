import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/verify_phone_number.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class VerifyPhonePage extends StatefulWidget {
  const VerifyPhonePage(
      {super.key, required this.h, required this.w, required this.size});

  final double h;
  final double w;
  final Size size;

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

String userSearched = FirebaseAuth.instance.currentUser!.email.toString();

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  Future getDocId() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    await FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              //print(document.reference);
              docIds.add(document.reference.id);
            }));
  }

  @override
  void initState() {
    getDocId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 355));

    getDocId();

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
                        appBar: TopBar(),
                        body: VerifyPhoneNumberPage(
                          profile: profile,
                          h: widget.h,
                          w: widget.w,
                          size: widget.size,
                        ));
                  }
                  return Container();
                })))));
  }
}
