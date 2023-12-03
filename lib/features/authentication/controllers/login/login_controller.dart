import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:history_app/data/repository/authentication/authentication_repository.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:history_app/utils/helpers/network_manager.dart';
import 'package:history_app/utils/popups/full_screen_loader.dart';
import 'package:history_app/utils/popups/loaders.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final rememberMe = true.obs;

  String lastText = '';

  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// -- SIGNUP
  Future<void> login() async {
    try {
      // start loading
      TFullScreenLoader.openLoadingDialog(
        "We are processing your information...",
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

      // login user
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
          emailController.text.trim(), passwordController.text.trim());

      TFullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Oh Snap", message: e.toString());
    }
  }
}
