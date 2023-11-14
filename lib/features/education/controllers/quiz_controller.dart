import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/dummy_data.dart';
import 'package:history_app/features/education/models/quiz_model.dart';

class QuizController extends GetxController {
  final quizzes = TDummyData.quizzes.obs;
  final currentUser = TDummyData.user;

  @override
  void onInit() {
    isBuy();
    super.onInit();
  }

  void isBuy() {
    // Create a new list of quizzes with updated isBuy property
    final updatedQuizzes = quizzes.map((quiz) {
      final isBought = currentUser.value.sandyq.contains(quiz.quizId);
      return quiz.copyWith(isBuy: isBought);
    }).toList();

    // Update the quizzes list with the new list of updated quizzes
    quizzes.assignAll(updatedQuizzes);
  }

  void buyQuiz({required QuizModel quiz}) {
    if (currentUser.value.balance >= quiz.price) {
      currentUser.value.sandyq.add(quiz.quizId);
      currentUser.value = currentUser.value.copyWith(
        balance: currentUser.value.balance - quiz.price,
      );
      TDummyData.user.value = currentUser.value;
      isBuy();
      update();
      Get.back();
    } else {
      Get.back();
      Get.snackbar(
        'Snackbar Title',
        'This is a Get Snackbar!',
        snackPosition: SnackPosition.BOTTOM, // Position of the Snackbar
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: Duration(seconds: 3), // Duration for how long the Snackbar is displayed
        snackStyle: SnackStyle.GROUNDED, // Snackbar style
        margin: EdgeInsets.all(10.0), // Margin around the Snackbar
        borderRadius: 10.0, // BorderRadius of the Snackbar
        isDismissible: true, // Allow dismissing the Snackbar
      );
    }
  }
}
