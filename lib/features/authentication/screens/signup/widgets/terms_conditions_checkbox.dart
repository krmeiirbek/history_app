import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/controllers/signup/signup_controller.dart';
//import 'package:history_app/features/privacy_policy_and_terms_of_use/screens/privacy_policy.dart';
import 'package:history_app/features/privacy_policy_and_terms_of_use/screens/terms_of_use.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/constants/text_strings.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';

class TTermsAndConditionCheckbox extends StatelessWidget {
  const TTermsAndConditionCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(
            () => Checkbox(
              value: controller.privacyPolicy.value,
              onChanged: (value) {
                controller.privacyPolicy.value =
                    !controller.privacyPolicy.value;
              },
            ),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems - 5),
        SizedBox(
          child: Text.rich(
            TextSpan(
              children: [
                // TextSpan(
                //   text: "${TTexts.privacyPolicy} ",
                //   style: Theme.of(context).textTheme.bodyMedium!.apply(
                //         color: dark ? TColors.white : TColors.primary,
                //         decoration: TextDecoration.underline,
                //         decorationColor: dark ? TColors.white : TColors.primary,
                //       ),
                //   recognizer: TapGestureRecognizer()
                //     ..onTap = () {
                //       Get.to(() => const PrivacyPolicyScreen());
                //     },
                // ),
                // TextSpan(
                //   text: "${TTexts.and} ",
                //   style: Theme.of(context).textTheme.bodySmall,
                // ),
                TextSpan(
                  text: "${TTexts.I} ",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: "${TTexts.termsOfUse} ",
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark ? TColors.white : TColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: dark ? TColors.white : TColors.primary,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.to(() => const TermsOfUseScreen());
                    },
                ),
                TextSpan(
                  text: "${TTexts.agreeTo} ",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
