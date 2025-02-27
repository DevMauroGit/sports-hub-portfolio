import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/club_controller.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Club/club_card.dart';

class ClubCarousel extends StatefulWidget {
  const ClubCarousel(
      {super.key,
      required this.club,
      required this.clubs,
      required this.ospite});

  final ClubController club;
  final List clubs;
  final bool ospite;

  @override
  State<ClubCarousel> createState() => _ClubCarouselState();
}

class _ClubCarouselState extends State<ClubCarousel> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('errore caricamento dati');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return SizedBox(
            //padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
          aspectRatio: 0.85,
          child: ListView.builder(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: widget.clubs.length,
            itemBuilder: (
              BuildContext context,
              index,
            ) =>
                ClubCard(
              //club: clubController.allClubs[index],
              clubs: widget.clubs[index], ospite: widget.ospite,
            ),
          ),
        ));
      },
      stream: null,
    );
  }
}
