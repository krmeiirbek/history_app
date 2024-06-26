import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/result_with_options_controller.dart';
import 'package:history_app/features/education/screens/result/widgets/result_with_option_body.dart';
import 'package:history_app/features/education/screens/result/widgets/result_with_option_header.dart';

import '../../controllers/ubt_result_with_options_controller.dart';
import 'widgets/result_with_option_body.dart';
import 'widgets/result_with_option_header.dart';

class UBTResultWithOptions extends GetView<UBTResultWithOptionsController> {
  const UBTResultWithOptions({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UBTResultWithOptionsController());
    return const Scaffold(
      body: Column(
        children: [
          UBTTResultWithOptionHeader(),
          Expanded(
            child: UBTTResultWithOptionBody(),
          ),
        ],
      ),
    );
  }
}
