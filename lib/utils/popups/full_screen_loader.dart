import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text) {
    showDialog(
      context: Get.overlayContext!,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: THelperFunctions.isDarkMode(Get.context!)
              ? TColors.dark
              : TColors.light,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,style: Theme.of(Get.context!).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  static stopLoading() {
    Navigator.of(Get.context!).pop();
  }
}
