import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:history_app/common/widgets/home/home_buttons.dart';
import 'package:history_app/common/widgets/images/t_circular_image.dart';
import 'package:history_app/features/education/controllers/dummy_data.dart';
import 'package:history_app/features/education/models/chapter_model.dart';
import 'package:history_app/features/education/screens/chapters/chapters.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/constants/text_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// -- Header
            TPrimaryHeaderContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// -- Header
                  TAppBar(
                    showBackArrowIcon: false,
                    title: Text(
                      'Басты бет',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white),
                    ),
                    actions: [
                      Row(
                        children: [
                          Text(
                            "🌕 ${TDummyData.user.balance}",
                            style:
                                Theme.of(context).textTheme.titleSmall!.apply(
                                      color: TColors.white,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Hero(
                        tag: 'avatar',
                        child: TCircularImage(
                          padding: 0,
                          image: TDummyData.user.profilePicture,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            /// Button KAZ HISTORY
            HomeButtons(
              title: TTexts.historyOfKazakhstanTitle,
              subTitle: TTexts.historyOfKazakhstanSubTitle,
              image: TImages.historyOfKazakhstan,
              onPressed: () => Get.to(
                () => Chapters(
                  chapter: ChapterModelOfTheHistoryOfKazakhstan,
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Button WORLD HISTORY
            HomeButtons(
              title: TTexts.worldHistoryTitle,
              subTitle: TTexts.worldHistorySubTitle,
              image: TImages.worldHistory,
              onPressed: () => Get.to(
                () => Chapters(
                  chapter: ChapterModelOfTheWorldHistory,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
