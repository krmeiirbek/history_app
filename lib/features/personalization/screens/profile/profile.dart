import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/personalization/controllers/personalization_controller.dart';
import 'package:history_app/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';
import 'change_name.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PersonalizationController.instance;
    return Scaffold(
      appBar: TAppBar(
        showBackArrowIcon: true,
        title: Text('Профильді өзгерту', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    TCircularImage(image: controller.userModel.profilePicture, width: 80, height: 80),
                    TextButton(onPressed: () {}, child: const Text('Change Profile Picture')),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Profile Information'),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(onPressed: () => Get.to(() => const ChangeName()), title: 'Name', value: controller.userModel.fullName),
              TProfileMenu(onPressed: () {}, title: 'Username', value: controller.userModel.userName),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Personal Information'),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(onPressed: () {}, title: 'User ID', value: controller.userModel.id, icon: Iconsax.copy),
              TProfileMenu(onPressed: () {}, title: 'E-mail', value: controller.userModel.email),
              TProfileMenu(onPressed: () {}, title: 'Phone Number', value: controller.userModel.phoneNumber),
              TProfileMenu(onPressed: () {}, title: 'Gender', value: 'Male'),
              TProfileMenu(onPressed: () {}, title: 'Date of Birth', value: '10 Oct, 1994'),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: TextButton(
                    onPressed: () {}, child: const Text('Close Account', style: TextStyle(color: Colors.red))),
              )
            ],
          ),
        ),
      ),
    );
  }
}