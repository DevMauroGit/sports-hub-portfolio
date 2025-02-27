import 'package:flutter/material.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(kDefaultPadding),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
