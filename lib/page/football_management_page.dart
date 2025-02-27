import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/games_controller.dart';
import 'package:sports_hub_ios/screen/football_management_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class FootballManagementPage extends StatelessWidget {
  const FootballManagementPage(
      {Key? key, required this.profile, required this.gameController})
      : super(key: key);

  final String profile;
  final GameController gameController;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBarGames(w),
            bottomNavigationBar: BottomBar(context),
            body: FootballManagementScreen(
                profile: profile, gameController: gameController)));
  }
}

class FootballCreateManagementPage extends StatelessWidget {
  const FootballCreateManagementPage(
      {Key? key, required this.profile, required this.gameController})
      : super(key: key);

  final String profile;
  final GameController gameController;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBarGames(w),
            bottomNavigationBar: BottomBar(context),
            body: FootballCreateManagementScreen(
                profile: profile, gameController: gameController)));
  }
}
