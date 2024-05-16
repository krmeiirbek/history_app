import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/features/practice_test/screens/version/version.dart';
import 'package:history_app/utils/constants/colors.dart';

class TestingScreen extends StatelessWidget {
  const TestingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrowIcon: false,
        title: Text(
          "Тестілеу",
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.black),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (_, index) => const Divider(),
        itemCount: 3,
        itemBuilder: (_, index) {
          return ListTile(
            onTap: () => Get.to(() => const VersionScreen()),
            title: Text("Казақстан тарихы", style: Theme.of(context).textTheme.titleMedium),
          );
        },
      ),
    );
  }
}
