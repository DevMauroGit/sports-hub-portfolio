import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  String host;
  int team;
  int totTeam1;
  int totTeam2;
  int goal;
  String risultato;
  String hostUsername;
  String userId;
  String date;
  int permissions;
  String club;
  String dbURL;
  String giorno;
  bool crea_match;

  /// Constructor for GameModel with all required fields
  GameModel({
    required this.host,
    required this.team,
    required this.totTeam1,
    required this.totTeam2,
    required this.goal,
    required this.risultato,
    required this.hostUsername,
    required this.userId,
    required this.date,
    required this.permissions,
    required this.club,
    required this.dbURL,
    required this.giorno,
    required this.crea_match,
  });

  /// Creates a GameModel instance from a JSON map
  GameModel.fromJson(Map<String, dynamic> json)
      : host = json['host'] as String,
        team = json['team'] as int,
        totTeam1 = json['totTeam1'] as int,
        totTeam2 = json['totTeam2'] as int,
        goal = json['goal'] as int,
        risultato = json['risultato'] as String,
        hostUsername = json['hostUsername'] as String,
        userId = json['userId'] as String,
        date = json['date'] as String,
        permissions = json['permissions'] as int,
        club = json['club'] as String,
        dbURL = json['dbURL'] as String,
        giorno = json['giorno'] as String,
        crea_match = json['crea_match'] as bool;

  /// Creates a GameModel instance from a Firestore document snapshot
  GameModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json)
      : host = json['host'],
        team = json['team'],
        totTeam1 = json['totTeam1'],
        totTeam2 = json['totTeam2'],
        goal = json['goal'],
        risultato = json['risultato'],
        hostUsername = json['hostUsername'],
        userId = json['userId'],
        date = json['date'],
        permissions = json['permissions'],
        club = json['club'],
        dbURL = json['dbURL'],
        giorno = json['giorno'],
        crea_match = json['crea_match'];

  /// Converts the GameModel instance into a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['host'] = host;
    data['team'] = team;
    data['totTeam1'] = totTeam1;
    data['totTeam2'] = totTeam2;
    data['goal'] = goal;
    data['risultato'] = risultato;
    data['hostUsername'] = hostUsername;
    data['userId'] = userId;
    data['date'] = date;
    data['permissions'] = permissions;
    data['club'] = club;
    data['dbURL'] = dbURL;
    data['giorno'] = giorno;
    data['crea_match'] = crea_match;
    return data;
  }
}
