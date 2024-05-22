import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:history_app/features/education/controllers/question_controller.dart';
import 'package:history_app/features/education/screens/result/result.dart';
import 'package:history_app/features/ubt/controllers/ubt_question_controller.dart';
import 'package:history_app/utils/constants/sizes.dart';

import '../../result/result.dart';

class UBTQuestionHeader extends StatelessWidget {
  const UBTQuestionHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UBTQuestionController.instance;
    return TPrimaryHeaderContainer(
      child: Padding(
        padding: const EdgeInsets.only(bottom: TSizes.xl),
        child: SafeArea(
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: TSizes.defaultSpace),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultSpace,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${controller.time.value ~/ 3600}:${(controller.time.value ~/ 60 % 60).toString().padLeft(2, '0')}:${(controller.time.value % 60).toString().padLeft(2, '0')}",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      controller.loading.value
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                Get.off(
                                  () => const UBTResultPage(),
                                  arguments: {
                                    "quiz": controller.quizModel.copyWith(
                                        questions: controller.questions),
                                    "selectedOptions":
                                        controller.selectedOptions,
                                  },
                                );
                              },
                              child: Text(
                                "Тестті аяқтау",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                SizedBox(
                  height: TSizes.indexedCard,
                  child: ListView.separated(
                    controller: controller.scrollController,
                    // Add the scroll controller here
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.defaultSpace,
                    ),
                    itemBuilder: (context, index) => Obx(() => InkWell(
                          onTap: () {
                            controller.changeQuestion(index);
                          },
                          child: Container(
                            height: TSizes.indexedCard,
                            width: TSizes.indexedCard,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.questionId.value == index
                                  ? Colors.deepPurple.shade800
                                  : controller.selectedOptions[index].isEmpty
                                      ? Theme.of(context).colorScheme.surface
                                      : Colors.deepPurple.shade500,
                              border: controller.questionId.value == index
                                  ? null
                                  : controller.selectedOptions[index].isNotEmpty
                                      ? null
                                      : Border.all(
                                          color: Theme.of(context)
                                              .unselectedWidgetColor,
                                        ),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: controller.questionId.value == index
                                    ? const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )
                                    : controller
                                            .selectedOptions[index].isNotEmpty
                                        ? const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          )
                                        : TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .unselectedWidgetColor,
                                          ),
                              ),
                            ),
                          ),
                        )),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemCount: controller.questions.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
