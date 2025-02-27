import 'package:cloud_firestore/cloud_firestore.dart';

class TennisGameModel{
  String host;
  int team;
  int S1T1;
  int S2T1;
  int S3T1;
  int S1T2;
  int S2T2;
  int S3T2;
  String risultato;
  String hostUsername;
  String userId;
  String date;
  int permissions;
  String club;
  String giorno;
  int set;
  String sport;

  TennisGameModel(
    {required this.host,
    required this.team,
    required this.S1T1,
    required this.S2T1,
    required this.S3T1,
    required this.S1T2,
    required this.S2T2,
    required this.S3T2,
    required this.risultato,
    required this.hostUsername,
    required this.userId,
    required this.date,
    required this.permissions,
    required this.club,
    required this.giorno,
    required this.set,
    required this.sport});
    
    TennisGameModel.fromJson(Map<String, dynamic> json) :
    host = json['host'] as String,
    team = json['team'] as int,
    S1T1 = json['S1T1'] as int,
    S2T1 = json['S2T1'] as int,
    S3T1 = json['S3T1'] as int,
    S1T2 = json['S1T2'] as int,
    S2T2 = json['S2T2'] as int,
    S3T2 = json['S3T2'] as int,
    risultato = json['risultato'] as String,
    hostUsername = json['hostUsername'] as String,
    userId = json['userId'] as String,
    date = json['date'] as String,
    permissions = json['permissions'] as int,
    club = json['club'] as String,
    giorno = json['giorno'] as String,
    set = json['set'] as int,
    sport = json['sport'] as String;


    TennisGameModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json) :
    host = json['host'],
    team = json['team'],
    S1T1 = json['S1T1'],
    S2T1 = json['S2T1'],
    S3T1 = json['S3T1'],
    S1T2 = json['S1T2'],
    S2T2 = json['S2T2'],
    S3T2 = json['S3T2'],
    risultato = json['risultato'],
    hostUsername = json['hostUsername'],
    userId = json['userId'],
    date = json['date'],
    permissions = json['permissions'],
    club = json['club'],
    giorno = json['giorno'],
    set = json['set'],
    sport = json['sport'];

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['host'] = host;
    data['team'] = team;
    data['S1T1'] = S1T1;
    data['S2T1'] = S2T1;
    data['S3T1'] = S3T1;
    data['S1T2'] = S1T2;
    data['S2T2'] = S2T2;
    data['S3T2'] = S3T2;
    data['risultato'] = risultato;
    data['hostUsername'] = hostUsername;
    data['userId'] = userId;
    data['date'] = date;
    data['permissions'] = permissions;
    data['club'] = club;
    data['giorno'] = giorno;
    data['set'] = set;
    data['sport'] = sport;
    return data;
    }
}