import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/models/club_models.dart';
import 'package:sports_hub_ios/page/home_page.dart';

class PaviaController extends GetxController {
  final allClubImages = <String>[].obs;
  final allClubs = <ClubModel>[].obs;

  @override
  void onReady() {
    getAllClubsPavia();
    super.onReady();
  }

  Future<void> getAllClubsPavia() async {
    //  List<String> imgName = ["campo4.jpg","campo7.jpg","campo8.jpg"];
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('Clubs')
          .where('city', isEqualTo: 'Pavia')
          .get();
      print(city);
      final clubList =
          data.docs.map((clubs) => ClubModel.fromSnapshot(clubs)).toList();
      allClubs.assignAll(clubList);

      for (var club in clubList) {
        final imgURL =
            await Get.find<FirebaseStorageService>().getClubImage(club.image);
        club.image = imgURL!; //control imgURL
      }
      allClubs.assignAll(clubList);
    } catch (e) {}
  }
}
