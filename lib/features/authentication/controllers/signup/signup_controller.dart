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

  String lastText = '';

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// -- SIGNUP
  Future<void> signup() async {
    try {
      // start loading
      TFullScreenLoader.openLoadingDialog(
        "Ақпаратыңызды өңдеудеміз...",
        TImages.loading,
      );
      // check internet connect
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // form validation
      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // PPC
      if (!privacyPolicy.value) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
          title: 'Құпиялық саясатын қабылдау',
          message:
              'Тіркелгіні жасау үшін Құпиялық саясаты мен пайдалану шарттарын оқып, қабылдауыңыз керек',
        );
        return;
      }
      // register user
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              emailController.text.trim(), passwordController.text.trim());
      // save authenticated
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        profilePicture: '',
        balance: 0,
        sandyq: ['historyOfKazakhstan_5classroom_1chapter_1quiz'],
      );

      await UserRepository.instance.saveUserRecord(newUser);

      TFullScreenLoader.stopLoading();

      // show massage
      TLoaders.successSnackBar(
          title: "Құттықтаймыз",
          message: "Есептік жазбаңыз жасалды! Жалғастыру үшін электрондық поштаны растаңыз.");

      // move VE screen
      Get.to(() => VerifyEmailScreen(
            email: emailController .text.trim(),
          ));
    } catch (e) {
      // remove loader
      TFullScreenLoader.stopLoading();

      // show error
      TLoaders.errorSnackBar(title: "О, Жоқ", message: e.toString());
    }
  }
}
