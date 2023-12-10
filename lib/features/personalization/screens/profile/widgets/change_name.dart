import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/personalization/controllers/update_name_controller.dart';
import 'package:history_app/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(
        showBackArrowIcon: true,
        title: Text('Атын өзгерту',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(
                'Оңай растау үшін нақты атауды пайдаланыңыз. Бұл атау бірнеше бетте пайда болады.',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Text field and Button
            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) =>
                        TValidator.validateEmptyText('Аты', value),
                    expands: false,
                    controller: controller.firstName,
                    decoration: const InputDecoration(
                      labelText: 'Аты',
                      prefixIcon: Icon(Iconsax.user_edit),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    validator: (value) =>
                        TValidator.validateEmptyText('Тегі', value),
                    expands: false,
                    controller: controller.lastName,
                    decoration: const InputDecoration(
                      labelText: 'Тегі',
                      prefixIcon: Icon(Iconsax.user_edit),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.updateUserName(),
                    child: const Text('Сақтау'))),
          ],
        ),
      ),
    );
  }
}
