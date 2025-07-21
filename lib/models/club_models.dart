// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a Club with various details including schedule, location, and admin info.
class ClubModel {
  final String id;
  final String title;
  final String description;
  String? image;
  final String city;
  final String adminEmail;
  final Map<String, dynamic> orari; // Schedule information
  final int slot;
  final int pitches_number;
  final String dbURL;
  final int maps1;
  final int maps2;
  final String address;
  final bool premium;
  final String token;

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

  /// Creates a ClubModel instance from a JSON map.
  ClubModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        title = json['title'] as String,
        description = json['description'] as String,
        image = json['image'] as String?,
        city = json['city'] as String,
        adminEmail = json['adminEmail'] as String,
        orari = Map<String, dynamic>.from(json['orari'] as Map),
        slot = json['slot'] as int,
        pitches_number = json['pitches_number'] as int,
        dbURL = json['dbURL'] as String,
        maps1 = json['maps1'] as int,
        maps2 = json['maps2'] as int,
        address = json['address'] as String,
        premium = json['premium'] as bool,
        token = json['token'] as String;

  /// Creates a ClubModel from a Firestore DocumentSnapshot.
  ClubModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        title = snapshot.data()?['title'] ?? '',
        description = snapshot.data()?['description'] ?? '',
        image = snapshot.data()?['image'],
        city = snapshot.data()?['city'] ?? '',
        adminEmail = snapshot.data()?['adminEmail'] ?? '',
        orari = Map<String, dynamic>.from(snapshot.data()?['orari'] ?? {}),
        slot = snapshot.data()?['slot'] ?? 0,
        pitches_number = snapshot.data()?['pitches_number'] ?? 0,
        dbURL = snapshot.data()?['dbURL'] ?? '',
        maps1 = snapshot.data()?['maps1'] ?? 0,
        maps2 = snapshot.data()?['maps2'] ?? 0,
        address = snapshot.data()?['address'] ?? '',
        premium = snapshot.data()?['premium'] ?? false,
        token = snapshot.data()?['token'] ?? '';

  /// Converts the ClubModel into a JSON map for Firestore storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'city': city,
      'adminEmail': adminEmail,
      'orari': orari,
      'slot': slot,
      'pitches_number': pitches_number,
      'dbURL': dbURL,
      'maps1': maps1,
      'maps2': maps2,
      'address': address,
      'premium': premium,
      'token': token,
    };
  }
}
