import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/history_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class THistoryListItems extends StatelessWidget {
  const THistoryListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryController());
    return Obx(() {
      if(controller.loading.value){
        return const Center(child: CircularProgressIndicator(),);
      }else{
        return ListView.separated(
          shrinkWrap: true,
          itemCount: controller.histories.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, index) =>
          const SizedBox(height: TSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final history = controller.histories[index];
            return TRoundedContainer(
              showBorder: true,
              backgroundColor: THelperFunctions.isDarkMode(context)
                  ? TColors.dark
                  : TColors.light,
              child: Column(
                children: [
                  /// -- Top Row
                  Row(
                    children: [
                      /// 1 - Image
                      const Icon(Iconsax.calendar),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),

                      /// 2 - Status & Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Тапсырған күні',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge!.apply(
                                  color: TColors.primary, fontWeightDelta: 1),
                            ),
                            Text(history.formattedOrderDate,
                                style: Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  /// -- Bottom Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            /// 1 - Icon
                            const Icon(Iconsax.tag),
                            const SizedBox(width: TSizes.spaceBtwItems / 2),
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    history.subjectTitle,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  Text(
                                    history.bookTitle,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  Text(
                                    history.chapterTitle,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  Text(
                                    history.quizTitle,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Delivery Date
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircularPercentIndicator(
                              radius: 60.0,
                              lineWidth: 10.0,
                              percent: history.resultPoint / history.maxPoint,
                              center: Text(
                                  "${((history.resultPoint / history.maxPoint) * 100).toStringAsFixed(2)}%\n${history.resultPoint}/${history.maxPoint}"),
                              progressColor: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }
}
