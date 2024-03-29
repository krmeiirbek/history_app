import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/personalization/controllers/user_controller.dart';
import 'package:history_app/features/personalization/screens/profile/widgets/change_phone.dart';
import 'package:history_app/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';
import 'widgets/change_name.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: TAppBar(
        showBackArrowIcon: true,
        title: Text('Профильді өзгерту',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Obx(
                          () {
                            final networkImage =
                                controller.user.value.profilePicture;
                            final image = networkImage.isNotEmpty
                                ? networkImage
                                : TImages.user;
                            return controller.imageUploading.value
                                ? const CircularProgressIndicator()
                                : TCircularImage(
                                    isNetworkImage: networkImage.isNotEmpty,
                                    image: image,
                                    width: 80,
                                    height: 80,
                                  );
                          },
                        ),
                        TextButton(
                            onPressed: () =>
                                controller.uploadUserProfilePicture(),
                            child: const Text('Профиль суретін өзгерту')),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const TSectionHeading(title: 'Профиль туралы ақпарат'),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TProfileMenu(
                      onPressed: () async {
                        await Get.to(() => const ChangeName());
                        controller.fetchUserRecord();
                      },
                      title: 'Аты',
                      value: controller.user.value.fullName),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const TSectionHeading(title: 'Жеке ақпарат'),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TProfileMenu(
                    onPressed: () => controller.copyToClipboard(
                        controller.user.value.id, 'Қолданушы ID'),
                    title: 'Қолданушы ID',
                    value: controller.user.value.id,
                    icon: Iconsax.copy,
                  ),
                  TProfileMenu(
                    onPressed: () => controller.copyToClipboard(
                        controller.user.value.email, 'E-mail'),
                    title: 'E-mail',
                    value: controller.user.value.email,
                    icon: Iconsax.copy,
                  ),
                  TProfileMenu(
                      onPressed: () async {
                        await Get.to(() => const ChangePhone());
                        controller.fetchUserRecord();
                      },
                      title: 'Телефон нөмірі',
                      value: controller.user.value.phoneNumber),
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Center(
                    child: TextButton(
                        onPressed: () => controller.deleteAccountWarningPopup(),
                        child: const Text('Есептік жазбаны жою',
                            style: TextStyle(color: Colors.red))),
                  )
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
