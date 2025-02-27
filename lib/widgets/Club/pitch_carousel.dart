import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/pitch_controller.dart';
import 'package:sports_hub_ios/widgets/Club/pitch_card.dart';
import 'package:sports_hub_ios/widgets/Club/pitch_card_loading.dart';

class PitchCarousel extends StatefulWidget {
  const PitchCarousel({
    super.key,
    required this.pitch,
    required this.clubs,
    required this.club,
    required this.ospite,
    required this.h,
    required this.w,
  });

  final PitchController pitch;
  final List clubs;
  final Map club;
  final bool ospite;
  final double h;
  final double w;

  @override
  State<PitchCarousel> createState() => _PitchCarouselState();
}

class _PitchCarouselState extends State<PitchCarousel> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: AspectRatio(
                aspectRatio: 0.85,
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (
                      context,
                      index,
                    ) =>
                        const PitchCardLoading()),
              ));
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: AspectRatio(
              aspectRatio: 0.85,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemCount: widget.clubs.length,
                itemBuilder: (
                  context,
                  index,
                ) =>
                    PitchCard(
                  pitch: widget.clubs[index],
                  club: widget.club,
                  ospite: widget.ospite,
                  hM: widget.h,
                  wM: widget.w,
                ),
              ),
            ));
      },
      stream: null,
    );
  }
}
