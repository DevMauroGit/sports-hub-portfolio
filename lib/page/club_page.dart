import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/screen/club_page_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';

/// ClubDetailPage is responsible for displaying the details of a selected club.
/// It also conditionally shows a bottom navigation bar depending on whether the user is a guest (ospite).
class ClubDetailPage extends StatefulWidget {
  const ClubDetailPage({
    Key? key,
    required this.clubs,
    required this.ospite,
  }) : super(key: key);

  /// Map containing club data passed to the screen
  final Map clubs;

  /// Indicates whether the current user is a guest
  final bool ospite;

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.2)),
      child: Scaffold(
        appBar: TopBar(),

        /// If user is a guest, hide the bottom navigation bar
        bottomNavigationBar: widget.ospite ? null : BottomBar(context),

        /// ClubPageScreen is responsible for rendering the full UI for the selected club
        body: ClubPageScreen(
          clubs: widget.clubs,
          ospite: widget.ospite,
        ),
      ),
    );
  }
}
