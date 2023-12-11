import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/controllers/signup/signup_controller.dart';
import 'package:history_app/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/constants/text_strings.dart';
import 'package:history_app/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              /// First Name
              Expanded(
                child: TextFormField(
                  controller: controller.firstNameController,
                  validator: (value) =>
                      TValidator.validateEmptyText("Аты", value),
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
                  controller: controller.lastNameController,
                  validator: (value) =>
                      TValidator.validateEmptyText("Тегі", value),
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          /// Email
          TextFormField(
            controller: controller.emailController,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// PhoneNumber
          TextFormField(
            controller: controller.phoneNumberController,
            validator: (value) => TValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Password
          Obx(
            () => TextFormField(
              obscureText: controller.hidePassword.value,
              controller: controller.passwordController,
              validator: (value) => TValidator.validatePassword(value),
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value =
                      !controller.hidePassword.value,
                  icon: Icon(
                    controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.defaultSpace),

          /// Terms Checkbox
          const TTermsAndConditionCheckbox(),
          const SizedBox(height: TSizes.defaultSpace),
          /// Sign Up Page
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.signup();
              },
              child: const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
