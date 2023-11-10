import 'chapter_model.dart';

class BookModel {
  final String bookId;
  final String subjectId;
  final String title;
  final String image;
  final double price;
  final double discount; // 0-100
  List<ChapterModel> chapters;

  BookModel({
    required this.bookId,
    required this.subjectId,
    required this.title,
    required this.image,
    required this.price,
    required this.discount,
    required this.chapters,
  });
}