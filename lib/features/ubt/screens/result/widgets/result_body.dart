import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/result_controller.dart';
import 'package:history_app/features/education/screens/result/widgets/result_header.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../controllers/ubt_result_controller.dart';
import 'result_header.dart';

class UBTTResultBody extends GetView<UBTResultController> {
  const UBTTResultBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UBTTResultHeader(),
        Obx(() {
          if (controller.loading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width-16),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Lottie.asset(
                          TImages.cheers,
                          repeat: false,
                          fit: BoxFit.fill,
                        ),
                        CircularPercentIndicator(
                          radius: MediaQuery.of(context).size.width * 0.4,
                          lineWidth: 50.0,
                          percent: controller.resultPoint.value /
                              controller.maxPoint.value,
                          center: Text(
                            "${((controller.resultPoint.value / controller.maxPoint.value) * 100).toStringAsFixed(2)}%\n${controller.resultPoint.value}/${controller.maxPoint.value}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: context.theme.primaryColor,
                          backgroundColor:
                          context.theme.colorScheme.primary,
                          animation: true,
                          animationDuration: 1500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ],
    );
  }
}
