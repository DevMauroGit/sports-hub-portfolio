import 'package:get/get.dart';
import 'package:sports_hub_ios/controllers/auth_controller.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/models/user_model.dart';

class ProfileController extends GetxController {
  // Singleton instance to access ProfileController easily
  static ProfileController get instance => Get.find();

  // Instantiate AuthController and UserController using Get.put
  final _authRepo = Get.put(AuthController());
  final _userRepo = Get.put(UserController());

  /// Retrieves user data based on current authenticated user's email
  getUserData() {
    final email = _authRepo.firebaseUser?.value?.email;
    if (email != null) {
      // Fetch user details using email
      return _userRepo.getUserDetails(email);
    } else {
      // Show error message if user not logged in
      Get.snackbar('Errore', 'Accedi per continuare');
    }
  }

  /// Fetches all users asynchronously
  Future<List<UserModel>> getAllUser() async => _userRepo.allUsers();

  /// Updates user data
  updateUser(UserModel user) async {
    await _userRepo.updateUser(user);
  }
}
