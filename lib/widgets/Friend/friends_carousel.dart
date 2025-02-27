import 'package:flutter/material.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Friend/friend_card.dart';

class FriendsCarousel extends StatefulWidget {
  const FriendsCarousel(
      {super.key, required this.friends, required this.sport});

  final List friends;
  final String sport;

  @override
  State<FriendsCarousel> createState() => _FriendsCarouselState();
}

class _FriendsCarouselState extends State<FriendsCarousel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: AspectRatio(
          aspectRatio: 0.42,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.friends.length,
            itemBuilder: (
              BuildContext context,
              index,
            ) =>
                FriendCard(friends: widget.friends[index], sport: widget.sport),
          ),
        ));
  }
}
