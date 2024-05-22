import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/controllers/login/login_controller.dart';
import 'package:history_app/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:history_app/features/authentication/screens/signup/signup.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/constants/text_strings.dart';
import 'package:history_app/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

class TLoginForm extends GetView<LoginController> {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: TSizes.spaceBtwSections * 0.25),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              onFieldSubmitted: (_) => FocusScope.of(context)
                  .requestFocus(controller.passwordFocusNode),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => TValidator.validateEmail(value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: TTexts.email),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Password
            Obx(
              () => TextFormField(
                obscureText: controller.hidePassword.value,
                controller: controller.passwordController,
                focusNode: controller.passwordFocusNode,
                onFieldSubmitted: (_) => FocusScope.of(context)
                    .unfocus(),
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
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            /// Remember me & Forgot Password
            Row(
              children: [
                /// Remember me
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value =
                              !controller.rememberMe.value,
                        )),
                    const Text(TTexts.rememberMe)
                  ],
                ),

                /// Forgot Password
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.to(() => const ForgotPassword()),
                    child: const Text(TTexts.forgetPassword, overflow: TextOverflow.ellipsis,),
                  ),
                )
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Sign In
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.emailAndPasswordSignIn();
                },
                child: const Text(
                  TTexts.signIn,
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Create Account
            Hero(
              tag: 'auth_button',
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.to(() => const SignupScreen()),
                  child: const Text(
                    TTexts.createAccount,
                  ),
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
