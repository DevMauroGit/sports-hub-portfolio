import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneModel {
  final String id;
  String username;
  final String email;
  final String phoneNumber;
  final String city;
  final String password;

  /// Constructor for PhoneModel with required fields
  PhoneModel({
    required this.username,
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.password,
  });

  /// Creates a PhoneModel instance from a JSON map
  PhoneModel.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        id = json['id'] as String,
        email = json['email'] as String,
        phoneNumber = json['phoneNumber'] as String,
        city = json['city'] as String,
        password = json['password'] as String;

  /// Creates a PhoneModel instance from a Firestore document snapshot
  PhoneModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json)
      : username = json['username'],
        id = json['id'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        city = json['city'],
        password = json['password'];

  /// Converts the PhoneModel instance to a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['city'] = city;
    data['password'] = password;
    return data;
  }
}
