import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/result_controller.dart';
import 'package:history_app/features/education/screens/result/widgets/result_body.dart';
import 'package:history_app/features/education/screens/result/widgets/result_floating_action_button.dart';


class ResultPage extends GetView<ResultController> {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResultController());
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: const Scaffold(
        body: TResultBody(),
        floatingActionButton: TResultFloatingActionButton(),
      ),
    );
  }
}
