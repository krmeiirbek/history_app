import 'dart:async';

import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/dummy_data.dart';
import 'package:history_app/features/education/models/option_model.dart';

class QuestionController extends GetxController {
  static QuestionController get instance => Get.find();

  final time = 0.obs;
  late Timer timer;
  final questionId = 0.obs;

  final questions = TDummyData.questions;
  final selectedOptions = <OptionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
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

  void selectOption(OptionModel option) {
    if (selectedOptions.contains(option)) {
      selectedOptions.remove(option);
    } else {
      selectedOptions.add(option);
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
