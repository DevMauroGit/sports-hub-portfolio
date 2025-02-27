import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/games_controller.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Requesting_widget/games_card.dart';

class TennisGamesWidget extends StatefulWidget {
  const TennisGamesWidget({
    super.key,
    required this.appointment,
    required this.gameController,
  });

  final Map appointment;
  final GameController gameController;

  @override
  State<TennisGamesWidget> createState() => _TennisGamesWidgetState();
}

class _TennisGamesWidgetState extends State<TennisGamesWidget> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    final GameController gameController = widget.gameController;

    return FutureBuilder(
      future: gameController.getAllTennisGames(),
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
        return //userController.allGames.isEmpty? Container() :
            SizedBox(
          width: w * 0.9,
          child: TennisGameCard(
            game: widget.gameController.allTennisGames.first,
            appointment: widget.appointment,
          ),
        );
      },
    );
  }
}
