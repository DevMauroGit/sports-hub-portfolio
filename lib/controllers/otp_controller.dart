import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/Autentication_repository/authentication_repository.dart';
import 'package:sports_hub_ios/controllers/profile_controller.dart';
import 'package:sports_hub_ios/models/user_model.dart';
import 'package:sports_hub_ios/page/home_page.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  static ProfileController profile = Get.find();

  void verifingOTP(String otp, Map profile) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    if (isVerified == true) {
      UserModel userData = UserModel(
        username: profile['username'],
        id: profile['id'],
        email: profile['email'],
        phoneNumber: profile['phoneNumber'],
        city: profile['city'],
        password: profile['password'],
        profile_pic: profile['profile_pic'],
        cover_pic: profile['cover_pic'],
        isEmailVerified: true,
        games: profile['games'],
        goals: profile['goals'],
        win: profile['win'],
        games_tennis: profile['games_tennis'],
        set_vinti: profile['set_vinti'],
        win_tennis: profile['win_tennis'],
        prenotazioni: profile['prenotazioni'],
        prenotazioniPremium: profile['prenotazioniPremium'],
        token: profile['token'],
      );

      await FirebaseFirestore.instance
          .collection('User')
          .doc(profile['email'])
          .update(userData.toJson());
    } else {
      //Get.snackbar('sdfs', 'sdfsdf');
    }
    isVerified ? Get.offAll(HomePage()) : Get.offAll(HomePage());
  }
}
