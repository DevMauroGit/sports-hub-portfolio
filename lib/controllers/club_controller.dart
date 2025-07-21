import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/models/club_models.dart';

class ClubController extends GetxController {
  final allClubImages = <String>[].obs;
  final allClubs = <ClubModel>[].obs;

  @override
  void onReady() {
    // Called when the controller is ready
    getAllClubs();
    super.onReady();
  }

  /// Fetch all clubs from Firestore and load their image URLs from Firebase Storage
  Future<void> getAllClubs() async {
    try {
      // Fetch data from Firestore collection 'Clubs'
      QuerySnapshot<Map<String, dynamic>> data =
          await FirebaseFirestore.instance.collection('Clubs').get();

      // Map documents to ClubModel list
      final clubList =
          data.docs.map((clubs) => ClubModel.fromSnapshot(clubs)).toList();
      allClubs.assignAll(clubList);
      print('allClubs: $allClubs');

      // Replace image field with actual download URL from Firebase Storage
      for (var club in clubList) {
        final imgURL =
            await Get.find<FirebaseStorageService>().getClubImage(club.image);
        club.image = imgURL!; // Assign URL to image field
      }

      // Update observable list with updated club data
      allClubs.assignAll(clubList);
    } catch (e) {
      // Handle any errors silently (could be improved with logging or user feedback)
    }
  }
}
