import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';


Reference get firebaseStorage => FirebaseStorage.instance.ref();

class FirebaseStorageService extends GetxService{

  Future<String?> getClubImage(String? imgName) async {
    if (imgName == null) {
      return null;
    }
    try{
     var urlRef = firebaseStorage
     .child("clubs")
     .child('${imgName.toLowerCase()}.jpg');
     var imgURL = await urlRef.getDownloadURL();
     return imgURL;

    }catch (e) {
      print('immagine $e');
      return null;
    }
  }
  Future<String?> getPitchImage(String? imgName) async {
    if (imgName == null) {
      return null;
    }
    try{
     var urlRef = firebaseStorage
     .child("clubs")
     .child('${imgName.toLowerCase()}.jpg');
     var imgURL = await urlRef.getDownloadURL();
     return imgURL;

    }catch (e) {
      print(e);
      return null;
    }
  }
   Future<String?> getUserImage(String? imgName) async {
    if (imgName == null) {
      return null;
    }
    try{
     var urlRef = firebaseStorage
     .child("users_images")
     .child('${imgName.toLowerCase()}.jpg');
     var imgURL = await urlRef.getDownloadURL();
     return imgURL;

    }catch (e) {
      print(e);
      return null;
    }
  }
}