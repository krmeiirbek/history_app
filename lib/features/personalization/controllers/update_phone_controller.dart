import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:history_app/data/repository/user/user_repository.dart';
import 'package:history_app/features/personalization/controllers/user_controller.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:history_app/utils/helpers/network_manager.dart';
import 'package:history_app/utils/popups/full_screen_loader.dart';
import 'package:history_app/utils/popups/loaders.dart';

class UpdatePhoneController extends GetxController {
  static UpdatePhoneController get instance => Get.find();

  final phoneNumber = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserPhoneNumberFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initializePhoneNumber();
  }

  Future<void> initializePhoneNumber() async {
    phoneNumber.text = userController.user.value.phoneNumber;
  }

  Future<void> updatePhoneNumber() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Біз сіздің ақпаратыңызды жаңартып жатырмыз ... ", TImages.loading);

      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      Map<String, dynamic> phone = {
        "Phone": phoneNumber.text.trim(),
      };
      await userRepository.updateSingleField(phone);

      userController.user.value.phoneNumber = phoneNumber.text.trim();

      TFullScreenLoader.stopLoading();

      Get.back();

      TLoaders.successSnackBar(
          title: "Жетістік", message: "Жаңартылды", duration: 1);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'О, Жоқ', message: e.toString());
    }
  }
}
