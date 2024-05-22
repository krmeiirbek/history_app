import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/features/education/controllers/quiz_controller.dart';
import 'package:history_app/features/education/screens/quizzes/widgets/quiz_body.dart';
import 'package:history_app/features/ubt/controllers/ubt_quiz_controller.dart';
import 'package:history_app/navigation_menu.dart';

import '../../../../utils/constants/sizes.dart';
import 'widgets/quiz_body.dart';

class UBTQuizzesScreen extends GetView<UBTQuizController> {
  const UBTQuizzesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(UBTQuizController());
    return Scaffold(
      appBar: TAppBar(
        title: SizedBox(
          child: Row(
            children: [
              Text(
                "Нұсқалар",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      body: const UBTTQuizBody(),
    );
  }
}
