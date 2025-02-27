import 'package:flutter/material.dart';
import 'package:sports_hub_ios/screen/pitch_page_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class PitchPage extends StatefulWidget {
  const PitchPage({super.key, required this.pitch, required this.club});

  //final PitchModel pitch;
  final Map pitch;
  final Map club;

  @override
  State<PitchPage> createState() => _PitchPageState();
}

class _PitchPageState extends State<PitchPage> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBar(),
            bottomNavigationBar: BottomBar(context),
            body: PitchPageScreen(
              pitch: widget.pitch,
              club: widget.club,
            )));
  }
}
