import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel {
  String id;
  String username;
  final String email;
  final String password;
  String? profile_pic;
  final String? cover_pic;
  bool isEmailVerified;
  String isRequested;
  int games;
  int goals;
  int win;
  int games_tennis;
  int set_vinti;
  int win_tennis;
  String token;

  FriendModel(
      {required this.username,
      required this.id,
      required this.email,
      required this.password,
      required this.profile_pic,
      required this.cover_pic,
      required this.isEmailVerified,
      required this.isRequested,
      required this.games,
      required this.goals,
      required this.win,
      required this.games_tennis,
      required this.set_vinti,
      required this.win_tennis,
      required this.token});

  FriendModel.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        id = json['id'] as String,
        email = json['email'] as String,
        password = json['password'] as String,
        profile_pic = json['profile_pic'] as String,
        cover_pic = json['cover_pic'] as String,
        isEmailVerified = json['isEmailVerified'],
        isRequested = json['isRequested'] as String,
        games = json['isEmailVerified'],
        goals = json['goals'],
        win = json['win'],
        games_tennis = json['games_tennis'] as int,
        set_vinti = json['set_vinti'] as int,
        win_tennis = json['win_tennis'] as int,
        token = json['token'] as String;

  FriendModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json)
      : username = json['username'],
        id = json['id'],
        email = json['email'],
        password = json['password'],
        profile_pic = json['profile_pic'],
        cover_pic = json['cover_pic'],
        isEmailVerified = json['isEmailVerified'],
        isRequested = json['isRequested'],
        games = json['games'],
        goals = json['goals'],
        win = json['win'],
        games_tennis = json['games_tennis'],
        set_vinti = json['set_vinti'],
        win_tennis = json['win_tennis'],
        token = json['token'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['profile_pic'] = profile_pic;
    data['cover_pic'] = cover_pic;
    data['isEmailVerified'] = isEmailVerified;
    data['isRequested'] = isRequested;
    data['games'] = games;
    data['goals'] = goals;
    data['win'] = win;
    data['games_tennis'] = games_tennis;
    data['set_vinti'] = set_vinti;
    data['win_tennis'] = win_tennis;
    data['token'] = token;
    return data;
  }
}
