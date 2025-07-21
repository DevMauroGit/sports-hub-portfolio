import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/games_controller.dart';
import 'package:sports_hub_ios/screen/football_management_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class FootballManagementPage extends StatelessWidget {
  // Constructor with required parameters for profile and gameController
  const FootballManagementPage(
      {Key? key, required this.profile, required this.gameController})
      : super(key: key);

  final String profile;
  final GameController gameController;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return MediaQuery(
        // Set text scale factor to 1.2 for accessibility
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            // Custom app bar widget with width passed
            appBar: TopBarGames(w),
            // Custom bottom navigation bar widget
            bottomNavigationBar: BottomBar(context),
            // Main screen body for football management
            body: FootballManagementScreen(
                profile: profile, gameController: gameController)));
  }
}

class FootballCreateManagementPage extends StatelessWidget {
  // Constructor with required parameters for profile and gameController
  const FootballCreateManagementPage(
      {Key? key, required this.profile, required this.gameController})
      : super(key: key);

  final String profile;
  final GameController gameController;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return MediaQuery(
        // Set text scale factor to 1.2 for accessibility
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            // Custom app bar widget with width passed
            appBar: TopBarGames(w),
            // Custom bottom navigation bar widget
            bottomNavigationBar: BottomBar(context),
            // Main screen body for creating football management
            body: FootballCreateManagementScreen(
                profile: profile, gameController: gameController)));
  }
}
