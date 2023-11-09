import 'option_model.dart';

class QuestionModel {
  final String questionId;
  final String question;
  final List<OptionModel> options;

  QuestionModel({
    required this.questionId,
    required this.question,
    required this.options,
  });
}
