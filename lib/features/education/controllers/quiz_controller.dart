import 'package:get/get.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/data/repository/user/user_repository.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/features/education/models/chapter_model.dart';
import 'package:history_app/features/education/models/quiz_model.dart';
import 'package:history_app/utils/popups/loaders.dart';

class QuizController extends GetxController {
  static QuizController get instance => Get.find();

  var quizzes = <QuizModel>[].obs;
  var currentUser = UserModel.empty().obs;
  final loading = true.obs;
  final loadingForBuyingQuiz = false.obs;
  late ChapterModel chapter;

  @override
  void onInit() {
    chapter = Get.arguments as ChapterModel;
    getUserDate();
    super.onInit();
  }

  void getUserDate() async {
    loading.value = true;
    currentUser.value = await UserRepository().instance.getUserData();
    getQuizzesDate();
    loading.value = false;
  }

  void getQuizzesDate() async {
    loading.value = true;
    quizzes.value = await EducationRepository().instance.getQuizzes(
          chapter.subjectId,
          chapter.bookId,
          chapter.chapterId,
        );
    isBuy();
    loading.value = false;
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

  void buyQuiz({required QuizModel quiz}) async {
    if (currentUser.value.balance >= quiz.price) {
      currentUser.value.sandyq.add(quiz.quizId);
      currentUser.value = currentUser.value.copyWith(
        balance: currentUser.value.balance - quiz.price,
      );
      print(currentUser.value.id);
      loadingForBuyingQuiz.value = true;
      await UserRepository().instance.updateUserRecord(currentUser.value);
      loadingForBuyingQuiz.value = false;
      isBuy();
      update();
      Get.back();
    } else {
      Get.back();
      TLoaders.warningSnackBar(title: 'Қаражатыңыз жеткіліксіз');
    }
  }
}
