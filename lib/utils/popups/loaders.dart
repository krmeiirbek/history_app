import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class TLoaders {
  static hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({required message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: THelperFunctions.isDarkMode(Get.context!)
                  ? TColors.darkerGrey.withOpacity(0.9)
                  : TColors.grey.withOpacity(0.9)),
          child: Center(
            child: Text(
              message,
              style: Theme.of(Get.context!).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  static warningSnackBar({required title, massage = '', duration = 3}) {
    Get.snackbar(
      title,
      massage,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(20),
      icon: const Icon(
        Iconsax.wallet2,
        color: TColors.white,
      ),
    );
  }

  static successSnackBar({required title, massage = '', duration = 3}) {
    Get.snackbar(
      title,
      massage,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.primary,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: const Icon(
        Iconsax.check,
        color: TColors.white,
      ),
    );
  }

  static errorSnackBar({required title, massage = '', duration = 500}) {
    Get.snackbar(
      title,
      massage,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(20),
      icon: const Icon(
        Iconsax.wallet2,
        color: TColors.white,
      ),
    );
  }
}
