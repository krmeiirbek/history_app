import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/features/education/controllers/chapter_controller.dart';
import 'package:history_app/features/education/screens/quizzes/quizzes.dart';
import 'package:history_app/utils/constants/sizes.dart';

class ChaptersScreen extends GetView<ChapterController> {
  const ChaptersScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ChapterController());
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "Тараулар",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: TSizes.defaultSpace),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: controller.chapters.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, index) => const Divider(height: 5),
            itemBuilder: (_, index) {
              return ListTile(
                onTap: () => Get.to(
                  () => const QuizzesScreen(),
                ),
                leading: Image(image: AssetImage(controller.chapters[index].image)),
                title: Text(
                  '${index + 1}-тарау',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(fontSizeDelta: -0.1, fontWeightDelta: 1),
                ),
                subtitle: Text(
                  controller.chapters[index].title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(fontSizeDelta: 1),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
