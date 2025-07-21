import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/games_controller.dart';
import 'package:sports_hub_ios/screen/tennis_game_management.dart';
import 'package:sports_hub_ios/utils/constants.dart';

/// This widget displays the tennis management interface
/// for a specific user profile and game controller.
class TennisManagementPage extends StatelessWidget {
  const TennisManagementPage(
      {super.key, required this.profile, required this.gameController});

  final String profile;
  final GameController gameController;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return MediaQuery(
      // Adjusts text scale for accessibility
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.2)),
      child: Scaffold(
        // Top app bar with custom content
        appBar: TopBarTennisGames(context, gameController, w),
        // Bottom navigation bar
        bottomNavigationBar: BottomBar(context),
        // Main screen content with game management logic
        body: TennisManagementScreen(
          profile: profile,
          gameController: gameController,
        ),
      ),
    );
  }
}

/// This widget is nearly identical to TennisManagementPage,
/// and may be used when creating or managing new tennis matches.
class TennisCreateManagementPage extends StatelessWidget {
  const TennisCreateManagementPage(
      {super.key, required this.profile, required this.gameController});

  final String profile;
  final GameController gameController;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return MediaQuery(
      // Adjusts text scale for accessibility
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.2)),
      child: Scaffold(
        // Top app bar with custom content
        appBar: TopBarTennisGames(context, gameController, w),
        // Bottom navigation bar
        bottomNavigationBar: BottomBar(context),
        // Main screen content for tennis game creation/management
        body: TennisManagementScreen(
          profile: profile,
          gameController: gameController,
        ),
      ),
    );
  }
}
