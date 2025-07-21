import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;                // Unique user ID
  String username;                // Username of the user
  final String email;             // User's email
  final String phoneNumber;       // User's phone number
  final String city;              // City where the user lives
  final String password;          // User's password
  String? profile_pic;            // Optional profile picture URL
  String? cover_pic;              // Optional cover picture URL
  bool isEmailVerified;           // Email verification status
  int games;                     // Number of games played
  int goals;                     // Number of goals scored
  int win;                       // Number of wins
  int games_tennis;              // Number of tennis games played
  int set_vinti;                 // Number of tennis sets won
  int win_tennis;                // Number of tennis matches won
  int prenotazioni;              // Number of bookings made
  int prenotazioniPremium;       // Number of premium bookings made
  String token;                  // User authentication token

  /// Constructor requiring all fields to create a UserModel instance
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

  /// Create a UserModel instance from a JSON map (e.g., from API or Firestore)
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
        games = json['games'] as int,            // Corrected from json['isEmailVerified'] to json['games']
        goals = json['goals'] as int,
        win = json['win'] as int,
        games_tennis = json['games_tennis'] as int,
        set_vinti = json['set_vinti'] as int,
        win_tennis = json['win_tennis'] as int,
        prenotazioni = json['prenotazioni'] as int,
        prenotazioniPremium = json['prenotazioniPremium'] as int,
        token = json['token'] as String;

  /// Create a UserModel instance from a Firestore DocumentSnapshot
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

  /// Convert the UserModel instance into a JSON map (for saving/updating)
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
