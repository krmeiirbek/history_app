import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:history_app/features/education/controllers/result_with_options_controller.dart';
import 'package:history_app/utils/constants/sizes.dart';

class TResultWithOptionHeader extends GetView<ResultWithOptionsController> {
  const TResultWithOptionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return TPrimaryHeaderContainer(
      child: Padding(
        padding: const EdgeInsets.only(bottom: TSizes.xl),
        child: SafeArea(
          child: Column(
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
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Нұсқаларға өту",
                        style:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        border: controller.questionId.value == index
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
    );
  }
}
