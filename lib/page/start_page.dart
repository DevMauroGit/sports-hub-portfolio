import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/page/signup_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class StartPage extends StatelessWidget {
  const StartPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    print(DateTime.now().year);
    return PopScope(
        canPop: false,
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.2)),
          child: Container(
            decoration: BoxDecoration(
              color: kBackgroundColor2,
              image: DecorationImage(
                image: const AssetImage("assets/images/sports_background1.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    kBackgroundColor2.withOpacity(0.2), BlendMode.dstATop),
              ),
            ),
            child: PopScope(
              canPop: false,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: _page(context, h, w),
              ),
            ),
          ),
        ));
  }

  Widget _page(context, double h, double w) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.only(
            top: h > 700 ? h * 0.13 : h * 0.1,
            bottom: 0.1,
            left: w * 0.06,
            right: w * 0.06),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(children: [
                Image.asset("assets/images/Sport_hub_logo_1.png",
                    height: 100, width: 100),
                Container(
                  padding: EdgeInsets.only(top: h * 0.04, bottom: h * 0.05),
                  child: Text(
                    'SPORTS HUB',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w > 385
                          ? h > 620
                              ? 30
                              : 28
                          : 25,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Text(
                'Prenota il campo di gioco',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w > 385
                      ? h > 620
                          ? 20
                          : 18
                      : 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(
              height: h * 0.04,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Text(
                'tieni traccia dei risultati',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w > 385
                      ? h > 620
                          ? 20
                          : 18
                      : 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(
              height: h * 0.04,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Text(
                'rendi grande il tuo curriculum!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w > 385
                      ? h > 620
                          ? 20
                          : 18
                      : 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 25,
        right: 15,
        child: SizedBox(
          width: 160,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor.withOpacity(0.7),
              textStyle: const TextStyle(fontSize: 15),
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              Get.to(() => const SignUpPage(),
                  transition: Transition.rightToLeft);
            },
            child: Text(
              "CONTINUA",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: w > 385 ? 14 : 12,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
      )
    ]);
  }
}
