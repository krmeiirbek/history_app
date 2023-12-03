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
    return Obx(() {
      if(controller.loading.value){
        return const Center(child: CircularProgressIndicator(),);
      }else {
        return Padding(
          padding: const EdgeInsets.all(TSizes.defaultBtwItems),
          child: ListView.separated(
            separatorBuilder: (_, index) => const Divider(height: TSizes.md),
            itemCount: controller.quizzes.length,
            itemBuilder: (_, index) {
              return ListTile(
                onTap: () {
                  if (!controller.quizzes[index].isBuy) {
                    showDialog(
                      context: _,
                      builder: (_) => AlertDialog(
                        actions: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Text('Жоқ'),
                          ),
                          const SizedBox(width: 150),
                          InkWell(
                            onTap: () {
                              controller.buyQuiz(quiz: controller.quizzes[index]);
                            },
                            child: const Text('Сатып алу'),
                          ),
                        ],
                        title: const Text("Сатып алу"),
                        contentPadding: const EdgeInsets.all(TSizes.xl),
                        content: const Text(
                            "Бұл нұсқаны сатып алсыз ба?"),
                      ),
                    );
                  } else {
                    Get.to(
                          () => const QuestionScreen(),
                      arguments: controller.quizzes[index].copyWith(
                        subjectId: controller.chapter.subjectId,
                        bookId: controller.chapter.bookId,
                        chapterId: controller.chapter.chapterId,
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
                  if(controller.loadingForBuyingQuiz.value){
                    return const SizedBox(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }else{
                    return SizedBox(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          controller.quizzes[index].isBuy == false
                              ? Text(
                            "🌕  ${TDummyData.quizzes[index].price}",
                            style: Theme.of(context).textTheme.titleSmall!.apply(
                              color: dark ? TColors.white : TColors.black,
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
