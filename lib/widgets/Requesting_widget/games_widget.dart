import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/games_controller.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Requesting_widget/games_card.dart';

class GamesWidget extends StatefulWidget {
  const GamesWidget({
    super.key,
    required this.appointment,
    required this.gameController,
  });

  final Map appointment;
  final GameController gameController;

  @override
  State<GamesWidget> createState() => _GamesWidgetState();
}

class _GamesWidgetState extends State<GamesWidget> {
  @override
  Widget build(BuildContext context) {
    final GameController gameController = widget.gameController;

    return FutureBuilder(
      future: gameController.getAllGames(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('games: ${userController.allGames.first}');
        return GameCard(
          game: gameController.allGames.first,
          appointment: widget.appointment,
        );
      },
    );
  }
}

class GamesCreateWidget extends StatefulWidget {
  const GamesCreateWidget({
    super.key,
    required this.appointment,
    required this.gameController,
  });

  final Map appointment;
  final GameController gameController;

  @override
  State<GamesCreateWidget> createState() => _GamesCreateWidgetState();
}

class _GamesCreateWidgetState extends State<GamesCreateWidget> {
  @override
  Widget build(BuildContext context) {
    final GameController gameController = widget.gameController;

    return FutureBuilder(
      future: gameController.getAllCreateGames(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } //print('games: ${userController.allGames.first}');
        return GameCard(
          game: gameController.allGames.first,
          appointment: widget.appointment,
        );
      },
    );
  }
}
