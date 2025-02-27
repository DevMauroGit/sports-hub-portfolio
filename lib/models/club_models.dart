// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ClubModel {
  String id;
  String title;
  String description;
  String? image;
  String city;
  String adminEmail;
  Map<String, dynamic> orari;
  int slot;
  int pitches_number;
  String dbURL;
  int maps1;
  int maps2;
  String address;
  bool premium;
  String token;

  ClubModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.city,
    required this.adminEmail,
    required this.orari,
    required this.slot,
    required this.pitches_number,
    required this.dbURL,
    required this.maps1,
    required this.maps2,
    required this.address,
    required this.premium,
    required this.token,
  });

  ClubModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        title = json['title'] as String,
        description = json['description'] as String,
        image = json['image'] as String,
        city = json['city'] as String,
        adminEmail = json['adminEmail'] as String,
        orari = json['orari'] as Map<String, dynamic>,
        slot = json['slot'] as int,
        pitches_number = json['pitches_number'] as int,
        dbURL = json['dbURL'] as String,
        maps1 = json['maps1'] as int,
        maps2 = json['maps2'] as int,
        address = json['address'] as String,
        premium = json['premium'] as bool,
        token = json['token'] as String;

  ClubModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json)
      : id = json.id,
        title = json['title'],
        description = json['description'],
        image = json['image'],
        city = json['city'],
        adminEmail = json['adminEmail'],
        orari = json['orari'],
        slot = json['slot'],
        pitches_number = json['pitches_number'],
        dbURL = json['dbURL'],
        maps1 = json['maps1'],
        maps2 = json['maps2'],
        address = json['address'],
        premium = json['premium'],
        token = json['token'];

  get imageUrl => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['city'] = city;
    data['adminEmail'] = adminEmail;
    data['orari'] = orari;
    data['slot'] = slot;
    data['pitches_number'] = pitches_number;
    data['dbURL'] = dbURL;
    data['maps1'] = maps1;
    data['maps2'] = maps2;
    data['address'] = address;
    data['premium'] = premium;
    data['token'] = token;
    return data;
  }
}
