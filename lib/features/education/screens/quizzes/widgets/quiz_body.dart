import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/quiz_controller.dart';
import 'package:history_app/features/education/screens/question/question.dart';
import 'package:history_app/utils/constants/sizes.dart';

class TQuizBody extends GetView<QuizController> {
  const TQuizBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: ListView.separated(
        itemBuilder: (_, index) {
          return ListTile(
            onTap: () => Get.to(
                  () =>  const QuestionScreen(),
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
            trailing: Text(
              controller.quizzes[index].title,
            ),
          );
        },
        separatorBuilder: (_, index) => const Divider(height: 1),
        itemCount: controller.quizzes.length,
      ),
    );
  }
}
