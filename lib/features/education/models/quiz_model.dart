import 'quiz_item_model.dart';

class QuizModel {
  String quizId;
  List<QuizItemModel> items;

  QuizModel({
    required this.quizId,
    required this.items,
  });

  static QuizModel empty() => QuizModel(quizId: '', items: []);
}