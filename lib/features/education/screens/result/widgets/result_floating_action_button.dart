import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/result_controller.dart';
import 'package:history_app/features/education/screens/result/result_with_options.dart';
import 'package:history_app/utils/constants/sizes.dart';

class TResultFloatingActionButton extends GetView<ResultController> {
  const TResultFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Get.off(
                () => const ResultWithOptions(),
                arguments: {
                  "questions": controller.questions,
                  "selectedOptions": controller.selectedOptions,
                },
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: context.theme.primaryColor,
                ),
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Center(
                  child: Text(
                    'Нәтижелер',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Text(
                    'Артқа қайту',
                    style: TextStyle(
                      color: context.theme.colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
