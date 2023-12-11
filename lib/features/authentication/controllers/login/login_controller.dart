import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:history_app/data/repository/authentication/authentication_repository.dart';
import 'package:history_app/features/personalization/controllers/user_controller.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:history_app/utils/helpers/network_manager.dart';
import 'package:history_app/utils/local_storage/storage_utility.dart';
import 'package:history_app/utils/popups/full_screen_loader.dart';
import 'package:history_app/utils/popups/loaders.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final userController = Get.put(UserController());

  /// Variables
  final hidePassword = true.obs;
  final rememberMe = true.obs;
  final localStorage = TLocalStorage();
  String lastText = '';

  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    emailController =
        TextEditingController(text: localStorage.readData('REMEMBER_ME_EMAIL'));
    passwordController = TextEditingController(
        text: localStorage.readData('REMEMBER_ME_PASSWORD'));
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// -- SIGNUP
  Future<void> emailAndPasswordSignIn() async {
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
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (rememberMe.value) {
        localStorage.saveData('REMEMBER_ME_EMAIL', emailController.text.trim());
        localStorage.saveData(
            'REMEMBER_ME_PASSWORD', passwordController.text.trim());
      }

      // login user
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
          emailController.text.trim(), passwordController.text.trim());

      TFullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "О, Жоқ", message: e.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Жүктелуде...", TImages.loading);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final userCredentials =
          await AuthenticationRepository.instance.signInWithGoogle();

      await userController.saveUserRecord(userCredentials);

      TFullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "О, Жоқ", message: e.toString());
    }
  }
}
