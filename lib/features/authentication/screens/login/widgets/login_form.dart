import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:history_app/features/authentication/screens/signup/signup.dart';
import 'package:history_app/navigation_menu.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/constants/text_strings.dart';
import 'package:iconsax/iconsax.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: TSizes.spaceBtwSections * 0.25),
        child: Column(
          children: [
            /// Email
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: TTexts.email),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Password
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  suffixIcon: Icon(Iconsax.eye_slash),
                  labelText: TTexts.password),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            /// Remember me & Forgot Password
            Row(
              children: [
                /// Remember me
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(TTexts.rememberMe)
                  ],
                ),

                /// Forgot Password
                TextButton(
                  onPressed: () => Get.to(() => const ForgotPassword()),
                  child: const Text(TTexts.forgetPassword),
                )
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const NavigationMenu()),
                child: const Text(
                  TTexts.signIn,
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Create Account
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text(
                  TTexts.createAccount,
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}
