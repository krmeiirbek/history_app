import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:history_app/common/widgets/home/home_buttons.dart';
import 'package:history_app/common/widgets/images/t_circular_image.dart';
import 'package:history_app/features/education/controllers/home_controller.dart';
import 'package:history_app/features/education/screens/list_books/list_books.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:history_app/utils/constants/sizes.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
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
                    'Басты бет',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: TColors.white),
                  ),
                  actions: [
                    Obx(() => Row(
                          children: [
                            Text(
                              "🌕 ${controller.userModel.value.balance}",
                              style:
                                  Theme.of(context).textTheme.titleSmall!.apply(
                                        color: TColors.white,
                                      ),
                            ),
                          ],
                        )),
                    const SizedBox(width: 10),
                    Obx(
                      () => controller.loading.value
                          ? const Center(child: CircularProgressIndicator())
                          : Hero(
                              tag: 'avatar',
                              child: Obx(
                                () {
                                  final networkImage = controller
                                      .userController.user.value.profilePicture;
                                  final image = networkImage.isNotEmpty
                                      ? networkImage
                                      : TImages.user;
                                  return controller
                                          .userController.imageUploading.value
                                      ? const CircularProgressIndicator()
                                      : TCircularImage(
                                          isNetworkImage:
                                              networkImage.isNotEmpty,
                                          image: image,
                                        );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          Obx(
            () {
              if (controller.subjects.isNotEmpty) {
                return Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 15),
                    itemBuilder: (context, index) => HomeButtons(
                      title: controller.subjects[index].title,
                      image: controller.subjects[index].image,
                      onPressed: () => Get.to(
                        () => ListBooksScreen(
                          title: controller.subjects[index].title,
                        ),
                        arguments: controller.subjects[index],
                      ),
                    ),
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: TSizes.spaceBtwSections),
                    itemCount: controller.subjects.length,
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
