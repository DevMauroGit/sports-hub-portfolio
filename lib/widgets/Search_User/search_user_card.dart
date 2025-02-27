import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/models/user_model.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/page/visit_profile_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class SearchUserCard extends StatelessWidget {
  const SearchUserCard({
    super.key,
    required this.user,
    required this.allFriends,
  });

  final UserModel user;
  final List allFriends;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double w = size.width;

    String email = FirebaseAuth.instance.currentUser!.email.toString();

    int c = 0;
    bool friend = false;
    for (int i = 0; i < allFriends.length; i++) {
      user.email != allFriends[i].email ? c++ : null;
    }
    c != allFriends.length ? friend = false : friend = true;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            user.email == email
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              docIds: email,
                              avviso: false,
                              sport: 'football',
                            )))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VisitProfilePage(
                              userFriend: user.email,
                              showRequest: friend,
                            )));
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    //right: kDefaultPadding,
                    //left: kDefaultPadding,
                    top: kDefaultPadding,
                    //bottom: kDefaultPadding * 15,
                  ),
                  padding: const EdgeInsets.all(0),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  width: size.width * 0.8,
                  height: size.height * 0.2,
                  child: CachedNetworkImage(
                    imageUrl: user.profile_pic!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              alignment: Alignment.center)),
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
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(children: <Widget>[
                      Container(
                          width: size.width * 0.8,
                          height: size.height * 0.08,
                          margin: const EdgeInsets.only(
                              //left: kDefaultPadding,
                              //right: kDefaultPadding,
                              // top: kDefaultPadding,
                              //bottom: kDefaultPadding * 15,
                              ),
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, top: 15),
                          decoration: const BoxDecoration(
                            color: kBackgroundColor2,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(children: <Widget>[
                            Text(user.username,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: w > 380 ? 18 : 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ])),
                    ])
                    //)
                    )
              ]),
        )
      ],
    );
  }
}
