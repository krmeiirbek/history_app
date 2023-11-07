// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/common/widgets/topics_list/topics_list.dart';
import 'package:history_app/utils/constants/sizes.dart';

class Chapters extends StatelessWidget {
  Chapters({super.key, required this.chapter});

  dynamic chapter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "Chapters",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: TSizes.defaultSpace),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: chapter.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, index) => const Divider(height: 5),
            itemBuilder: (_, index) {
              return ListTile(
                onTap: () => Get.to(
                  () => TopicsList(
                    topics: chapter[index].topic,
                  ),
                ),
                leading: Image(image: AssetImage(chapter[index].image)),
                title: Text(
                  '${chapter[index].id}-chapter',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(fontSizeDelta: -0.1, fontWeightDelta: 1),
                ),
                subtitle: Text(
                  chapter[index].title,
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
