import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Search_Club/search_club_card.dart';

class SearchedClubCarousel extends StatefulWidget {
  const SearchedClubCarousel(
      {super.key, required this.clubs, required this.ospite});

  final List clubs;
  final bool ospite;

  @override
  State<SearchedClubCarousel> createState() => _SearchedClubCarouselState();
}

class _SearchedClubCarouselState extends State<SearchedClubCarousel> {
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
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
              aspectRatio: 0.85,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.clubs.length,
                itemBuilder: (
                  BuildContext context,
                  index,
                ) =>
                    SearchClubCard(
                  clubs: widget.clubs[index],
                  ospite: widget.ospite,
                ),
              ),
            ));
      },
      stream: null,
    );
  }
}
