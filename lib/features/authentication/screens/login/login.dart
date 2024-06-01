import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/login_signup/form_divider.dart';
import 'package:history_app/common/widgets/login_signup/social_buttons.dart';
import 'package:history_app/features/authentication/controllers/login/login_controller.dart';
import 'package:history_app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:history_app/features/authentication/screens/login/widgets/login_header.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return GestureDetector(
      onTap: () => controller.unFocusNode.canRequestFocus ? FocusScope.of(context).requestFocus(controller.unFocusNode) : FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Logo
                const TLoginHeader(),

                /// Form
                const TLoginForm(),

                /// Divider
                Hero(
                  tag: 'auth-or',
                  child: TFormDivider(
                    dividerText: TTexts.or.capitalize!,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                /// Footer
                const Hero(tag: 'auth-google', child: TSocialButtons()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
