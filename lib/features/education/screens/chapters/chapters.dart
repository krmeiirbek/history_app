import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/models/chapter_model.dart';
import 'package:history_app/features/education/models/topics_model.dart';
import 'package:history_app/common/widgets/topics_list/topics_list.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/sizes.dart';

class Chapters extends StatelessWidget {
  Chapters({super.key});

  final models = [
    topicsModel1,
    topicsModel2,
    topicsModel3,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chapters",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .apply(color: TColors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: TSizes.defaultSpace),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemCount: chapterModel.length,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, index) => const Divider(height: 5),
                itemBuilder: (_, index) {
                  return ListTile(
                    onTap: () => Get.to(
                      () => TopicsList(
                        topics: models[index],
                      ),
                    ),
                    leading:
                        Image(image: AssetImage(chapterModel[index].image)),
                    title: Text(
                      '${chapterModel[index].id}-chapter',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(fontSizeDelta: -0.1, fontWeightDelta: 1),
                    ),
                    subtitle: Text(
                      chapterModel[index].title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(fontSizeDelta: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
