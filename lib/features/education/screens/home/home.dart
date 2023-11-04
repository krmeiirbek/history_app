import 'package:flutter/material.dart';
import 'package:history_app/common/widgets/home/home_buttons.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/constants/text_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Button KAZ HISTORY
                HomeButtons(
                  title: TTexts.historyOfKazakhstanTitle,
                  subTitle: TTexts.historyOfKazakhstanSubTitle,
                  image: TImages.historyOfKazakhstan,
                  onPressed: () {},
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                /// Button WORLD HISTORY
                HomeButtons(
                  title: TTexts.worldHistoryTitle,
                  subTitle: TTexts.worldHistorySubTitle,
                  image: TImages.worldHistory,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
