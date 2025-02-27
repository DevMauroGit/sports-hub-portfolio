import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/pavia_controller.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class SearchClubCarousel extends StatefulWidget {
  const SearchClubCarousel({super.key, required this.club});

  final PaviaController club;

  @override
  State<SearchClubCarousel> createState() => _SearchClubCarouselState();
}

class _SearchClubCarouselState extends State<SearchClubCarousel> {
  @override
  Widget build(BuildContext context) {
    final PaviaController clubController = widget.club;

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
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: AspectRatio(
              aspectRatio: 0.85,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: clubController.allClubs.length,
                  itemBuilder: (
                    BuildContext context,
                    index,
                  ) =>
                      Container()
                  //SearchClubCard(
                  //clubs: widget.Clubs[index],

                  //),

                  ),
            ));
      },
      stream: null,
    );
  }
}
