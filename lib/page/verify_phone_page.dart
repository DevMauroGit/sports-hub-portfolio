import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/verify_phone_number.dart';
import 'package:sports_hub_ios/utils/constants.dart';

/// StatefulWidget that determines if the user's phone number needs to be verified
class VerifyPhonePage extends StatefulWidget {
  const VerifyPhonePage({
    super.key,
    required this.h,
    required this.w,
    required this.size,
  });

  final double h;
  final double w;
  final Size size;

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

/// Holds the current user's email
String userSearched = FirebaseAuth.instance.currentUser!.email.toString();

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  /// Stores document IDs found from Firestore query
  List<String> docIds = [];

  /// Fetches the Firestore document ID(s) of the current user by email
  Future getDocId() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    await FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIds.add(document.reference.id);
            }));
  }

  /// Initialize and load document ID(s) on widget mount
  @override
  void initState() {
    getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Slight delay to ensure smoother transition/loading
    Future.delayed(const Duration(milliseconds: 355));

    // Re-fetch document IDs (possibly for redundancy)
    getDocId();

    // Reference to the Firestore 'User' collection
    CollectionReference user = FirebaseFirestore.instance.collection('User');
    String email = FirebaseAuth.instance.currentUser!.email.toString();

    return PopScope(
      canPop: false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.2),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: user.doc(email).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Extract user data from Firestore snapshot
              Map<String, dynamic> profile =
                  snapshot.data!.data() as Map<String, dynamic>;

              // If data is loaded, return the phone verification page
              return Scaffold(
                appBar: TopBar(),
                body: VerifyPhoneNumberPage(
                  profile: profile,
                  h: widget.h,
                  w: widget.w,
                  size: widget.size,
                ),
              );
            }

            // Show empty container while loading
            return Container();
          },
        ),
      ),
    );
  }
}
