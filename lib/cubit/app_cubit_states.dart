import 'package:equatable/equatable.dart';
import 'package:sports_hub_ios/controllers/club_controller.dart';

abstract class CubitStates extends Equatable {}

// ignore: must_be_immutable
class InitialState extends CubitStates {
  late ClubController club;
  @override
  List<Object?> get props => [club];
}

class WelcomeState extends CubitStates {
  @override
  List<Object?> get props => [];
}
