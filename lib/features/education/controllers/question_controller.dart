import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/features/education/models/option_model.dart';
import 'package:history_app/features/education/models/question_model.dart';
import 'package:history_app/features/education/models/quiz_model.dart';
import 'package:history_app/utils/constants/sizes.dart';

class QuestionController extends GetxController {
  static QuestionController get instance => Get.find();

  final time = 0.obs;
  late Timer timer;
  final questionId = 0.obs;
  ScrollController scrollController = ScrollController();
  late QuizModel quizModel;
  final loading = true.obs;
  final questions = <QuestionModel>[].obs;
  final selectedOptions = <RxList<OptionModel>>[].obs;

  @override
  void onInit() {
    super.onInit();
    quizModel = Get.arguments as QuizModel;
    getQuestionsData();
  }

  void getQuestionsData() async {
    loading.value = true;
    questions.value = await EducationRepository.instance.getQuestions(
      quizModel.subjectId,
      quizModel.bookId,
      quizModel.chapterId,
      quizModel.quizId,
    );
    startTimer();
    for(final _ in questions){
      selectedOptions.add(<OptionModel>[].obs);
    }
    loading.value = false;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      time.value++;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    scrollController.dispose();
    super.dispose();
  }

  void changeQuestion(int index) {
    questionId.value = index;
    scrollToIndex(index);
  }

  void scrollToIndex(int index) {
    double screenWidth = Get.width; // Get the screen width
    double itemWidth = TSizes.indexedCard + 10; // Width of the item plus separator
    double centerPosition = (index * itemWidth) - screenWidth / 2 + itemWidth / 2;

    // Calculate the maximum scroll extent
    double maxScrollExtent = scrollController.position.maxScrollExtent;

    // Check if the selected index is at the start or end of the list
    if (index == 0) {
      // If the first item is selected, scroll to the start
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (index == questions.length - 1) {
      // If the last item is selected, scroll to the end
      scrollController.animateTo(
        maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Otherwise, center the selected item
      double scrollPosition = min(maxScrollExtent, max(0, centerPosition));
      scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
      scrollToIndex(questionId.value);
    }
  }

  void prevQuestion() {
    if (0 != questionId.value) {
      questionId.value--;
      scrollToIndex(questionId.value);
    }
  }
}
