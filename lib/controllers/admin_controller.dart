import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/firebase_references/references.dart';
import 'package:sports_hub_ios/models/club_models.dart';

class AdminController extends GetxController {
  final adminClub = <ClubModel>[].obs;

  @override
  void onReady() {
    getAdminClub();
    super.onReady();
  }

  Future<void> getAdminClub() async {
    //  List<String> imgName = ["campo4.jpg","campo7.jpg","campo8.jpg"];
    String club = FirebaseAuth.instance.currentUser!.email.toString();
    try {
      QuerySnapshot<Map<String, dynamic>> data =
          await clubsRF.where('admin mail', isEqualTo: club).get();
      final clubList =
          data.docs.map((clubs) => ClubModel.fromSnapshot(clubs)).first;
      adminClub.assign(clubList);
    } catch (e) {}
  }
}
