import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/question_controller.dart';
import 'package:history_app/features/education/models/question_model.dart';
import 'package:history_app/features/education/screens/question/widgets/question_card.dart';
import 'package:history_app/utils/constants/sizes.dart';

class Question extends StatelessWidget {
  const Question({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.put(QuestionController());
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.spaceBtwSections),
              child: Obx(
                () => Text.rich(
                  TextSpan(
                      text:
                          "Question ${question[1].id}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.grey[700]),
                      children: [
                        TextSpan(
                            text: '/${questionController.questions.length}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.grey[700]))
                      ]),
                ),
              ),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: TSizes.spaceBtwSections),
            Expanded(
              child: PageView.builder(
                itemCount: questionController.questions.length,
                itemBuilder: (BuildContext context, int index) => QuestionCard(
                  questionModel: questionController.questions[index],
                ),
              ),
            ),

            const SizedBox(height: TSizes.defaultSpace),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 50),
            //   child: InkWell(
            //     onTap: (){},
            //     child: Container(
            //       width: double.infinity,
            //       padding: const EdgeInsets.all(20),
            //       decoration: BoxDecoration(
            //           color: Colors.grey[400],
            //           borderRadius: BorderRadius.circular(20)),
            //       child: const Center(child: Text('Next')),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: TSizes.defaultSpace),
          ],
        ),
      ),
    );
  }
}
