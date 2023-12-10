import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/personalization/controllers/update_phone_controller.dart';
import 'package:history_app/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';

class ChangePhone extends StatelessWidget {
  const ChangePhone({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatePhoneController());
    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(
        showBackArrowIcon: true,
        title: Text('Телефон нөмерін өзгерту',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(
                'Телефон нөмеріңізді 87xxxxxxxxx форматында енгізіңіз',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Text field and Button
            Form(
              key: controller.updateUserPhoneNumberFormKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) =>
                        TValidator.validatePhoneNumber(value),
                    expands: false,
                    controller: controller.phoneNumber,
                    decoration: const InputDecoration(
                      labelText: 'Телефон нөмері',
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
                    onPressed: () => controller.updatePhoneNumber(),
                    child: const Text('Сақтау'))),
          ],
        ),
      ),
    );
  }
}
