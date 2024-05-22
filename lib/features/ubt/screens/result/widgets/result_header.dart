import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:history_app/navigation_menu.dart';
import 'package:history_app/utils/constants/sizes.dart';

class UBTTResultHeader extends StatelessWidget {
  const UBTTResultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return TPrimaryHeaderContainer(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      return Text(
                        'Нәтиже',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.white),
                      );
                    },
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Get.offAll(() => const NavigationMenu());
                    },
                    child: Text(
                      "Басты бет",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: TSizes.md),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
