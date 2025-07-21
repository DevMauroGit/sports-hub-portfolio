import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sports_hub_ios/page/home_page.dart';

final _db = FirebaseFirestore.instance;

// City variable used for filtering clubs by city (make sure 'city' is defined somewhere)
String c = city;

// Reference to the 'Clubs' collection in Firestore
final clubsRF = _db.collection('Clubs');

// Query reference for clubs filtered by city 'c'
final searchClubsRF = _db.collection('Clubs').where('city', isEqualTo: c);

// Reference to the 'detailHouses' collection
final detailHouseRF = _db.collection('detailHouses');

// Reference to the 'Clubs' collection (for pitches? might be better named)
final pitchesRF = _db.collection('Clubs');

// Reference to the 'Users' collection (note: consistent naming with 'Users' plural)
final userRF = _db.collection('Users');

// Reference to the 'Calendar' collection
final calendarRF = _db.collection('Calendar');

// Firebase Storage root reference
Reference get firebaseStorage => FirebaseStorage.instance.ref();

// Reference to the 'Months' collection (used for days/time documents)
final daysRF = _db.collection('Months');

/// Returns a DocumentReference to a specific time document inside a day's subcollection.
/// 
/// [day]: The day document ID inside 'Months'.
/// [time]: The time document ID inside the 'Time' subcollection.
DocumentReference timeRF({
  required String day,
  required String time,
}) =>
    daysRF.doc(day).collection("Time").doc(time);
