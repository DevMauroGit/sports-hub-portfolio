import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/screen/club_page_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class ClubDetailPage extends StatefulWidget {
  const ClubDetailPage({
    Key? key,
    required this.clubs,
    required this.ospite,
    //required this.club,
  }) : super(key: key);

  //final ClubModel club;
  final Map clubs;
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
            bottomNavigationBar: widget.ospite ? null : BottomBar(context),
            body: ClubPageScreen(clubs: widget.clubs, ospite: widget.ospite)));
  }
}
