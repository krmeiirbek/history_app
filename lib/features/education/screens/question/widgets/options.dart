import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/question_controller.dart';
import 'package:history_app/utils/constants/sizes.dart';

class Option extends StatelessWidget {
  const Option({
    super.key,
    required this.text,
    required this.index,
    required this.onTap,
  });

  final String text;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      init: QuestionController(),
      builder: (qnController) {
        Color getTheRightColor() {
          if (qnController.isAnswered) {
            if (index == qnController.correctAns) {
              return Colors.green;
            } else if (index == qnController.selectedAns &&
                qnController.selectedAns != qnController.correctAns) {
              return Colors.red;
            }
          }
          return Colors.grey;
        }

        return InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: TSizes.xl),
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            decoration: BoxDecoration(
              border: Border.all(color: getTheRightColor(), width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              "${index + 1} $text",
              style: TextStyle(color: getTheRightColor()),
            ),
          ),
        );
      },
    );
  }
}
