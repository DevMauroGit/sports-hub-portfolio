import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/page/club_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class ClubCard extends StatelessWidget {
  // Constructor requires club data map and a boolean flag "ospite"
  const ClubCard({
    super.key,
    required this.clubs,
    required this.ospite,
  });

  final Map clubs;
  final bool ospite;

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    Size size = MediaQuery.of(context).size;
    double w = size.width;
    double h = size.height;

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              // Navigate to ClubDetailPage on tap, passing club info and ospite flag
              onTap: () {
                Get.to(
                  () => ClubDetailPage(
                    clubs: clubs,
                    ospite: ospite,
                  ),
                  transition: Transition.zoom,
                );
              },
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      right: kDefaultPadding,
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
                    // Width and height adjust based on screen size
                    width: w > 385 ? size.width * 0.3 : size.width * 0.33,
                    height: h > 700 ? size.height * 0.1 : h * 0.12,
                    child: Stack(
                      children: [
                        // Display club image fetched from network with caching
                        CachedNetworkImage(
                          imageUrl: clubs['image'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          // Show loading spinner while image loads
                          placeholder: (context, url) => Container(
                            padding: const EdgeInsets.all(0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          ),
                          // Optionally, you could add an error widget here if image fails to load
                        ),

                        // If the club is premium, show a star icon positioned at bottom right
                        clubs['premium']
                            ? Positioned(
                                right: 10,
                                bottom: 5,
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellow[300],
                                  size: 20,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),

                  // Container below image showing club title and icons for sports offered
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: w > 385 ? size.width * 0.3 : size.width * 0.33,
                      height: h > 700
                          ? size.height * 0.09
                          : h < 675
                              ? h * 0.12
                              : h * 0.14,
                      margin: const EdgeInsets.only(
                        right: kDefaultPadding,
                      ),
                      decoration: const BoxDecoration(
                        color: kBackgroundColor2,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          // Display the club's title text with dynamic font size based on length and width
                          Container(
                            padding: EdgeInsets.only(
                              right: w > 385 ? 5 : 10,
                              left: w > 385 ? 5 : 10,
                              top: 8,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              clubs['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: clubs['title'].toString().length > 14
                                    ? (w > 385 ? 11 : 9)
                                    : clubs['title'].toString().length > 10
                                        ? (w > 385 ? 12 : 9)
                                        : (w > 385 ? 13 : 10),
                                letterSpacing: 1,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Row displaying sports icons and the city name
                          Container(
                            padding:
                                const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Football icon displayed only if club offers football
                                clubs['football']
                                    ? Container(
                                        width: 17,
                                        height: 17,
                                        decoration: const BoxDecoration(
                                          color: kBackgroundColor2,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.sports_soccer,
                                            size: 13,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 17,
                                        height: 17,
                                      ),

                                // Display city name with responsive font size
                                Text(
                                  clubs['city'],
                                  style: TextStyle(
                                    fontSize: w > 605
                                        ? 18
                                        : w > 385
                                            ? 13
                                            : 9,
                                    letterSpacing: 1,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                // Tennis icon displayed only if club offers tennis
                                clubs['tennis']
                                    ? Container(
                                        width: 17,
                                        height: 17,
                                        decoration: const BoxDecoration(
                                          color: kBackgroundColor2,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor.withOpacity(0.9),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.sports_tennis,
                                            size: 13,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 17,
                                        height: 17,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper function to show a simple loading dialog with a spinner
  Future<void> _dialogBuilder(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Delay for 2 seconds before closing the dialog
    Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
  }
}
