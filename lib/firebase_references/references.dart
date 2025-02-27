import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sports_hub_ios/page/home_page.dart';

final _db = FirebaseFirestore.instance;

String c = city;

final clubsRF = _db.collection('Clubs');
final searchClubsRF = _db.collection('Clubs').where('city', isEqualTo: c);
final detailHouseRF = _db.collection('detailHouses');
final pitchesRF = _db.collection('Clubs');
final userRF = _db.collection('Users');
final calendarRF = _db.collection('Calendar');

Reference get firebaseStorage => FirebaseStorage.instance.ref();

final daysRF = _db.collection('Months');

DocumentReference timeRF({
  required String day,
  required String time,
}) =>
    daysRF.doc(day).collection("Time").doc(time);
