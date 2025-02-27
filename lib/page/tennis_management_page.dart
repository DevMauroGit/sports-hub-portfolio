import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/games_controller.dart';
import 'package:sports_hub_ios/screen/tennis_game_management.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class TennisManagementPage extends StatelessWidget {
  const TennisManagementPage(
      {super.key, required this.profile, required this.gameController});

  final String profile;
  final GameController gameController;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBarTennisGames(context, gameController, w),
            bottomNavigationBar: BottomBar(context),
            body: TennisManagementScreen(
                profile: profile, gameController: gameController)));
  }
}

class TennisCreateManagementPage extends StatelessWidget {
  const TennisCreateManagementPage(
      {super.key, required this.profile, required this.gameController});

  final String profile;
  final GameController gameController;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBarTennisGames(context, gameController, w),
            bottomNavigationBar: BottomBar(context),
            body: TennisManagementScreen(
                profile: profile, gameController: gameController)));
  }
}
