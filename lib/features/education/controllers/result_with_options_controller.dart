import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/models/option_model.dart';
import 'package:history_app/features/education/models/question_model.dart';
import 'package:history_app/utils/constants/sizes.dart';

class ResultWithOptionsController extends GetxController {
  final loading = false.obs;
  late List<QuestionModel> questions;
  late List<List<OptionModel>> selectedOptions;
  final questionId = 0.obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loading.value = true;
    questions = Get.arguments["questions"] as List<QuestionModel>;
    selectedOptions = Get.arguments["selectedOptions"] as List<List<OptionModel>>;
    loading.value = false;
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

  void changeQuestion(int index) {
    questionId.value = index;
    scrollToIndex(index);
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