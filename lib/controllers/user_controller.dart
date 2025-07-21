import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/models/friend_model.dart';
import 'package:sports_hub_ios/models/game_model.dart';
import 'package:sports_hub_ios/models/user_model.dart';

class UserController extends GetxController {
  // Singleton instance for easy access
  static UserController get instance => Get.find();

  // Observable lists to hold users, friends, teammates, requests and games
  final allUsers = <UserModel>[].obs;
  final allFriends = <FriendModel>[].obs;
  final allFriendsData = <UserModel>[].obs;
  final allTeammate = <FriendModel>[].obs;
  final allRequest = <FriendModel>[].obs;
  var allGames = <GameModel>[].obs;

  final _db = FirebaseFirestore.instance;
  final lista = <UserModel>[];

  // Current authenticated user from FirebaseAuth
  final user = FirebaseAuth.instance.currentUser;

  @override
  void onReady() {
    // If user is logged in, load friends, teammates and requests
    if(user != null) {
      getAllFriends().then((value) => getFriendsData());
      getAllTeammate();
      getAllRequests();
    }
    super.onReady();
  }

  /// Fetch all friends where 'isRequested' is false
  Future<void> getAllFriends() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('User')
          .doc(email)
          .collection('Friends')
          .where('isRequested', isEqualTo: 'false')
          .get();
      final friendList = data.docs
          .map((friends) => FriendModel.fromSnapshot(friends))
          .toList();
      allFriends.assignAll(friendList);
    } catch (e) {}
  }

  /// Fetch detailed user data for all friends
  Future<void> getFriendsData() async {
    allFriendsData.clear();
    lista.clear();

    int c = 0;
    for (int i = 0; i < allFriends.length; i++) {
      try {
        QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
            .instance
            .collection('User')
            .where('email', isEqualTo: '${allFriends[i].email}')
            .get();
        var friend = data.docs
            .map((friends) => UserModel.fromSnapshot(friends))
            .elementAt(i);

        // Check to avoid duplicates in the list
        if (lista.isEmpty) {
          lista.add(friend);
        } else {
          for (int a = 0; a < allFriends.length; a++) {
            if (friend.email != lista.elementAt(a).email) {
              c++;
            }
          }
          if (c == lista.length) {
            lista.add(friend);
          }
        }
      } catch (e) {}
    }
    allFriendsData.assignAll(lista);
  }

  /// Fetch all teammates (friends with 'isRequested' = false)
  Future<void> getAllTeammate() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('User')
          .doc(email)
          .collection('Friends')
          .where('isRequested', isEqualTo: 'false')
          .get();
      final teammateList = data.docs
          .map((friends) => FriendModel.fromSnapshot(friends))
          .toList();
      allTeammate.assignAll(teammateList);
    } catch (e) {}
  }

  /// Fetch all friend requests where 'isRequested' is true
  Future<void> getAllRequests() async {
    allRequest.clear();
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('User')
          .doc(email)
          .collection('Friends')
          .where('isRequested', isEqualTo: 'true')
          .get();
      final friendList = data.docs
          .map((friends) => FriendModel.fromSnapshot(friends))
          .toList();
      allRequest.assignAll(friendList);
    } catch (e) {}
  }

  /// Search users by username
  Future<void> getAllUsers(name) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('User')
          .where('username', isEqualTo: name)
          .get();
      final clubList =
          data.docs.map((clubs) => UserModel.fromSnapshot(clubs)).toList();
      allUsers.assignAll(clubList);
      print(allUsers);
    } catch (e) {}
  }

  /// Get detailed user info by email
  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("User").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  /// Get all users
  Future<List<UserModel>> allUser() async {
    final snapshot = await _db.collection("User").get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  /// Get users by name (alternative method)
  Future<List<UserModel>> gatAllUsers(name) async {
    final snapshot =
        await _db.collection("User").where('name', isEqualTo: name).get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  /// Update user data in Firestore
  Future<void> updateUser(UserModel user) async {
    await _db.collection("User").doc(user.email).update(user.toJson());
  }

  /// Update friends data for both users
  Future<void> updateUserFriends(
      FriendModel user, FriendModel userFriend) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(userFriend.email)
        .collection('Friends')
        .doc(user.email)
        .set(user.toJson());
    await FirebaseFirestore.instance
        .collection("User")
        .doc(user.email)
        .collection('Friends')
        .doc(userFriend.email)
        .set(userFriend.toJson());
  }

  /// Send a game record to a friend
  Future<void> sendGameToFriend(
      String userFriend,
      String host,
      int team,
      int totTeam1,
      int totTeam2,
      int goal,
      String host_name,
      String id,
      String date,
      int permissions,
      String club,
      String giorno,
      String dbURL,
      bool crea_match) async {
    String finale = '';
    if (totTeam1 > totTeam2) {
      if (team == 1) {
        finale = 'VITTORIA'; // Victory
      } else if (team == 2) {
        finale = 'SCONFITTA'; // Defeat
      }
    } else if (totTeam1 < totTeam2) {
      if (team == 1) {
        finale = 'SCONFITTA'; // Defeat
      } else if (team == 2) {
        finale = 'VITTORIA'; // Victory
      }
    }
    GameModel game = GameModel(
        host: host,
        team: team,
        totTeam1: totTeam1,
        totTeam2: totTeam2,
        goal: goal,
        risultato: finale,
        hostUsername: host_name,
        userId: id,
        date: date,
        permissions: permissions,
        club: club,
        giorno: giorno,
        dbURL: dbURL,
        crea_match: crea_match);

    // Save the game record in friend's subcollection
    await FirebaseFirestore.instance
        .collection("User")
        .doc(userFriend)
        .collection('Games')
        .doc(date)
        .set(game.toJson());
  }
}
