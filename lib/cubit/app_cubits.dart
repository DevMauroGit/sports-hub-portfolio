import 'package:bloc/bloc.dart';
import 'package:sports_hub_ios/cubit/app_cubit_states.dart';

/// Cubit class that manages the app states.
/// Starts from InitialState and immediately emits WelcomeState.
class AppCubits extends Cubit<CubitStates> {
  AppCubits() : super(InitialState()) {
    // Transition to WelcomeState right after initialization
    emit(WelcomeState());
  }
}
