import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/firebase_storage/firebase_storage_service.dart';
import 'package:sports_hub_ios/models/friend_model.dart';
import 'package:sports_hub_ios/models/user_model.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Friend/friends_carousel.dart';
import 'package:sports_hub_ios/widgets/Requesting_widget/requested_widget.dart';
import 'package:sports_hub_ios/widgets/Search_User/search_user_card.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage(
      {super.key,
      required this.docIds,
      required this.h,
      required this.w,
      required this.future});

  final String docIds;
  final double h;
  final double w;
  final Future future;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final double coverHeight = 250;
  final double profileHeight = 144;

  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String profile = docIds.first;
  CollectionReference user = FirebaseFirestore.instance.collection('User');

  UserController userController = Get.put(UserController());

  @override
  void initState() {
    allFriendsData.clear();
    allFriends.clear();
    super.initState();
  }

  var textController = TextEditingController();

  final List allFriends = [];
  List allFriendsData = [];
  final List allRequest = [];
  bool showFriends = false;

  String sport = 'football';

  List fList = [];

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBarFriends(context),
            bottomNavigationBar: BottomBar(
              context,
            ),
            body: SizedBox(
                height: widget.h * 1.5 * (userController.allRequest.length + 1),
                width: widget.w,
                child: FutureBuilder(
                    future: widget.future,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('errore caricamento dati');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          margin: const EdgeInsets.all(kDefaultPadding),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final friendList = snapshot.data!.docs
                            .map((friends) => FriendModel.fromSnapshot(friends))
                            .toList();
                        allFriends.assignAll(friendList);
                      }

                      return SingleChildScrollView(
                          child: Center(
                              child: Column(children: [
                        SizedBox(height: widget.h * 0.02),
                        Container(
                          width: widget.w * 0.9,
                          height: (widget.h - 1) *
                              0.1 *
                              (userController.allRequest.length + 1),
                          decoration: const BoxDecoration(
                            color: kBackgroundColor2,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: widget.h * 0.02),
                              Text(
                                'Richieste in sospeso',
                                style: TextStyle(
                                    fontSize: widget.w > 605
                                        ? 22
                                        : widget.w > 385
                                            ? 16
                                            : 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              SizedBox(height: widget.h * 0.01),
                              SizedBox(
                                height: (widget.h - 1) *
                                        0.1 *
                                        userController.allRequest.length +
                                    1,
                                width: widget.w * 0.9,
                                child: FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(email)
                                        .collection('Friends')
                                        .where('isRequested', isEqualTo: 'true')
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        print('errore caricamento dati');
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              right: kDefaultPadding,
                                              left: kDefaultPadding),
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      } else if (snapshot.hasData) {
                                        final friendList = snapshot.data!.docs
                                            .map((friends) =>
                                                FriendModel.fromSnapshot(
                                                    friends))
                                            .toList();
                                        allRequest.assignAll(friendList);
                                        print('carousel has data');
                                      }

                                      return RequestedWidget(
                                          users: userController,
                                          allRequest: allRequest);
                                    }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: widget.w > 385
                                ? widget.h * 0.02
                                : widget.h * 0.025),
                        Container(
                            margin: EdgeInsets.only(
                                top: widget.h * 0.03,
                                left: widget.h * 0.04,
                                right: widget.h * 0.04),
                            //height: h*0.8,
                            width: widget.w * 0.95,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cerca i tuoi compagni',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: widget.w > 605
                                            ? 25
                                            : widget.w > 385
                                                ? 19
                                                : 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                SizedBox(height: widget.h * 0.01),
                                TextFormField(
                                  //key: _formKey,
                                  controller: textController,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: widget.w > 605
                                        ? 25
                                        : widget.w > 385
                                            ? 16
                                            : 12,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: email,
                                      prefixIcon: const Icon(Icons.person,
                                          color: kPrimaryColor),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0)),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(email)
                                      ? 'Inserisci una Email valida'
                                      : null,
                                ),
                                SizedBox(
                                    height: widget.w > 385
                                        ? widget.h * 0.01
                                        : widget.h * 0.015),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 15),
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      if (textController.text.trim().isEmail) {
                                        userSearched =
                                            textController.text.trim();
                                      }

                                      userController =
                                          Get.put(UserController());
                                      Get.lazyPut(
                                          () => FirebaseStorageService());
                                    });
                                    userController = Get.put(UserController());

                                    //  Navigator.push(context, MaterialPageRoute(
                                    //   builder: (context) => FriendsPage2()));
                                  },
                                  child: Text(
                                    "Cerca",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: widget.w > 605
                                            ? 25
                                            : widget.w > 385
                                                ? 16
                                                : 13,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            )),
                        GetSearchedUser(
                          documentId: userSearched,
                          userController: userController,
                          h: widget.h,
                          w: widget.w,
                          allFriends: allFriends,
                        ),
                        SizedBox(height: widget.h * 0.02),
                        DisplayFriend(
                            h: widget.h, w: widget.w, allFriends: allFriends)
                      ])));
                    }))));
  }
}

class GetSearchedUser extends StatefulWidget {
  final String documentId;
  final UserController userController;
  final double h;
  final double w;
  final List allFriends;

  const GetSearchedUser(
      {super.key,
      required this.documentId,
      required this.userController,
      required this.h,
      required this.w,
      required this.allFriends});

  @override
  State<GetSearchedUser> createState() => _GetSearchedUserState();
}

