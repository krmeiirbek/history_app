import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/features/education/controllers/list_book_controller.dart';
import 'package:history_app/features/education/screens/chapters/chapters.dart';
import 'package:history_app/features/education/screens/list_books/widgets/list_books_buttons.dart';
import 'package:history_app/utils/constants/sizes.dart';

class ListBooksScreen extends GetView<ListBookController> {
  final String title;

  const ListBooksScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ListBookController());
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          title,
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
            child: Padding(
              padding: const EdgeInsets.only(top: TSizes.defaultSpace),
              child: (controller.books.isEmpty
                  ? const Center(
                      child: Text('Кітаптар жоқ'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.books.length,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, index) => const SizedBox(height: 5),
                      itemBuilder: (_, index) {
                        return BookButtons(
                            onPressed: () => Get.to(
                                  () => const ChaptersScreen(),
                                  arguments: controller.books[index].copyWith(
                                    subjectId: controller.subject.subjectId,
                                    subjectTitle: controller.subject.title,
                                  ),
                                ),
                            title: controller.books[index].title,
                            image: controller.books[index].image);
                      },
                    )),
            ),
          );
        }
      }),
    );
  }
}
