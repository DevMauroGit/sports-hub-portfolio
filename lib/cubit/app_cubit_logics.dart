import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_hub_ios/cubit/app_cubit_states.dart';
import 'package:sports_hub_ios/cubit/app_cubits.dart';
import 'package:sports_hub_ios/widgets/loading_screen.dart';

class AppCubitLogics extends StatefulWidget {
  const AppCubitLogics({super.key});

  @override
  State<AppCubitLogics> createState() => _AppCubitLogicsState();
}

class _AppCubitLogicsState extends State<AppCubitLogics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use BlocBuilder to rebuild UI in response to state changes in AppCubits
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          if (state is WelcomeState) {
            // Show loading screen on WelcomeState
            return const LoadingScreen();
          } else {
            // Fallback UI, currently also loading screen
            return const LoadingScreen();
          }
        },
      ),
    );
  }
}
