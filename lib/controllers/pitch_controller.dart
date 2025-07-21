import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/models/pitch_model.dart';

class PitchController extends GetxController {
  // Map holding club information, including 'admin mail'
  final Map clubs;

  // Constructor receiving the club map
  PitchController(this.clubs);

  // Observable list for all pitch images URLs
  final allPitchImages = <String>[].obs;
  // Observable list for PitchModel objects
  final allPitches = <PitchModel>[].obs;

  @override
  void onReady() {
    // Fetch all pitches for the club identified by 'admin mail'
    getAllPitches(clubs['admin mail']);
    super.onReady();
  }

  /// Fetches all pitches from Firestore for the specified club
  Future<void> getAllPitches(club) async {
    try {
      // Query Firestore for pitches subcollection of the club document
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('Clubs')
          .doc('$club')
          .collection('pitches')
          .get();

      // Map documents to PitchModel list
      final pitchList =
          data.docs.map((pitches) => PitchModel.fromSnapshot(pitches)).toList();

      // Assign retrieved pitches to observable list
      allPitches.assignAll(pitchList);

      // For each pitch, fetch image URL from Firebase Storage service
      for (var pitch in pitchList) {
        final imgURL =
            await Get.find<FirebaseStorageService>().getPitchImage(pitch.image);
        pitch.image = imgURL!; // Update pitch image with the URL (non-null)
      }

      // Re-assign updated pitch list with image URLs
      allPitches.assignAll(pitchList);
    } catch (e) {
      // Handle errors if necessary
    }
  }
}
