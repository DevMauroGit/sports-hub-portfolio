import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  String username;
  final String email;
  final String phoneNumber;
  final String city;
  final String password;
  String? profile_pic;
  String? cover_pic;
  bool isEmailVerified;
  int games;
  int goals;
  int win;
  int games_tennis;
  int set_vinti;
  int win_tennis;
  int prenotazioni;
  int prenotazioniPremium;
  String token;

  UserModel({
    required this.username,
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.password,
    required this.profile_pic,
    required this.cover_pic,
    required this.isEmailVerified,
    required this.games,
    required this.goals,
    required this.win,
    required this.games_tennis,
    required this.set_vinti,
    required this.win_tennis,
    required this.prenotazioni,
    required this.prenotazioniPremium,
    required this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        id = json['id'] as String,
        email = json['email'] as String,
        phoneNumber = json['phoneNumber'] as String,
        city = json['city'] as String,
        password = json['password'] as String,
        profile_pic = json['profile_pic'] as String,
        cover_pic = json['cover_pic'] as String,
        isEmailVerified = json['isEmailVerified'],
        games = json['isEmailVerified'] as int,
        goals = json['goals'] as int,
        win = json['win'] as int,
        games_tennis = json['games_tennis'] as int,
        set_vinti = json['set_vinti'] as int,
        win_tennis = json['win_tennis'] as int,
        prenotazioni = json['prenotazioni'] as int,
        prenotazioniPremium = json['prenotazioniPremium'] as int,
        token = json['token'] as String;

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json)
      : username = json['username'],
        id = json['id'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        city = json['city'],
        password = json['password'],
        profile_pic = json['profile_pic'],
        cover_pic = json['cover_pic'],
        isEmailVerified = json['isEmailVerified'],
        games = json['games'],
        goals = json['goals'],
        win = json['win'],
        games_tennis = json['games_tennis'],
        set_vinti = json['set_vinti'],
        win_tennis = json['win_tennis'],
        prenotazioni = json['prenotazioni'],
        prenotazioniPremium = json['prenotazioniPremium'],
        token = json['token'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['city'] = city;
    data['password'] = password;
    data['profile_pic'] = profile_pic;
    data['cover_pic'] = cover_pic;
    data['isEmailVerified'] = isEmailVerified;
    data['games'] = games;
    data['goals'] = goals;
    data['win'] = win;
    data['games_tennis'] = games_tennis;
    data['set_vinti'] = set_vinti;
    data['win_tennis'] = win_tennis;
    data['prenotazioni'] = prenotazioni;
    data['prenotazioniPremium'] = prenotazioniPremium;
    data['token'] = token;
    return data;
  }
}
