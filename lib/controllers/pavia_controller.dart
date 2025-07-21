import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/models/club_models.dart';
import 'package:sports_hub_ios/page/home_page.dart';

class PaviaController extends GetxController {
  // Observable list to hold club images URLs
  final allClubImages = <String>[].obs;
  // Observable list to hold ClubModel objects
  final allClubs = <ClubModel>[].obs;

  @override
  void onReady() {
    // Called when the controller is ready; fetch clubs for Pavia city
    getAllClubsPavia();
    super.onReady();
  }

  /// Fetch all clubs in the city of Pavia from Firestore
  Future<void> getAllClubsPavia() async {
    // Example list of image names (commented out)
    // List<String> imgName = ["campo4.jpg","campo7.jpg","campo8.jpg"];
    try {
      // Query Firestore collection 'Clubs' filtering by city = 'Pavia'
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('Clubs')
          .where('city', isEqualTo: 'Pavia')
          .get();

      

      // Map Firestore documents to ClubModel list
      final clubList =
          data.docs.map((clubs) => ClubModel.fromSnapshot(clubs)).toList();

      // Assign retrieved clubs to observable list
      allClubs.assignAll(clubList);

      // For each club, fetch image URL from Firebase Storage service
      for (var club in clubList) {
        final imgURL =
            await Get.find<FirebaseStorageService>().getClubImage(club.image);
        club.image = imgURL!; // Replace image field with URL (non-null asserted)
      }

      // Re-assign the updated club list with image URLs
      allClubs.assignAll(clubList);
    } catch (e) {
      // Handle or log error if needed
    }
  }
}
