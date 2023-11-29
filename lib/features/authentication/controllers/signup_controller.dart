import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:history_app/data/repository/authentication/authentication_repository.dart';
import 'package:history_app/data/repository/user/user_repository.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/features/authentication/screens/signup/verify_email.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:history_app/utils/helpers/network_manager.dart';
import 'package:history_app/utils/popups/full_screen_loader.dart';
import 'package:history_app/utils/popups/loaders.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  /// -- SIGNUP
  Future<void> signup() async {
    try {
      // start loading
      TFullScreenLoader.openLoadingDialog(
          "We are processing your information", TImages.createdAccount);
      // check internet connect
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;
      // from validation
      if (!signupFormKey.currentState!.validate()) return;

      // PPC
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          massage:
              'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use',
        );
        return;
      }
      // register user
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());
      // save authenticated
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        userName: userName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // show massage
      TLoaders.successSnackBar(
          title: "Congratulations",
          massage: "Your account has been created! Verify email to continue.");

      // move VE screen
      Get.to(() => const VerifyEmailScreen());
    } catch (e) {
      TLoaders.errorSnackBar(title: "Oh Snap", massage: e.toString());


      // show error
    } finally {
      // remove loader
      TFullScreenLoader.stopLoading();
    }
  }
}
