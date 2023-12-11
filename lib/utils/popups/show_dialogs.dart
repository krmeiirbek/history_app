import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/utils/constants/sizes.dart';

class ShowDialogs {
  static deleteShowDialog(
      {required title, required onPressed, middleText = '', duration = 1}) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: title,
      titleStyle: Theme.of(Get.context!)
          .textTheme
          .bodyLarge!
          .apply(fontStyle: FontStyle.normal, fontSizeDelta: 5),
      middleText: middleText,
      middleTextStyle:
          Theme.of(Get.context!).textTheme.bodyMedium!.apply(fontSizeDelta: 2),
      confirm: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Жою'),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text('Болдырмау'),
      ),
    );
  }

  static logoutShowDialog(
      {required title, required onPressed, middleText = '', duration = 1}) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: title,
      titleStyle: Theme.of(Get.context!)
          .textTheme
          .bodyLarge!
          .apply(fontStyle: FontStyle.normal, fontSizeDelta: 5),
      middleText: middleText,
      middleTextStyle:
          Theme.of(Get.context!).textTheme.bodyMedium!.apply(fontSizeDelta: 2),
      confirm: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.xs),
          child: Text(
            'Шығу',
          ),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text('Болдырмау'),
      ),
    );
  }

  static classicShowDialog(
      {required title, required onPressed, middleText = '', duration = 1}) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: title,
      titleStyle: Theme.of(Get.context!)
          .textTheme
          .bodyLarge!
          .apply(fontStyle: FontStyle.normal, fontSizeDelta: 5),
      middleText: middleText,
      middleTextStyle:
          Theme.of(Get.context!).textTheme.bodyMedium!.apply(fontSizeDelta: 2),
      confirm: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.white)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.xs),
          child: Text(
            'Иә',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.white)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.xs),
          child: Text(
            'Жоқ',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
