import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/auth_controller.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthController());
  final _userRepo = Get.put(UserController());

  getUserData() {
    final email = _authRepo.firebaseUser?.value?.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar('Errore', 'Accedi per continuare');
    }
  }

  Future<List<UserModel>> getAllUser() async => _userRepo.allUsers();

  updateUser(UserModel user) async {
    await _userRepo.updateUser(user);
  }
}
