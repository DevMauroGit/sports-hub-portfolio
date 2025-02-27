import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  //String id;
  String user;
  String club;
  String month;
  String day;
  String time;
  int playerCount;

  AppointmentModel({
    required this.user,
    //required this.id,
    required this.club,
    required this.month,
    required this.day,
    required this.time,
    required this.playerCount,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json)
      : user = json['user'] as String,
        //id = json['id'] as String,
        club = json['club'] as String,
        month = json['month'] as String,
        day = json['day'] as String,
        time = json['time'] as String,
        playerCount = json['playerCount'] as int;

  AppointmentModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json)
      : user = json['user'],
        //id = json['id'],
        club = json['club'],
        month = json['month'],
        day = json['day'],
        time = json['time'],
        playerCount = json['playerCount'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['id'] = id;
    data['user'] = user;
    data['club'] = club;
    data['date'] = month;
    data['day'] = day;
    data['time'] = time;
    data['playerCount'] = playerCount;
    return data;
  }
}
