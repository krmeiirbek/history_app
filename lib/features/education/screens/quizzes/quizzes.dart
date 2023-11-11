import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/features/education/controllers/quiz_controller.dart';
import 'package:history_app/features/education/screens/quizzes/widgets/quiz_body.dart';

class QuizzesScreen extends GetView<QuizController> {
  const QuizzesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(QuizController());
    return Scaffold(
      appBar: TAppBar(
        title: SizedBox(
          child: Text(
            "Нұсқалар",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      body: const TQuizBody(),
    );
  }
}
