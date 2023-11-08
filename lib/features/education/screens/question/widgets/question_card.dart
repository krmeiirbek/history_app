import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:history_app/features/education/controllers/question_controller.dart';
import 'package:history_app/features/education/models/question_model.dart';
import 'package:history_app/features/education/screens/question/widgets/options.dart';
import 'package:history_app/utils/constants/sizes.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.questionModel,
  });

  final QuestionModel questionModel;

  @override
  Widget build(BuildContext context) {
    QuestionController _questionController = Get.put(QuestionController());
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.spaceBtwSections),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            questionModel.question,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: TSizes.md),
          ...List.generate(
            questionModel.options.length,
            (index) => Option(
              text: questionModel.options[index],
              index: index,
              onTap: () => _questionController.checkAns(questionModel, index),
            ),
          ),
        ],
      ),
    );
  }
}
