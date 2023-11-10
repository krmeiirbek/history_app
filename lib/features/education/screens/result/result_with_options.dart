import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/result_with_options_controller.dart';
import 'package:history_app/features/education/screens/result/widgets/result_with_option_body.dart';
import 'package:history_app/features/education/screens/result/widgets/result_with_option_header.dart';

class ResultWithOptions extends GetView<ResultWithOptionsController> {
  const ResultWithOptions({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResultWithOptionsController());
    return const Scaffold(
      body: Column(
        children: [
          TResultWithOptionHeader(),
          Expanded(
            child: TResultWithOptionBody(),
          ),
        ],
      ),
    );
  }
}
