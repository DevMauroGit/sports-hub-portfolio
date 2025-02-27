import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/models/pitch_model.dart';

class PitchController extends GetxController {
  //final ClubModel club;
  final Map clubs;
  PitchController(
      //this.club,
      this.clubs);
  final allPitchImages = <String>[].obs;
  final allPitches = <PitchModel>[].obs;

  @override
  void onReady() {
    getAllPitches(clubs['admin mail']);
    //print('pitch: $allPitches');
    super.onReady();
  }

  Future<void> getAllPitches(club) async {
    //  List<String> imgName = ["campo4.jpg","campo7.jpg","campo8.jpg"];
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('Clubs')
          .doc('$club')
          .collection('pitches')
          .get();
      final pitchList =
          data.docs.map((pitches) => PitchModel.fromSnapshot(pitches)).toList();
      allPitches.assignAll(pitchList);

      for (var pitch in pitchList) {
        final imgURL =
            await Get.find<FirebaseStorageService>().getPitchImage(pitch.image);
        pitch.image = imgURL!; //control imgURL
      }
      allPitches.assignAll(pitchList);
    } catch (e) {}
  }
}
