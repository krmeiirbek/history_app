import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/result_controller.dart';
import 'package:history_app/features/education/screens/result/widgets/result_body.dart';
import 'package:history_app/features/education/screens/result/widgets/result_floating_action_button.dart';
import '../../controllers/ubt_result_controller.dart';
import 'widgets/result_body.dart';
import 'widgets/result_floating_action_button.dart';

class UBTResultPage extends GetView<UBTResultController> {
  const UBTResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UBTResultController());
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: const Scaffold(
        body: UBTTResultBody(),
        floatingActionButton: UBTTResultFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
