import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/pitch_controller.dart';
import 'package:sports_hub_ios/widgets/Club/pitch_card.dart';
import 'package:sports_hub_ios/widgets/Club/pitch_card_loading.dart';

class PitchCarousel extends StatefulWidget {
  // Constructor with required parameters for pitches, clubs, selected club info, guest flag, height and width
  const PitchCarousel({
    super.key,
    required this.pitch,
    required this.clubs,
    required this.club,
    required this.ospite,
    required this.h,
    required this.w,
  });

  final PitchController pitch; // Controller for pitch data and logic
  final List clubs;            // List of club pitches to display
  final Map club;              // Currently selected club information
  final bool ospite;           // Flag indicating if the user is a guest
  final double h;              // Available height for layout
  final double w;              // Available width for layout

  @override
  State<PitchCarousel> createState() => _PitchCarouselState();
}

class _PitchCarouselState extends State<PitchCarousel> {
  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to listen to pitch data updates (currently stream is null)
    return StreamBuilder(
      stream: null, // Placeholder: replace with actual Firestore stream or data source
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Handle error case by printing error message
        if (snapshot.hasError) {
          print('Error loading data');
        } 
        // While waiting for data, show loading placeholder widgets with horizontal scrolling
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: AspectRatio(
              aspectRatio: 0.85, // Maintain consistent aspect ratio for the carousel
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemCount: 3, // Show 3 loading placeholders
                itemBuilder: (context, index) => const PitchCardLoading(),
              ),
            ),
          );
        }
        // Once data is available, build a horizontal scrollable list of PitchCards for each club pitch
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: AspectRatio(
            aspectRatio: 0.85,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemCount: widget.clubs.length,
              itemBuilder: (context, index) => PitchCard(
                pitch: widget.clubs[index],   // Pass pitch data to card
                club: widget.club,             // Pass selected club info
                ospite: widget.ospite,         // Pass guest flag
                hM: widget.h,                  // Pass height measurement
                wM: widget.w,                  // Pass width measurement
              ),
            ),
          ),
        );
      },
    );
  }
}
