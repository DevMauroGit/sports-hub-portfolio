import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sports_hub_ios/controllers/auth_controller.dart';
import 'package:sports_hub_ios/controllers/games_controller.dart';
import 'package:sports_hub_ios/cubit/auth_cubit.dart';
import 'package:sports_hub_ios/firebase_options.dart';
import 'package:sports_hub_ios/page/edit_phone_page.dart';
import 'package:sports_hub_ios/page/football_management_page.dart';
import 'package:sports_hub_ios/page/football_results_page.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/login_page.dart';
import 'package:sports_hub_ios/page/ospite_page.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/page/signup_page.dart';
import 'package:sports_hub_ios/page/start_page.dart';
import 'package:sports_hub_ios/page/tennis_result_page.dart';
import 'package:sports_hub_ios/page/verify_email_page.dart';
import 'package:sports_hub_ios/page/verify_phone_page.dart';
import 'package:sports_hub_ios/page/verify_phone_page_start.dart';
import 'package:sports_hub_ios/utils/constants.dart';

/// Entry point of the app - initializes Firebase, messaging, and app check,
/// then sets device orientation and configures app routing.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase app with platform-specific options
  await Firebase.initializeApp(
    name: 'Sports-Hub',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Prepare to handle any initial notification message if app opened from notification
  await FirebaseMessaging.instance.getInitialMessage();

  // Register background message handler for Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Activate Firebase App Check with platform-specific providers for security
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );

  // Obtain APNs token for iOS push notifications
  await FirebaseMessaging.instance.getAPNSToken();

  // Force portrait orientation and then set up app router and run the app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      // Define app routes and their corresponding pages
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const StartPage()),
          GoRoute(
              path: '/login', builder: (context, state) => const LoginPage()),
          GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(
              path: '/verify-email',
              builder: (context, state) => const VerifyEmailPage()),
          GoRoute(
              path: '/verify-phone',
              builder: (context, state) => const VerifyPhonePageStart()),

          // Route that extracts parameters from navigation extras for VerifyPhonePage
          GoRoute(
            path: '/verify-phone-page',
            builder: (context, state) {
              final Map<String, dynamic> data =
                  state.extra as Map<String, dynamic>;
              final double h = data['h'];
              final double w = data['w'];
              final Size size = data['size'];

              return VerifyPhonePage(h: h, w: w, size: size);
            },
          ),

          GoRoute(
              path: '/signup', builder: (context, state) => const SignUpPage()),
          GoRoute(
              path: '/login', builder: (context, state) => const LoginPage()),

          // Route for OspitePage with parameters passed through navigation extras
          GoRoute(
            path: '/ospite',
            builder: (context, state) {
              final Map<String, dynamic> data =
                  state.extra as Map<String, dynamic>;
              final String city = data['city'];
              final double h = data['h'];
              final double w = data['w'];
              final String page = data['page'];

              return OspitePage(city: city, h: h, w: w, page: page);
            },
          ),

          // Route for editing phone number, passing UI dimensions and size as parameters
          GoRoute(
            path: '/edit-number',
            builder: (context, state) {
              final Map<String, dynamic> data =
                  state.extra as Map<String, dynamic>;
              final double h = data['h'];
              final double w = data['w'];
              final Size size = data['size'];

              return EditNumberPage(h: h, w: w, size: size);
            },
          ),

          // Profile page route passing document IDs, notification flag, and sport type
          GoRoute(
            path: '/profile',
            builder: (context, state) {
              final Map<String, dynamic> data =
                  state.extra as Map<String, dynamic>;
              final String docIds = data['docIds'];
              final bool avviso = data['avviso'];
              final String sport = data['sport'];

              return ProfilePage(docIds: docIds, avviso: avviso, sport: sport);
            },
          ),

          // Football management creation page with profile and game controller parameters
          GoRoute(
            path: '/create-management',
            builder: (context, state) {
              final Map<String, dynamic> data =
                  state.extra as Map<String, dynamic>;
              final String profile = data['profile'];
              final GameController gameController = data['gameController'];

              return FootballCreateManagementPage(
                  profile: profile, gameController: gameController);
            },
          ),

          // Football results page route with appointment data
          GoRoute(
            path: '/football-results',
            builder: (context, state) {
              final Map<String, dynamic> data =
                  state.extra as Map<String, dynamic>;
              final Map appointment = data['appointment'];

              return FootballResultsPage(
                  appointment: appointment, create: true);
            },
          ),

          // Tennis results page route with appointment data
          GoRoute(
            path: '/tennis-results',
            builder: (context, state) {
              final Map<String, dynamic> data =
                  state.extra as Map<String, dynamic>;
              final Map appointment = data['appointment'];

              return TennisResultsPage(appointment: appointment);
            },
          ),
        ],
      );

      // Initialize BlocProvider for authentication state management and run the app
      runApp(
        BlocProvider(
          create: (context) {
            final authCubit = AuthCubit();
            authCubit.checkUserStatus(
                router); // Check user authentication and redirect accordingly
            return authCubit;
          },
          child: MyApp(router: router),
        ),
      );
    },
  );
}

/// Background handler for Firebase Messaging when app is in background or terminated
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

/// Main app widget that sets up MaterialApp with router configuration
class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
