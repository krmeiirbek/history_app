import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/question_controller.dart';
import 'package:history_app/features/education/screens/question/widgets/question_body.dart';
import 'package:history_app/features/education/screens/question/widgets/question_header.dart';

class QuestionScreen extends GetView<QuestionController> {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(QuestionController());
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: const Column(
          children: [
            QuestionHeader(),
            Expanded(
              child: QuestionBody(),
            ),
          ],
        ),
      ),
    );
  }
}
