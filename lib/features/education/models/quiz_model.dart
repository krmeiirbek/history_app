import 'question_model.dart';

class QuizModel {
  final String quizId;
  final String chapterId;
  final String bookId;
  final String subjectId;
  final double price;
  final double discount; // 0-100
  final String title;
  final List<QuestionModel> questions;

  QuizModel({
    required this.quizId,
    required this.chapterId,
    required this.bookId,
    required this.subjectId,
    required this.price,
    required this.discount,
    required this.title,
    required this.questions,
  });
}
