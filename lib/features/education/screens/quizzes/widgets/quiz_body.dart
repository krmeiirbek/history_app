import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/dummy_data.dart';
import 'package:history_app/features/education/controllers/quiz_controller.dart';
import 'package:history_app/features/education/screens/question/question.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';

class TQuizBody extends GetView<QuizController> {
  const TQuizBody({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultBtwItems),
      child: ListView.separated(
        separatorBuilder: (_, index) => const Divider(height: TSizes.md),
        itemCount: controller.quizzes.length,
        itemBuilder: (_, index) {
          return ListTile(
            onTap: () => Get.to(
              () => const QuestionScreen(),
              arguments: controller.quizzes[index],
            ),
            leading: Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.bodyLarge!.apply(
                    fontSizeDelta: TSizes.dividerHeight,
                  ),
            ),
            title: Text(
              controller.quizzes[index].title,
            ),
            trailing: SizedBox(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "🌕  ${TDummyData.quizzes[index].price}",
                    style: Theme.of(context).textTheme.titleSmall!.apply(
                          color: dark ? TColors.white : TColors.black,
                        ),
                  ),
                  const SizedBox(width: TSizes.vl),
                  Flexible(
                    child: Divider(
                      color: dark ? TColors.darkGrey : TColors.black,
                      thickness: 1,
                      indent: 1,
                      endIndent: 5,
                    ),
                  ),
                  const Icon(Icons.lock_outline),
                  Flexible(
                    child: Divider(
                      color: dark ? TColors.darkGrey : TColors.black,
                      thickness: 1,
                      indent: 1,
                      endIndent: 5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
