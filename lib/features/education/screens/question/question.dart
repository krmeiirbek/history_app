import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/question_controller.dart';
import 'package:history_app/features/education/screens/question/widgets/question_header.dart';

import 'widgets/question_body.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionController());
    return const Scaffold(
      body: Column(
        children: [
          QuestionHeader(),
          Expanded(
            child: QuestionBody(),
          ),
        ],
      ),
    );
  }
}
