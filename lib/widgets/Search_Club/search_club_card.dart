import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/page/club_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/register_memo.dart';

class SearchClubCard extends StatelessWidget {
  const SearchClubCard({super.key, required this.clubs, required this.ospite});

  final Map clubs;
  final bool ospite;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            ospite
                ? clubs['premium']
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClubDetailPage(
                                  clubs: clubs,
                                  ospite: ospite,
                                )),
                      )
                    : Navigator.of(context)
                        .push(HeroDialogRoute(builder: (context) {
                        return RegisterMemo(
                          h: size.height,
                          w: size.width,
                        );
                      }))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClubDetailPage(
                              clubs: clubs,
                              ospite: ospite,
                            )),
                  );
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: kDefaultPadding,
                  ),
                  padding: const EdgeInsets.all(0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  width: size.width * 0.8,
                  height: size.height * 0.13,
                  child: Stack(children: [
                    CachedNetworkImage(
                      imageUrl: clubs['image'],
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
                      //errorWidget: (context, url, error) => Image.asset("assets/images/arena.jpg")
                    ),
                    clubs['premium']
                        ? Positioned(
                            right: 10,
                            bottom: 5,
                            child: Icon(
                              Icons.star,
                              color: Colors.yellow[300],
                              size: 20,
                            ))
                        : Container(),
                  ]),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(children: <Widget>[
                      Container(
                          width: size.width * 0.8,
                          height: size.height > 700
                              ? size.height * 0.08
                              : size.height * 0.13,
                          margin: const EdgeInsets.only(),
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, top: 15),
                          decoration: const BoxDecoration(
                            color: kBackgroundColor2,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: const BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: const Icon(
                                    Icons.sports_soccer,
                                    size: 25,
                                  )),
                              Column(children: [
                                Text(clubs['title'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: size.width > 605
                                            ? 20
                                            : size.width > 385
                                                ? 14
                                                : 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: size.height * 0.008),
                                Text(clubs['city'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: size.width > 605
                                            ? 15
                                            : size.width > 385
                                                ? 10
                                                : 8,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal))
                              ]),
                              Container(
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor.withOpacity(0.9),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: const Icon(
                                    Icons.sports_tennis,
                                    size: 25,
                                  ))
                            ],
                          )),
                    ])
                    //)
                    )
              ]),
        )
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
  }
}
