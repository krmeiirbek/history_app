import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:history_app/common/widgets/home/home_buttons.dart';
import 'package:history_app/features/education/controllers/home_controller.dart';
import 'package:history_app/features/education/screens/list_books/list_books.dart';
import 'package:history_app/features/ubt/controllers/ubt_controller.dart';
import 'package:history_app/features/ubt/screens/quizzes/quizzes.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';

class UBT extends GetView<HomeController> {
  const UBT({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UBTController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? null : TColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// -- Header
          TPrimaryHeaderContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// -- Header
                TAppBar(
                  showBackArrowIcon: false,
                  title: Text(
                    'ҰБТ',
                    style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          Obx(
            () {
              if (controller.ubt_subjects.isNotEmpty) {
                return Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 15),
                    itemBuilder: (context, index) => HomeButtons(
                      title: controller.ubt_subjects[index].title,
                      image: controller.ubt_subjects[index].image,
                      onPressed: () => Get.to(
                        () => const UBTQuizzesScreen(),
                        arguments: controller.ubt_subjects[index],
                      ),
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwSections),
                    itemCount: controller.ubt_subjects.length,
                  ),
                );
              } else {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
