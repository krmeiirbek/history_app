import 'option_model.dart';

class QuestionModel {
  final String questionId;
  final String question;
  final String? image;
  final List<OptionModel> options;

  QuestionModel({
    required this.questionId,
    required this.question,
    this.image,
    required this.options,
  });
}