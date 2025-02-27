import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/page/verify_phone_page.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';

class VerifyPhonePageStart extends StatefulWidget {
  const VerifyPhonePageStart({super.key});

  @override
  State<VerifyPhonePageStart> createState() => _VerifyPhonePageStartState();
}

class _VerifyPhonePageStartState extends State<VerifyPhonePageStart> {
  @override
  Widget build(BuildContext context) {

    print('verify phone number start');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => VerifyPhonePage(
            h: 620,
            w: 485,
            size: Size(485, 620),
          )));
    });

    return LoadingScreen();
  }
}
