// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class PitchModel {
  String id;
  String title;
  String players;
  String size;
  String price;
  String description;
  String? image;
  String club;
  int teamSize;
  String sport;
  int first_hour;
  int last_hour;
  String club_mail;

  PitchModel({
    required this.id,
    required this.title,
    required this.players,
    required this.size,
    required this.price,
    required this.description,
    required this.image,
    required this.club,
    required this.teamSize,
    required this.sport,
    required this.first_hour,
    required this.last_hour,
    required this.club_mail,
  });

  PitchModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        title = json['title'] as String,
        players = json['players'] as String,
        size = json['size'] as String,
        price = json['price'] as String,
        description = json['description'] as String,
        image = json['image'] as String,
        club = json['club'] as String,
        teamSize = json['teamSize'] as int,
        sport = json['sport'] as String,
        first_hour = json['first_hour'] as int,
        last_hour = json['last_hour'] as int,
        club_mail = json['club_mail'] as String;

  PitchModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json)
      : id = json.id,
        title = json['title'],
        players = json['players'],
        size = json['size'],
        price = json['price'],
        description = json['description'],
        image = json['image'],
        club = json['club'],
        teamSize = json['teamSize'],
        sport = json['sport'],
        first_hour = json['first_hour'],
        last_hour = json['last_hour'],
        club_mail = json['club_mail'];

  get imageUrl => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['players'] = players;
    data['size'] = size;
    data['price'] = price;
    data['description'] = description;
    data['image'] = image;
    data['club'] = club;
    data['teamSize'] = teamSize;
    data['sport'] = sport;
    data['first_hour'] = first_hour;
    data['last_hour'] = last_hour;
    data['club_mail'] = club_mail;
    return data;
  }
}
