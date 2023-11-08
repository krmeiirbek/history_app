
import 'package:get/get.dart';
import 'package:history_app/features/education/models/question_model.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<QuestionModel> _questions = question
      .map(
        (e) =>
        QuestionModel(
          id: e.id,
          answer: e.answer,
          question: e.question,
          options: e.options,
        ),
  )
      .toList();

  List<QuestionModel> get questions => _questions;

  late bool _isAnswered = false;

  bool get isAnswered => _isAnswered;

  late int _correctAns;

  int get correctAns => _correctAns;

  late int _selectedAns;

  int get selectedAns => _selectedAns;

  final RxInt _questionNumber = 1.obs;

  RxInt get questionNumber => _questionNumber;

  late int _numOfCorrectAns = 0;

  int get numOfCorrectAns => _numOfCorrectAns;









  void checkAns(QuestionModel questionModel, int selectedIndex) {
    _isAnswered = true;
    _correctAns = questionModel.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;
    update();


  }
}
