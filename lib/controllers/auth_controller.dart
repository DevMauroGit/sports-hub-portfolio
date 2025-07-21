import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sports_hub_ios/controllers/profile_controller.dart';
import 'package:sports_hub_ios/models/appointment_model.dart';
import 'package:sports_hub_ios/models/user_model.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/login_page.dart';
import 'package:sports_hub_ios/page/signup_page.dart';
import 'package:sports_hub_ios/page/start_page.dart';
import 'package:sports_hub_ios/page/verify_email_page.dart';
import 'package:sports_hub_ios/page/verify_phone_page_start.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  static ProfileController profile = Get.find();

  Rx<User?>? firebaseUser;
  final auth = FirebaseAuth.instance;
  bool isEmailVerified = false;
  bool isUserCreated = false;
  Timer? timer;
  get mail => null;
  late FirebaseAuth _auth;
  late Stream<User?> _authStateChanges;
  final user = FirebaseAuth.instance.currentUser;

  /// Initialize Firebase Auth and set up listener for auth state changes
  void initAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    _auth = FirebaseAuth.instance;
    _authStateChanges = _auth.authStateChanges();
    _authStateChanges.listen((User? user) {
      firebaseUser?.value = user;
    });
  }

  /// Bind auth state to `firebaseUser` observable and handle navigation on changes
  @override
  void onReady() {
    super.onReady();

    if (user != null) {
      getDocId();
      getToken();
    }
    firebaseUser = Rx<User?>(user);
    firebaseUser?.bindStream(auth.userChanges());
    ever(firebaseUser!, _initialScreen);
  }

  /// Direct user to proper screen based on authentication and verification status
  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const StartPage());
    } else {
      user.emailVerified
          ? user.phoneNumber != null && user.phoneNumber!.length >= 4
              ? Get.offAll(() => const HomePage())
              : Get.offAll(() => const VerifyPhonePageStart())
          : Get.offAll(() => const VerifyEmailPage());
    }
  }

  /// Retrieve FCM token and call function to save it in Firestore
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      mtoken = token!;
      print('My token is $mtoken');
      saveToken(token);
    });
  }

  /// Store user's FCM token into their Firestore document
  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .update({'token': token});
  }

  /// Request notification permissions from the user
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permissions');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permissions');
    }
  }

  /// Retrieve Firestore document IDs for the current authenticated user
  Future getDocId() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    await FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIds.add(document.reference.id);
            }));
  }

  /// Sign up user with email/password, then create their profile in Firestore
  void signUp(String email, password, username, phone, city, w) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final fireUser = FirebaseAuth.instance.currentUser!;
      String firePhotoProfile =
          "https://...footballer.png";
      String firePhotoCover =
          "https://...stadium_black.jpg";

      final user = UserModel(
        id: fireUser.uid,
        email: email,
        phoneNumber: phone,
        password: password,
        username: username,
        city: city,
        profile_pic: firePhotoProfile,
        cover_pic: firePhotoCover,
        isEmailVerified: false,
        games: 0,
        goals: 0,
        win: 0,
        games_tennis: 0,
        set_vinti: 0,
        win_tennis: 0,
        prenotazioni: 0,
        prenotazioniPremium: 0,
        token: '',
      );
      AuthController.instance.createUser(user).whenComplete(() {
        Get.snackbar('', "",
            snackPosition: SnackPosition.TOP,
            titleText: Text(
              'Il tuo Account è stato creato',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontSize: w < 380
                      ? 13
                      : w > 605
                          ? 18
                          : 15),
            ),
            messageText: Text(
              'Verificalo per poter accedere',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontSize: w < 380
                      ? 13
                      : w > 605
                          ? 18
                          : 15),
            ),
            duration: const Duration(seconds: 4),
            backgroundColor: kPrimaryColor.withOpacity(0.6),
            colorText: Colors.black);
        isLoadingS = false;
      }).catchError((error, StackTrace) {
        Get.snackbar('', "",
            snackPosition: SnackPosition.TOP,
            titleText: Text(
              'Qualcosa è andato storto',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontSize: w < 380
                      ? 13
                      : w > 605
                          ? 18
                          : 15),
            ),
            messageText: Text(
              'Prova ancora',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontSize: w < 380
                      ? 13
                      : w > 605
                          ? 18
                          : 15),
            ),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.redAccent.withOpacity(0.6),
            colorText: Colors.black);
        print(error.toString());
        Get.offAll(() => SignUpPage());
      });
    } catch (e) {
      Get.offAll(() => SignUpPage());
      Get.snackbar('', "",
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'Email gia registrata',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                fontSize: w < 380
                    ? 13
                    : w > 605
                        ? 18
                        : 15),
          ),
          messageText: Text(
            'Prova ad accedere',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                fontSize: w < 380
                    ? 13
                    : w > 605
                        ? 18
                        : 15),
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.redAccent.withOpacity(0.6),
          colorText: Colors.black);
    }
    isLoadingS = false;
  }

  /// Create a new user document in Firestore using the provided UserModel
  Future<void> createUser(UserModel user) async {
    await FirebaseFirestore.instance.collection("User").doc(user.email).set({
      "id": user.id,
      "username": user.username,
      "email": user.email,
      'phoneNumber': user.phoneNumber,
      "city": user.city,
      "password": user.password,
      "profile_pic": user.profile_pic,
      "cover_pic": user.cover_pic,
      "isEmailVerified": user.isEmailVerified,
      "games": user.games,
      "goals": user.goals,
      "win": user.win,
      'games_tennis': user.games_tennis,
      'set_vinti': user.set_vinti,
      'win_tennis': user.win_tennis,
      'prenotazioni': user.prenotazioni,
      'prenotazioniPremium': user.prenotazioniPremium,
      'token': user.token
    });
  }

  /// Store verified phone user data into Firestore collection "Phone"
  Future<void> createPhoneVerified(Map user) async {
    await FirebaseFirestore.instance
        .collection("Phone")
        .doc(user['phoneNumber'])
        .set({
      "id": user['id'],
      "username": user['username'],
      "email": user['email'],
      'phoneNumber': user['phoneNumber'],
      "city": user['city'],
      "password": user['password'],
    });
  }

  /// Add a deletion request entry for a user in Firestore
  Future<void> createDeleteRequest(Map user) async {
    await FirebaseFirestore.instance
        .collection("Delete")
        .doc(user['email'])
        .set({
      "id": user['id'],
      "username": user['username'],
      "email": user['email'],
      'phoneNumber': user['phoneNumber'],
      "city": user['city'],
      "password": user['password'],
    });
  }

  /// Update user profile information in Firestore (include isEmailVerified=true)
  Future<void> updateUser(UserModel user) async {
    await FirebaseFirestore.instance.collection("User").doc(user.email).update({
      "id": user.id,
      "username": user.username,
      "email": user.email,
      "city": user.city,
      "password": user.password,
      "profile_pic": user.profile_pic,
      "cover_pic": user.cover_pic,
      "isEmailVerified": true
    });
  }

  /// Create a new appointment document under the specified user's sub-collection
  Future<void> createAppointment(
      String user, AppointmentModel appointment) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(user)
        .collection('Appointment')
        .doc(
            "${appointment.club}-${appointment.month}-${appointment.day}${appointment.time}")
        .set({
      "user": user,
      "club": appointment.club,
      "month": appointment.month,
      "day": appointment.day,
      "time": appointment.time,
      "date":
          "${appointment.club}-${appointment.month}-${appointment.day}${appointment.time}",
      "playerCount": appointment.playerCount
    });
  }

  /// Update existing appointment by adding a new player and incrementing counter
  Future<void> updateAppointment(
      String user, AppointmentModel appointment, String newPlayer) async {
    int count = appointment.playerCount + 1;
    await FirebaseFirestore.instance
        .collection("User")
        .doc(user)
        .collection('Appointment')
        .doc(
            "${appointment.club}-${appointment.month}-${appointment.day}${appointment.time}")
        .set({
      "player": user,
      "club": appointment.club,
      "month": appointment.month,
      "day": appointment.day,
      "time": appointment.time,
      "date":
          "${appointment.club}-${appointment.month}-${appointment.day}${appointment.time}",
      "playerCount": count,
    });

    await FirebaseFirestore.instance
        .collection("User")
        .doc(user)
        .collection('Appointment')
        .doc(
            "${appointment.club}-${appointment.month}-${appointment.day}${appointment.time}")
        .collection('Team 1')
        .doc('Teammate ${appointment.playerCount}')
        .set({
      "player": newPlayer,
    });
  }

  /// Sign in using Google and save user profile information to Firestore
  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        final gAuthentication = await account.authentication;
        final credential = GoogleAuthProvider.credential(
            idToken: gAuthentication.idToken,
            accessToken: gAuthentication.accessToken);
        await _auth.signInWithCredential(credential);
        await saveUser(account);
      }
    } on Exception {
      Get.snackbar(
        "About User",
        "User message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.TOP,
        titleText: const Text(
          "Registrazione fallita",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      );
    }
  }

  /// Store Google account information in Firestore collection "Google users"
  Future<void> saveUser(GoogleSignInAccount account) async {
    FirebaseFirestore.instance
        .collection("Google users")
        .doc(account.displayName)
        .set({
      "email": account.email,
      "username": account.displayName,
      "profilepic": account.photoUrl
    });
  }

  /// Authenticate with email/password and update profile upon success
  void login(String email, password, context, w) async {
    final controller = Get.put(ProfileController());
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error, StackTrace) {
          Get.snackbar('', "",
              snackPosition: SnackPosition.TOP,
              titleText: Text(
                'Accesso non riuscito',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontSize: w < 380
                      ? 13
                      : w > 605
                          ? 18
                          : 15,
                  color: Colors.black,
                ),
              ),
              messageText: Text(
                'credenziali errate',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontSize: w < 380
                      ? 13
                      : w > 605
                          ? 18
                          : 15,
                  color: Colors.black,
                ),
              ),
              duration: const Duration(seconds: 4),
              backgroundColor: Colors.redAccent.withOpacity(0.6),
              colorText: Colors.black);

          print(error.toString());
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const LoginPage()));
          return error;
        })
        .whenComplete(() async {
          isLoading = false;
          final snapshot = await FirebaseFirestore.instance
              .collection("User")
              .where('email' == email)
              .get();
          final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
          final user = UserModel(
            id: userData.id,
            email: userData.email,
            phoneNumber: userData.phoneNumber,
            password: password,
            username: userData.username,
            city: userData.city,
            profile_pic: userData.profile_pic,
            cover_pic: userData.cover_pic,
            isEmailVerified: true,
            games: userData.games,
            goals: userData.goals,
            win: userData.win,
            games_tennis: userData.games_tennis,
            set_vinti: userData.set_vinti,
            win_tennis: userData.win_tennis,
            prenotazioni: userData.prenotazioni,
            prenotazioniPremium: userData.prenotazioniPremium,
            token: userData.token,
          );
          await controller.updateUser(user);
        });
  }
}
