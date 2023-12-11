import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/quiz_controller.dart';
import 'package:history_app/features/education/screens/question/question.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';
import 'package:history_app/utils/popups/show_dialogs.dart';

class TQuizBody extends GetView<QuizController> {
  const TQuizBody({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
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
                  if (!controller.quizzes[index].isBuy) {
                    ShowDialogs.classicShowDialog(
                        title: 'Сатып алу',
                        onPressed: () {
                          controller.buyQuiz(quiz: controller.quizzes[index]);
                        },
                        middleText: 'Бұл нұсқаны сатып алaсыз ба?');
                  } else {
                    Get.to(
                      () => const QuestionScreen(),
                      arguments: controller.quizzes[index].copyWith(
                        subjectId: controller.chapter.subjectId,
                        bookId: controller.chapter.bookId,
                        chapterId: controller.chapter.chapterId,
                        subjectTitle: controller.chapter.subjectTitle,
                        bookTitle: controller.chapter.bookTitle,
                        chapterTitle: controller.chapter.title,
                      ),
                    );
                  }
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
                trailing: Obx(() {
                  if (controller.loadingForBuyingQuiz.value &&
                      (controller.quizzes[index].quizId ==
                          controller.loadingForBuyingQuizStr.value)) {
                    return const SizedBox(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return SizedBox(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          controller.quizzes[index].isBuy == false
                              ? Text(
                                  "🌕  ${controller.quizzes[index].price}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .apply(
                                        color: dark
                                            ? TColors.white
                                            : TColors.black,
                                      ),
                                )
                              : const Text('    '),
                          const SizedBox(width: TSizes.vl),
                          Flexible(
                            child: Divider(
                              color: dark ? TColors.darkGrey : TColors.black,
                              thickness: 1,
                              indent: 1,
                              endIndent: 5,
                            ),
                          ),
                          controller.quizzes[index].isBuy == false
                              ? const Icon(Icons.lock_outline, size: 25)
                              : const Icon(Icons.lock_open, size: 25),
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
                    );
                  }
                }),
              );
            },
          ),
        );
      }
    });
  }
}
