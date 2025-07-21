import 'package:equatable/equatable.dart';
import 'package:sports_hub_ios/controllers/club_controller.dart';

/// Abstract base class for all Cubit states.
/// Extends Equatable for easy state comparisons.
abstract class CubitStates extends Equatable {}

/// Initial state when the Cubit starts.
/// Contains a reference to a ClubController instance.
class InitialState extends CubitStates {
  late ClubController club;

  @override
  List<Object?> get props => [club];
}

/// Welcome state, typically the first UI state shown.
class WelcomeState extends CubitStates {
  @override
  List<Object?> get props => [];
}
