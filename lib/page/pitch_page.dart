import 'package:flutter/material.dart';
import 'package:sports_hub_ios/screen/pitch_page_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class PitchPage extends StatefulWidget {
  const PitchPage({super.key, required this.pitch, required this.club});

  // Map objects representing pitch and club details
  final Map pitch;
  final Map club;

  @override
  State<PitchPage> createState() => _PitchPageState();
}

class _PitchPageState extends State<PitchPage> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        // Adjusts text scaling for better accessibility
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBar(), // Custom app bar widget
            bottomNavigationBar: BottomBar(context), // Custom bottom navigation
            body: PitchPageScreen(
              pitch: widget.pitch, 
              club: widget.club,   
            )));
  }
}
