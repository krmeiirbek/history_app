import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:history_app/common/widgets/texts/section_heading.dart';
import 'package:history_app/common/widgets/user/user_profile_card.dart';
import 'package:history_app/data/repository/authentication/authentication_repository.dart';
import 'package:history_app/features/education/screens/history/history.dart';
import 'package:history_app/features/personalization/controllers/personalization_controller.dart';
import 'package:history_app/features/personalization/screens/profile/profile.dart';
import 'package:history_app/features/personalization/screens/settings/widgets/settings_menu.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PersonalizationController.instance;
    return Scaffold(
      body: Column(
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
                    'Есептік жазба',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: TColors.white),
                  ),
                ),
                Obx(() {
                  if (controller.loading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return TUserProfileCard(
                      user: controller.userModel,
                      actionButtonOnPressed: () =>
                          Get.to(() => const ProfileScreen()),
                    );
                  }
                }),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),

          /// -- Profile Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// -- Account  Settings
                        const TSectionHeading(title: 'Есеп жазбасын түзету'),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        TSettingsMenu(
                          icon: Iconsax.bag_tick,
                          title: 'Менің тарихтарым',
                          subTitle: 'Аяқталған сынақтар',
                          onPressed: () => Get.to(() => const HistoryScreen()),
                        ),
                        TSettingsMenu(
                          icon: Iconsax.bank,
                          title: 'Теңгерімді толтыру',
                          subTitle:
                              'Сілтеме арқылы whatsapp-та қанша 🌕 толтыру керектігін хабарлайсыз',
                          onPressed: () => controller.launchWhatsAppUri(),
                        ),
                        const TSettingsMenu(
                            icon: Iconsax.discount_shape,
                            title: 'Қолданба туралы',
                            subTitle: 'Қолданба туралы ақпарат'),
                        const TSettingsMenu(
                            icon: Iconsax.security_card,
                            title: 'Қолдану ережесі',
                            subTitle: 'Қолданбаны пайдалану ережелері және басқада келісім шарттар'),

                        /// -- Logout Button
                        const SizedBox(height: TSizes.spaceBtwSections),
                        SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: () =>
                                    AuthenticationRepository.instance.logout(),
                                child: const Text('Шығу'))),
                        const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
