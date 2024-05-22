import 'package:cached_network_image/cached_network_image.dart';
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
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
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
                      arguments: controller.chapters[index].copyWith(
                        bookId: controller.book.bookId,
                        subjectId: controller.book.subjectId,
                        subjectTitle: controller.book.subjectTitle,
                        bookTitle: controller.book.title,
                      ),
                    ),
                    leading: SizedBox(
                      height: 30,
                      width: 30,
                      child: controller.chapters[index].image == ''
                          ? const Icon(Icons.category_outlined)
                          : CachedNetworkImage(
                              imageUrl: controller.chapters[index].image,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                    ),
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
          );
        }
      }),
    );
  }
}
