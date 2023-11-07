// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/features/education/models/chapter_model.dart';
import 'package:history_app/features/education/screens/chapters/chapters.dart';
import 'package:history_app/features/education/screens/list_books/widgets/list_books_buttons.dart';
import 'package:history_app/utils/constants/sizes.dart';

class ListBooks extends StatelessWidget {
  final String title;
  final dynamic subTitle;
  final dynamic image;
  final int itemCount;
  final int id;

  ListBooks({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
    required this.itemCount,
    required this.id,
  });

  final chapterHK = [
    ChapterModelHK_5,
    ChapterModelHK_6,
    ChapterModelHK_7,
    ChapterModelHK_8,
    ChapterModelHK_9,
    ChapterModelHK_10,
    ChapterModelHK_11,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Books',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: TSizes.defaultSpace),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: itemCount,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, index) => const SizedBox(height: 5),
            itemBuilder: (_, index) {
              return BookButtons(
                onPressed: () => Get.to(
                  () => Chapters(
                      chapter: id == 1 ? chapterHK[index] : ChapterModelWH),
                ),
                title: title,
                subTitle: '${subTitle[index].class_} - class',
                image: image[index].image,
              );
            },
          ),
        ),
      ),
    );
  }
}
