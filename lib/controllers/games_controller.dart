import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/models/game_model.dart';
import 'package:sports_hub_ios/models/tennis_game_model.dart';
import 'package:sports_hub_ios/models/user_model.dart';

class GameController extends GetxController {
  // Singleton instance for easy access
  static GameController get instance => Get.find();

  // Observable lists to hold all games and tennis games
  var allGames = <GameModel>[].obs;
  var allTennisGames = <TennisGameModel>[].obs;

  final lista = <UserModel>[];

  @override
  void onReady() {
    // Called when controller is ready, load all games and tennis games
    getAllGames();
    getAllTennisGames();
    super.onReady();
  }

  /// Fetch all games where 'crea_match' is false
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
    } catch (e) {
      // Error handling can be improved here
    }
  }

  /// Fetch all games where 'crea_match' is true
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
    } catch (e) {
      // Error handling can be improved here
    }
  }

  /// Fetch all tennis games for the current user
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
    } catch (e) {
      // Error handling can be improved here
    }
  }
}
