import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/screen/searching_screen_2.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class SearchingPage2 extends StatelessWidget {
  const SearchingPage2({super.key, required this.city, required this.ospite});

  final String city;
  final bool ospite;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBar(),
            bottomNavigationBar: ospite
                ? null
                : BottomBar(
                    context,
                  ),
            body: SearchingScreen2(
              city: city,
              ospite: ospite,
            )));
  }
}
