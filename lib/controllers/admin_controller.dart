import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/firebase_references/references.dart';
import 'package:sports_hub_ios/models/club_models.dart';

/// Controller for managing admin-related club data
class AdminController extends GetxController {
  /// Observable list of clubs managed by the admin
  final adminClub = <ClubModel>[].obs;

  /// Called automatically when controller is ready
  @override
  void onReady() {
    getAdminClub();
    super.onReady();
  }

  /// Fetches the club(s) assigned to the current admin user
  Future<void> getAdminClub() async {
    String club = FirebaseAuth.instance.currentUser!.email.toString();

    try {
      // Query the database for clubs with matching admin email
      QuerySnapshot<Map<String, dynamic>> data =
          await clubsRF.where('admin mail', isEqualTo: club).get();

      // Convert documents into a ClubModel and update observable list
      final clubList =
          data.docs.map((clubs) => ClubModel.fromSnapshot(clubs)).first;

      adminClub.assign(clubList);
    } catch (e) {
      // You may want to log or handle this error in production
    }
  }
}
