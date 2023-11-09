import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/features/education/models/chapter_model.dart';
import 'package:history_app/features/education/screens/quizzes/quizzes.dart';
import 'package:history_app/utils/constants/sizes.dart';

class ChaptersScreen extends StatelessWidget {
  final List<ChapterModel> chapters;

  const ChaptersScreen({
    super.key,
    required this.chapters,
  });


  @override
  Widget build(BuildContext context) {
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
            itemCount: chapters.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, index) => const Divider(height: 5),
            itemBuilder: (_, index) {
              return ListTile(
                onTap: () => Get.to(
                  () => QuizzesScreen(
                    quizzes: chapters[index].quizzes,
                  ),
                ),
                leading: Image(image: AssetImage(chapters[index].image)),
                title: Text(
                  '${index + 1}-тарау',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(fontSizeDelta: -0.1, fontWeightDelta: 1),
                ),
                subtitle: Text(
                  chapters[index].title,
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
