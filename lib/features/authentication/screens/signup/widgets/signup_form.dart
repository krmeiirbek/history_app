import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/controllers/signup_controller/signup_controller.dart';
import 'package:history_app/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:history_app/navigation_menu.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/constants/text_strings.dart';
import 'package:iconsax/iconsax.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              /// First Name
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),

              /// Last Name
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// UserName
          TextFormField(
            controller: controller.userName,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: controller.email,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// PhoneNumber
          TextFormField(
            controller: controller.phoneNo,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Password
          TextFormField(
            controller: controller.password,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),
          const SizedBox(height: TSizes.defaultSpace),

          /// Terms Checkbox
          const TTermsAndConditionCheckbox(),
          const SizedBox(height: TSizes.defaultSpace),

          ///() => Get.to(() => const VerifyEmailScreen())
          /// Sign Up Page
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  SignUpController.instance.registerUser(
                    controller.email.text.trim(),
                    controller.password.text.trim(),
                  );
                  ()=>Get.to(() => const NavigationMenu());
                }
              },
              child: const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
