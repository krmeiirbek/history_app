import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:history_app/common/widgets/login_signup/form_divider.dart';
import 'package:history_app/common/widgets/login_signup/social_buttons.dart';
import 'package:history_app/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/constants/text_strings.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(TTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.defaultSpace),

              /// Form
              const TSignupForm(),
              const SizedBox(height: TSizes.defaultSpace),

              /// Divider
              TFormDivider(dividerText: TTexts.or.capitalize!),
              const SizedBox(height: TSizes.defaultSpace),

              /// Social Button
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
