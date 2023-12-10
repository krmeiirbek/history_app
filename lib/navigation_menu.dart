import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/features/education/controllers/home_controller.dart';
import 'package:history_app/features/education/screens/home/home.dart';
import 'package:history_app/features/personalization/controllers/user_controller.dart';
import 'package:history_app/features/personalization/screens/settings/settings.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const HomeScreen(),
    const SettingsScreen(),
  ];
}

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    Get.put(EducationRepository());
    Get.put(UserController());
    Get.put(HomeController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          backgroundColor: dark ? TColors.black : TColors.white,
          indicatorColor: dark
              ? TColors.white.withOpacity(0.1)
              : TColors.black.withOpacity(0.1),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              label: 'Мәзір',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.setting),
              label: 'Баптаулар',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}
