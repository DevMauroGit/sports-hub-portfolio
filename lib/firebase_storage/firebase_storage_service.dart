import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Root Firebase Storage reference
Reference get firebaseStorage => FirebaseStorage.instance.ref();

class FirebaseStorageService extends GetxService {

  /// Returns the download URL for a club image given its name.
  Future<String?> getClubImage(String? imgName) async {
    if (imgName == null) return null;

    try {
      final urlRef = firebaseStorage
          .child("clubs")
          .child('${imgName.toLowerCase()}.jpg');
      final imgURL = await urlRef.getDownloadURL();
      return imgURL;
    } catch (e) {
      print('Error fetching club image: $e');
      return null;
    }
  }

  /// Returns the download URL for a pitch image given its name.
  /// Note: Currently points to the same storage path as clubs.
  Future<String?> getPitchImage(String? imgName) async {
    if (imgName == null) return null;

    try {
      final urlRef = firebaseStorage
          .child("clubs")
          .child('${imgName.toLowerCase()}.jpg');
      final imgURL = await urlRef.getDownloadURL();
      return imgURL;
    } catch (e) {
      print('Error fetching pitch image: $e');
      return null;
    }
  }

  /// Returns the download URL for a user profile image given its name.
  Future<String?> getUserImage(String? imgName) async {
    if (imgName == null) return null;

    try {
      final urlRef = firebaseStorage
          .child("users_images")
          .child('${imgName.toLowerCase()}.jpg');
      final imgURL = await urlRef.getDownloadURL();
      return imgURL;
    } catch (e) {
      print('Error fetching user image: $e');
      return null;
    }
  }
}
