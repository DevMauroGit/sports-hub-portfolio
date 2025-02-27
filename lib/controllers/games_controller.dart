import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/models/game_model.dart';
import 'package:sports_hub_ios/models/tennis_game_model.dart';
import 'package:sports_hub_ios/models/user_model.dart';

class GameController extends GetxController {
  static GameController get instance => Get.find();

  var allGames = <GameModel>[].obs;
  var allTennisGames = <TennisGameModel>[].obs;

  final lista = <UserModel>[];

  @override
  void onReady() {
    getAllGames();
    getAllTennisGames();
    super.onReady();
  }

  Future<void> getAllGames() async {
    allGames.clear();
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('User')
          .doc(email)
          .collection('Games')
          .where('crea_match', isEqualTo: false)
          .get();
      final gameList =
          data.docs.map((friends) => GameModel.fromSnapshot(friends)).toList();
      allGames.assignAll(gameList);
    } catch (e) {}
  }

  Future<void> getAllCreateGames() async {
    allGames.clear();
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('User')
          .doc(email)
          .collection('Games')
          .where('crea_match', isEqualTo: true)
          .get();
      final gameList =
          data.docs.map((friends) => GameModel.fromSnapshot(friends)).toList();
      allGames.assignAll(gameList);
    } catch (e) {}
  }

  Future<void> getAllTennisGames() async {
    allTennisGames.clear();
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('User')
          .doc(email)
          .collection('Tennis Games')
          .get();
      final gameList = data.docs
          .map((friends) => TennisGameModel.fromSnapshot(friends))
          .toList();
      allTennisGames.assignAll(gameList);
    } catch (e) {}
  }
}
