import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/dummy_data.dart';

class THistoryListItems extends StatelessWidget {
  const THistoryListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: TDummyData.histories.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, index) => const SizedBox(height: TSizes.spaceBtwItems),
      itemBuilder: (_, index) {
        final history = TDummyData.histories[index];
        return TRoundedContainer(
          showBorder: true,
          backgroundColor: THelperFunctions.isDarkMode(context)? TColors.dark : TColors.light,
          child: Column(
            children: [
              /// -- Top Row
              Row(
                children: [
                  /// 1 - Image
                  const Icon(Iconsax.calendar),
                  const SizedBox(width: TSizes.spaceBtwItems/2 ),

                  /// 2 - Status & Date
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Тапсырған күні',
                          overflow: TextOverflow.ellipsis,
                          style:
                          Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primary, fontWeightDelta: 1),
                        ),
                        Text(history.formattedOrderDate, style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),

                  /// 3 - Icon
                  IconButton(onPressed: () {}, icon: const Icon(Iconsax.arrow_right_34, size: TSizes.iconSm)),
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
                                history.quiz.title,
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
                          percent: history.resultPoint/history.maxPoint,
                          center: Text("${((history.resultPoint/history.maxPoint)*100).toStringAsFixed(2)}%\n${history.resultPoint}/${history.maxPoint}"),
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
}