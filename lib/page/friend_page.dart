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
  // Constructor requires docIds, screen height (h), width (w) and a Future to fetch data
  const FriendsPage({
    super.key,
    required this.docIds,
    required this.h,
    required this.w,
    required this.future,
  });

  final String docIds; // Document IDs for Firestore queries
  final double h; // Screen height
  final double w; // Screen width
  final Future future; // Future for fetching friend data

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  // Heights for UI elements
  final double coverHeight = 250;
  final double profileHeight = 144;

  // Current user email retrieved from Firebase Auth
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  // Default profile is the first element of docIds string (may need fix if docIds is a string)
  String profile = docIds.first;

  // Reference to Firestore 'User' collection
  CollectionReference user = FirebaseFirestore.instance.collection('User');

  // Controller to manage user data via GetX state management
  UserController userController = Get.put(UserController());

  @override
  void initState() {
    // Clear friends data on initialization to avoid stale data
    allFriendsData.clear();
    allFriends.clear();
    super.initState();
  }

  // Controller for search input text field
  var textController = TextEditingController();

  // Lists to hold friends and requests data
  final List allFriends = [];
  List allFriendsData = [];
  final List allRequest = [];
  bool showFriends = false;

  // Sport type selection for filtering (default 'football')
  String sport = 'football';

  List fList = [];

  @override
  Widget build(BuildContext context) {
    // Build UI with scaled text for accessibility
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            appBar: TopBarFriends(context), // Custom app bar for friends page
            bottomNavigationBar:
                BottomBar(context), // Custom bottom navigation bar
            body: SizedBox(
                // Dynamic height based on number of requests to display
                height: widget.h * 1.5 * (userController.allRequest.length + 1),
                width: widget.w,
                child: FutureBuilder(
                    future: widget.future, // Load friends data asynchronously
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('Error loading data');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        // Show loading spinner while fetching data
                        return Container(
                          margin: const EdgeInsets.all(kDefaultPadding),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasData) {
                        // Parse and assign friend data from Firestore snapshot
                        final friendList = snapshot.data!.docs
                            .map((friends) => FriendModel.fromSnapshot(friends))
                            .toList();
                        allFriends.assignAll(friendList);
                      }

                      // Continue building the UI after data retrieval
                      return SingleChildScrollView(
                          child: Center(
                              child: Column(children: [
                        SizedBox(height: widget.h * 0.02),

                        // Section for pending friend requests
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
                                'Pending Requests',
                                style: TextStyle(
                                  fontSize: widget.w > 605
                                      ? 22
                                      : widget.w > 385
                                          ? 16
                                          : 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: widget.h * 0.01),

                              // Widget displaying the list of pending friend requests
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
                                      print('Error loading pending requests');
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            right: kDefaultPadding,
                                            left: kDefaultPadding),
                                        child: const Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    } else if (snapshot.hasData) {
                                      // Map snapshot data to FriendModel list
                                      final friendList = snapshot.data!.docs
                                          .map((friends) =>
                                              FriendModel.fromSnapshot(friends))
                                          .toList();
                                      allRequest.assignAll(friendList);
                                      print('Loaded pending requests');
                                    }

                                    // Custom widget showing pending friend requests
                                    return RequestedWidget(
                                        users: userController,
                                        allRequest: allRequest);
                                  },
                                ),
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
                            width: widget.w * 0.95,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title text prompting user to search for friends
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
                                // Input field where user can type an email address to search for friends
                                TextFormField(
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
                                      hintText:
                                          email, // Shows current user's email as placeholder
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
                                  // Validator checks if the input text is a valid email format
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(email)
                                      ? 'Inserisci una Email valida'
                                      : null,
                                ),
                                SizedBox(
                                    height: widget.w > 385
                                        ? widget.h * 0.01
                                        : widget.h * 0.015),
                                // Button to trigger search for user by email
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 15),
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      // If the email input is valid, assign it to userSearched variable
                                      if (textController.text.trim().isEmail) {
                                        userSearched =
                                            textController.text.trim();
                                      }

                                      // Initialize or retrieve the UserController instance
                                      userController =
                                          Get.put(UserController());
                                      // Lazily initialize FirebaseStorageService, used for user data storage
                                      Get.lazyPut(
                                          () => FirebaseStorageService());
                                    });
                                    userController = Get.put(UserController());
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
// Widget to display the searched user's information, passes necessary data
                        GetSearchedUser(
                          documentId: userSearched,
                          userController: userController,
                          h: widget.h,
                          w: widget.w,
                          allFriends: allFriends,
                        ),
                        SizedBox(height: widget.h * 0.02),
