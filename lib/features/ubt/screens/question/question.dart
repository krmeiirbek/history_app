import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/question_controller.dart';
import 'package:history_app/features/education/screens/question/widgets/question_body.dart';
import 'package:history_app/features/education/screens/question/widgets/question_header.dart';
import 'package:history_app/features/ubt/controllers/ubt_question_controller.dart';

import 'widgets/question_body.dart';
import 'widgets/question_header.dart';

class UBTQuestionScreen extends GetView<UBTQuestionController> {
  const UBTQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UBTQuestionController());
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: const Column(
          children: [
            UBTQuestionHeader(),
            Expanded(
              child: UBTQuestionBody(),
            ),
          ],
        ),
      ),
    );
  }
}
