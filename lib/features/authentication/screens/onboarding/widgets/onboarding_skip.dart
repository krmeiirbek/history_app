import 'package:flutter/material.dart';
import 'package:history_app/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: const Text('Skip'),
      ),
    );
  }
}
