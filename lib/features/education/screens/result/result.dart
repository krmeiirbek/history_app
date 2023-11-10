import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:history_app/features/education/controllers/result_controller.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultPage extends GetView<ResultController> {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResultController());
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            TPrimaryHeaderContainer(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: TSizes.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Тест Нәтижесі',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                        SizedBox(width: MediaQuery.of(context).size.width),
                        Stack(
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
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: context.theme.primaryColor,
                  ),
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Center(
                    child: Text(
                      'Нәтижелер',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Text(
                        'Артқа қайту',
                        style: TextStyle(
                          color: context.theme.colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
