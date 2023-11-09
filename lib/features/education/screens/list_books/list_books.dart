import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/features/education/models/book_model.dart';
import 'package:history_app/features/education/screens/chapters/chapters.dart';
import 'package:history_app/features/education/screens/list_books/widgets/list_books_buttons.dart';
import 'package:history_app/utils/constants/sizes.dart';

class ListBooksScreen extends StatelessWidget {
  final List<BookModel> books;
  final String title;

  const ListBooksScreen({
    super.key,
    required this.books,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: TSizes.defaultSpace),
          child: books.isEmpty
              ? const Center(
                  child: Text('No Books'),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: books.length,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, index) => const SizedBox(height: 5),
                  itemBuilder: (_, index) {
                    return BookButtons(
                      onPressed: () => Get.to(
                        () => ChaptersScreen(
                          chapters: books[index].chapters,
                        ),
                      ),
                      title: books[index].title,
                      image: books[index].image,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
