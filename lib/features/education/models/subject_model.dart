import 'book_model.dart';

class SubjectModel {
  final String subjectId;
  final String title;
  final String image;
  final double price;
  final double discount; // 0-100
  List<BookModel> books;

  SubjectModel({
    required this.subjectId,
    required this.title,
    required this.image,
    required this.price,
    required this.discount,
    required this.books,
  });
}