class _GetSearchedUserState extends State<GetSearchedUser> {
  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('User');
    String email = FirebaseAuth.instance.currentUser!.email.toString();

    print(widget.allFriends);

    return FutureBuilder<DocumentSnapshot>(
        future: user.doc(userSearched).get(),
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.data() != null) {
                Map<String, dynamic> profile =
                    snapshot.data!.data() as Map<String, dynamic>;

                if (profile.isNotEmpty) {
                  UserModel searchedFriend = UserModel(
                    username: profile['username'],
                    id: profile['id'],
                    email: profile['email'],
                    phoneNumber: profile['phoneNumber'],
                    city: profile['city'],
                    password: profile['password'],
                    profile_pic: profile['profile_pic'],
                    cover_pic: profile['cover_pic'],
                    isEmailVerified: profile['isEmailVerified'],
                    games: profile['games'],
                    goals: profile['goals'],
                    win: profile['win'],
                    games_tennis: profile['games_tennis'],
                    set_vinti: profile['set_vinti'],
                    win_tennis: profile['win_tennis'],
                    prenotazioni: profile['prenotazioni'],
                    prenotazioniPremium: profile['prenotazioniPremium'],
                    token: '',
                  );

                  if (profile['username'] != null &&
                      profile['email'] != email) {
                    return SizedBox(
                        height: widget.h * 0.4,
                        width: widget.w * 0.6,
                        child: SearchUserCard(
                          user: searchedFriend,
                          allFriends: widget.allFriends,
                        ));
                  } else {
                    profile['email'] != email
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'utente non trovato',
                              style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 22
                                    : widget.w > 355
                                        ? 16
                                        : 13,
                              ),
                            ),
                          )
                        : Container();
                  }
                }
                return Container();
                //return Container();
              }
            }
          }
          if (userSearched == email) {
            return Container();
          }
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              'utente non trovato',
              style: TextStyle(
                color: Colors.black,
                fontSize: widget.w > 605
                    ? 22
                    : widget.w > 355
                        ? 16
                        : 13,
              ),
            ),
          );
        })));
  }
}

class DisplayFriend extends StatefulWidget {
  const DisplayFriend(
      {super.key, required this.h, required this.w, required this.allFriends});

  final double h;
  final double w;
  final List allFriends;

  @override
  State<DisplayFriend> createState() => _DisplayFriendState();
}

class _DisplayFriendState extends State<DisplayFriend> {
  List allFriendsData = [];
  bool showFriends = false;
  String sport = 'football';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                showFriends = true;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: widget.w * 0.12,
                  height: widget.h * 0.06,
                  decoration: const BoxDecoration(
                      color: kBackgroundColor2,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    children: [
                      SizedBox(height: widget.h * 0.01),
                      Container(
                          decoration: BoxDecoration(
                              color: sport == 'football'
                                  ? kPrimaryColor
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  sport = 'football';
                                });
                              },
                              child: Icon(
                                Icons.sports_soccer,
                                size: widget.h * 0.04,
                              ))),
                    ],
                  ),
                ),
                SizedBox(width: widget.w * 0.1),
                Text('I tuoi Amici',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: widget.w > 605
                            ? 25
                            : widget.w > 355
                                ? 16
                                : 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const Icon(Icons.arrow_drop_down_outlined),
                SizedBox(width: widget.w * 0.1),
                Container(
                  width: widget.w * 0.12,
                  height: widget.h * 0.06,
                  decoration: const BoxDecoration(
                      color: kBackgroundColor2,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    children: [
                      SizedBox(height: widget.h * 0.01),

                      GestureDetector(
                          behavior: HitTestBehavior.deferToChild,
                          onTap: () {
                            setState(() {
                              sport = 'tennis';
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: sport == 'tennis'
                                      ? kPrimaryColor
                                      : Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Icon(Icons.sports_tennis,
                                  size: widget.h * 0.04))),
                      //  SizedBox(height: h*0.01),
                      //Icon(Icons.sports_basketball, size: h*0.04)
                    ],
                  ),
                )
              ],
            )),
        SizedBox(
            //height: (h)*0.65*(userController.allRequest.length+1),
            width: widget.w * 0.7,
            child: Column(
              children: [
                SizedBox(height: widget.h * 0.02),
                for (int i = 0; i < widget.allFriends.length; i++)
                  if (widget.allFriends.isNotEmpty)
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('User')
                            .where('email',
                                isEqualTo: '${widget.allFriends[i].email}')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print('errore caricamento dati');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else if (snapshot.hasData) {
                            final friend =
                                snapshot.data!.docs.elementAt(0).data();

                            int c = 0;
                            for (int i = 0; i < allFriendsData.length; i++) {
                              if (friend != allFriendsData[i]) {
                                c++;
                              }
                            }
                            if (c == allFriendsData.length) {
                              if (allFriendsData.length <
                                  widget.allFriends.length) {
                                allFriendsData.add(friend);
                              }
                            }

                            //print('carousel has data');
                            //print('allFriendsData: $allFriendsData');
                            //print('allFriends: $allFriends');
                          }

                          return Container(
                            color: Colors.black,
                          );
                        }),
                if (showFriends == true)
                  FriendsCarousel(friends: allFriendsData, sport: sport),
                SizedBox(height: widget.h * 0.05),
              ],
            ))
      ],
    );
  }
}
