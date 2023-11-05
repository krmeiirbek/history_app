import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';


class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(
        showBackArrowIcon: true,
        title: Text('Change Name', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text('Use real name for easy verification. This name will appear on several pages.',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Text field and Button
            const TextField(decoration: InputDecoration(labelText: 'Name', prefixIcon: Icon(Iconsax.user_edit))),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Save'))),
          ],
        ),
      ),
    );
  }
}