// Widget that displays the list of all friends
                        DisplayFriend(
                            h: widget.h, w: widget.w, allFriends: allFriends)
                      ])));
                    }))));
  }
}

class GetSearchedUser extends StatefulWidget {
  final String documentId; // email or ID to search user document
  final UserController userController; // controller managing user data
  final double h; // height for responsive design
  final double w; // width for responsive design
  final List allFriends; // list of current user's friends

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
    // Reference to the 'User' collection in Firestore
    CollectionReference user = FirebaseFirestore.instance.collection('User');
    // Current authenticated user's email
    String email = FirebaseAuth.instance.currentUser!.email.toString();

    print(widget.allFriends); // Debug print the list of friends

    return FutureBuilder<DocumentSnapshot>(
        future: user
            .doc(userSearched)
            .get(), // Query user document by searched email/ID
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while waiting for data
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.data() != null) {
                // Extract user profile data from document snapshot
                Map<String, dynamic> profile =
                    snapshot.data!.data() as Map<String, dynamic>;

                if (profile.isNotEmpty) {
                  // Build a UserModel object from profile data to pass to UI
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

                  // Display user card only if user found and is not the current user
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
                    // If searched user is the current user, show "user not found" message
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
              }
            }
          }
          // Do not display anything if user searches for themselves
          if (userSearched == email) {
            return Container();
          }
          // Default "user not found" message for other cases
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

  final double h; // Height of the screen, for responsive sizing
  final double w; // Width of the screen, for responsive sizing
  final List allFriends; // List of all friend user data

  @override
  State<DisplayFriend> createState() => _DisplayFriendState();
}

class _DisplayFriendState extends State<DisplayFriend> {
  List allFriendsData = []; // Local list to store detailed friend data
  bool showFriends = false; // Toggle to show/hide friends list
  String sport = 'football'; // Selected sport filter for friends display

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row with sport selection buttons and title "Your Friends"
        GestureDetector(
            onTap: () {
              setState(() {
                // When tapped, enable showing the friends list
                showFriends = true;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Football button with icon and colored background if selected
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
                                  ? kPrimaryColor // Highlight if selected
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  // Set sport filter to football on tap
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
                // Text label for the friends section
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
                const Icon(
                    Icons.arrow_drop_down_outlined), // Dropdown arrow icon
                SizedBox(width: widget.w * 0.1),
                // Tennis button similar to football button, with toggle behavior
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
                              // Change sport filter to tennis on tap
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
                    ],
                  ),
                )
              ],
            )),
        SizedBox(
            width: widget.w * 0.7,
            child: Column(
              children: [
                SizedBox(height: widget.h * 0.02),
                // Loop through allFriends and fetch detailed info from Firestore
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
                            print('Error loading friend data'); // Log errors
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Show nothing while waiting for friend data
                            return Container();
                          } else if (snapshot.hasData) {
                            // Extract friend document data from query snapshot
                            final friend =
                                snapshot.data!.docs.elementAt(0).data();

                            // Add friend data to local list if not already present
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
                          }

                          return Container(
                            color: Colors.black, // Placeholder container
                          );
                        }),
                // Conditionally display friends carousel if toggled on
                if (showFriends == true)
                  FriendsCarousel(friends: allFriendsData, sport: sport),
                SizedBox(height: widget.h * 0.05),
              ],
            ))
      ],
    );
  }
}
