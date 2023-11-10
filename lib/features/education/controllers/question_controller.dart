import 'dart:async';

import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/dummy_data.dart';
import 'package:history_app/features/education/models/option_model.dart';
import 'package:history_app/features/education/models/quiz_model.dart';

class QuestionController extends GetxController {
  static QuestionController get instance => Get.find();

  final time = 0.obs;
  late Timer timer;
  final questionId = 0.obs;
  late QuizModel quizModel;

  final questions = TDummyData.questions;
  final selectedOptions = <RxList<OptionModel>>[].obs;

  @override
  void onInit() {
    super.onInit();
    quizModel = Get.arguments as QuizModel;
    quizModel.copyWith(questions: questions);
    startTimer();
    for(final _ in questions){
      selectedOptions.add(<OptionModel>[].obs);
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      time.value++;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void changeQuestion(int index) {
    questionId.value = index;
  }

  void selectOption(OptionModel option, int index) {
    if (selectedOptions[index].contains(option)) {
      selectedOptions[index].remove(option);
    } else {
      selectedOptions[index].add(option);
    }
  }

  void nextQuestion() {
    if (questions.length != questionId.value + 1) {
      questionId.value++;
    }
  }

  void prevQuestion() {
    if (0 != questionId.value) {
      questionId.value--;
    }
  }
}
