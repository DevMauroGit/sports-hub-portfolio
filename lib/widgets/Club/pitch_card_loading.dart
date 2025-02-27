import 'package:flutter/material.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';

class PitchCardLoading extends StatelessWidget {
  const PitchCardLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = MediaQuery.of(context).size.height;
    //double w = MediaQuery.of(context).size.height;

    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Container(
              margin: const EdgeInsets.only(
                right: kDefaultPadding,
                //left: kDefaultPadding,
                top: kDefaultPadding,
                //bottom: kDefaultPadding * 15,
              ),
              padding: const EdgeInsets.all(0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              width: size.width > 355 ? size.width * 0.37 : size.width * 0.4,
              height:
                  size.height > 700 ? size.height * 0.13 : size.height * 0.15,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.grey[800],
                ),
                child: const LoadingScreen(),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(children: <Widget>[
                  Container(
                    width:
                        size.width > 355 ? size.width * 0.37 : size.width * 0.4,
                    height: h > 700 ? size.height * 0.12 : h * 0.18,
                    margin: const EdgeInsets.only(
                      //left: kDefaultPadding,
                      right: kDefaultPadding,
                      // top: kDefaultPadding,
                      //bottom: kDefaultPadding * 15,
                    ),
                    padding:
                        const EdgeInsets.only(right: 10, left: 10, top: 15),
                    decoration: const BoxDecoration(
                      color: kBackgroundColor2,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ])
                //)
                )
          ])
        ],
      )
    ]);
  }
}
