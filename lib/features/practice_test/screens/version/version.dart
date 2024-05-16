import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/sizes.dart';
class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: TAppBar(
        showBackArrowIcon: true,
        title: Text(
          "Нұсқалар",
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultBtwItems),
        child: ListView.separated(
          separatorBuilder: (_, index) => const SizedBox(height: TSizes.spaceBtwSections),
          itemCount: 2,
          itemBuilder: (_, index) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white
              ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'ҰБТ стандарты бойынша',
                    style: TextStyle(
                        fontSize: TSizes.fontSizeLg,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'xyz - нұсқа',
                    style: TextStyle(
                        fontSize: TSizes.fontSizeLg,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Сұрақтар саны: zx',
                    style: TextStyle(
                        fontSize: TSizes.fontSizeLg,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.blue
                      ),
                      child: const Center(child: Text('Бастау',style: TextStyle(
                        color: Colors.white,
                          fontSize: TSizes.fontSizeLg,
                          fontWeight: FontWeight.w300))),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
