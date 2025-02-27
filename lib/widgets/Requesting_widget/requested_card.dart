import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/hero_dialogue/hero_dialogue_route.dart';
import 'package:sports_hub_ios/models/friend_model.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';

class RequestedCard extends StatefulWidget {
  const RequestedCard({
    super.key,
    required this.user,
    required this.userController,
  });

  final FriendModel user;
  final UserController userController;

  @override
  State<RequestedCard> createState() => _RequestedCardState();
}

class _RequestedCardState extends State<RequestedCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    String email = FirebaseAuth.instance.currentUser!.email.toString();

    return SizedBox(
        height: h * 0.085,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: h * 0.1,
                width: w * 0.8,
                child: Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.user.profile_pic!,
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          fit: BoxFit.fill,
                          width: w * 0.15,
                          height: h > 700 ? h * 0.06 : h * 0.075,
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    Text(
                      widget.user.username,
                      style: TextStyle(
                          letterSpacing: 2,
                          fontSize: w > 385
                              ? widget.user.username.length > 8
                                  ? 10
                                  : widget.user.username.length > 6
                                      ? 12
                                      : 14
                              : widget.user.username.length > 10
                                  ? 8
                                  : widget.user.username.length > 8
                                      ? 9
                                      : widget.user.username.length > 5
                                          ? 11
                                          : 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Spacer(),
                    //     SizedBox(
                    //       width: (20 - widget.user.username.length).toDouble()),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context)
                            .push(HeroDialogRoute(builder: (context) {
                          return const LoadingScreen();
                        }));

                        await FirebaseFirestore.instance
                            .collection("User")
                            .doc(email)
                            .collection('Friends')
                            .doc(widget.user.email)
                            .update({'isRequested': 'false'});
                        await FirebaseFirestore.instance
                            .collection("User")
                            .doc(widget.user.email)
                            .collection('Friends')
                            .doc(email)
                            .update({'isRequested': 'false'});

                        widget.userController.allRequest.clear();

                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      docIds: email,
                                      avviso: false,
                                      sport: 'football',
                                    )
                                //               FriendsPage(docIds: email, h: h, w: w, future: FirebaseFirestore.instance
                                // .collection('User')
                                // .doc(email)
                                // .collection('Friends')
                                // .where('isRequested', isEqualTo: 'false')
                                // .get(),
                                //)
                                ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: h > 700 ? h * 0.026 : h * 0.031,
                        width: w > 380 ? w * 0.15 : w * 0.17,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text('ACCETTA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: w > 380 ? 11 : 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context)
                            .push(HeroDialogRoute(builder: (context) {
                          return const LoadingScreen();
                        }));

                        await FirebaseFirestore.instance
                            .collection("User")
                            .doc(email)
                            .collection('Friends')
                            .doc(widget.user.email)
                            .delete();
                        await FirebaseFirestore.instance
                            .collection("User")
                            .doc(widget.user.email)
                            .collection('Friends')
                            .doc(email)
                            .delete();

                        widget.userController.allRequest.clear();

                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      docIds: email,
                                      avviso: false,
                                      sport: 'football',
                                    )
                                //               FriendsPage(docIds: email, h: h, w: w, future: FirebaseFirestore.instance
                                // .collection('User')
                                // .doc(email)
                                // .collection('Friends')
                                // .where('isRequested', isEqualTo: 'false')
                                // .get(),
                                //)
                                ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: h > 700 ? h * 0.026 : h * 0.031,
                        width: w > 380 ? w * 0.15 : w * 0.17,
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text('RIFIUTA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: w > 380 ? 11 : 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ]));
  }
}
