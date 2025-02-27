import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/page/pitch_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/register_memo.dart';

class PitchCard extends StatelessWidget {
  const PitchCard({
    super.key,
    required this.pitch,
    required this.club,
    required this.ospite,
    required this.hM,
    required this.wM,
  });

  final Map pitch;
  final Map club;
  final bool ospite;
  final double hM;
  final double wM;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.height;

    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              ospite == true
                  ? Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                      return RegisterMemo(
                        h: hM,
                        w: wM,
                      );
                    }))
                  : Get.to(
                      () => PitchPage(
                            pitch: pitch,
                            club: club,
                          ),
                      transition: Transition.fadeIn);
            },
            child: Column(children: [
              Container(
                margin: const EdgeInsets.only(
                  right: kDefaultPadding,
                  //left: kDefaultPadding,
                  top: kDefaultPadding,
                  //bottom: kDefaultPadding * 15,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: size.width > 355 ? size.width * 0.38 : size.width * 0.41,
                height:
                    size.height > 700 ? size.height * 0.13 : size.height * 0.15,
                child: CachedNetworkImage(
                  imageUrl: pitch['image']!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill)),
                  ),
                  placeholder: (context, url) => Container(
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                  // errorWidget: (context, url, error) => Image.asset("assets/images/Campo8.jpg")
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(children: <Widget>[
                    Container(
                        width: size.width > 355
                            ? size.width * 0.38
                            : size.width * 0.41,
                        height: h > 700 ? size.height * 0.13 : h * 0.18,
                        margin: const EdgeInsets.only(
                          //left: kDefaultPadding,
                          right: kDefaultPadding,
                          // top: kDefaultPadding,
                          //bottom: kDefaultPadding * 15,
                        ),
                        padding: EdgeInsets.only(
                            right: w > 385 ? 10 : 5,
                            left: w > 385 ? 10 : 5,
                            top: 15),
                        decoration: const BoxDecoration(
                          color: kBackgroundColor2,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              Text(pitch['title'],
                                  style: TextStyle(
                                      fontSize: size.width > 605
                                          ? 20
                                          : size.width > 385
                                              ? 14
                                              : 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                width: 10,
                              ),
                              pitch['sport'] == 'football'
                                  ? Container(
                                      width: w * 0.035,
                                      height: h * 0.030,
                                      decoration: const BoxDecoration(
                                          color: kBackgroundColor2,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Icon(
                                            Icons.sports_soccer,
                                            size: h * 0.025,
                                          )))
                                  : Container(
                                      width: w * 0.035,
                                      height: h * 0.030,
                                      decoration: const BoxDecoration(
                                          color: kBackgroundColor2,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Icon(
                                            Icons.sports_tennis,
                                            size: h * 0.025,
                                          ))),
                            ],
                          ),
                          SizedBox(height: h * 0.01),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.accessibility,
                                        color:
                                            Color.fromARGB(255, 42, 238, 245)),
                                    SizedBox(height: h * 0.005),
                                    Text(" ${pitch['players']} ",
                                        style: TextStyle(
                                            fontSize: pitch['players']
                                                        .toString()
                                                        .length >
                                                    3
                                                ? size.width > 605
                                                    ? 18
                                                    : size.width > 385
                                                        ? 11
                                                        : 6
                                                : size.width > 605
                                                    ? 16
                                                    : size.width > 385
                                                        ? 13
                                                        : 8,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.aspect_ratio,
                                        color:
                                            Color.fromARGB(255, 11, 158, 23)),
                                    SizedBox(height: h * 0.005),
                                    Text(" ${pitch['size']} ",
                                        style: TextStyle(
                                            fontSize: pitch['size']
                                                        .toString()
                                                        .length >
                                                    5
                                                ? size.width > 605
                                                    ? 18
                                                    : size.width > 385
                                                        ? 11
                                                        : 6
                                                : size.width > 605
                                                    ? 16
                                                    : size.width > 385
                                                        ? 13
                                                        : 8,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.euro, color: Colors.white),
                                    SizedBox(height: h * 0.005),
                                    Text(' ${pitch['price']} ',
                                        style: TextStyle(
                                            fontSize: pitch['price']
                                                        .toString()
                                                        .length >
                                                    2
                                                ? size.width > 605
                                                    ? 18
                                                    : size.width > 385
                                                        ? 11
                                                        : 6
                                                : size.width > 605
                                                    ? 16
                                                    : size.width > 385
                                                        ? 13
                                                        : 8,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ])
                        ])),
                  ])
                  //)
                  )
            ]),
          )
        ],
      )
    ]);
  }
}
