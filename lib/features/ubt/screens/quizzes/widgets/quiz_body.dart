import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/quiz_controller.dart';
import 'package:history_app/features/education/screens/question/question.dart';
import 'package:history_app/features/ubt/controllers/ubt_quiz_controller.dart';
import 'package:history_app/features/ubt/screens/question/question.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';
import 'package:history_app/utils/popups/show_dialogs.dart';

class UBTTQuizBody extends GetView<UBTQuizController> {
  const UBTTQuizBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(TSizes.defaultBtwItems),
          child: ListView.separated(
            separatorBuilder: (_, index) => const Divider(height: TSizes.md),
            itemCount: controller.quizzes.length,
            itemBuilder: (_, index) {
              return ListTile(
                onTap: () {
                  Get.to(
                        () => const UBTQuestionScreen(),
                    arguments: controller.quizzes[index].copyWith(
                      subjectId: controller.subject.subjectId,
                      subjectTitle: controller.subject.title,
                    ),
                  );
                },
                leading: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.bodyLarge!.apply(
                    fontSizeDelta: TSizes.dividerHeight,
                  ),
                ),
                title: Text(
                  controller.quizzes[index].title,
                ),
              );
            },
          ),
        );
      }
    });
  }
}
