import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing an appointment made by a user at a club.
/// Contains date and time information along with the number of players.
class AppointmentModel {
  final String user;
  final String club;
  final String month;
  final String day;
  final String time;
  final int playerCount;

  AppointmentModel({
    required this.user,
    required this.club,
    required this.month,
    required this.day,
    required this.time,
    required this.playerCount,
  });

  /// Creates an AppointmentModel from a JSON map.
  AppointmentModel.fromJson(Map<String, dynamic> json)
      : user = json['user'] as String,
        club = json['club'] as String,
        month = json['month'] as String,
        day = json['day'] as String,
        time = json['time'] as String,
        playerCount = json['playerCount'] as int;

  /// Creates an AppointmentModel from a Firestore DocumentSnapshot.
  AppointmentModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : user = snapshot.data()?['user'] ?? '',
        club = snapshot.data()?['club'] ?? '',
        month = snapshot.data()?['month'] ?? '',
        day = snapshot.data()?['day'] ?? '',
        time = snapshot.data()?['time'] ?? '',
        playerCount = snapshot.data()?['playerCount'] ?? 0;

  /// Converts the model into a JSON map for Firestore storage.
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'club': club,
      'month': month,
      'day': day,
      'time': time,
      'playerCount': playerCount,
    };
  }
}
