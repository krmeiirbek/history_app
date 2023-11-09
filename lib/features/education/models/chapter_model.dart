import 'quiz_model.dart';

class ChapterModel {
  final String chapterId;
  final String bookId;
  final String subjectId;
  final String image;
  final String title;
  final double price;
  final double discount; // 0-100
  List<QuizModel> quizzes;

  ChapterModel({
    required this.chapterId,
    required this.bookId,
    required this.subjectId,
    required this.image,
    required this.title,
    required this.price,
    required this.discount,
    required this.quizzes,
  });
}
