import 'package:get/get.dart';
import 'package:history_app/data/repository/authentication/authentication_repository.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/features/education/models/history_model.dart';
import 'package:history_app/utils/popups/loaders.dart';
import '../models/ubt_option_model.dart';
import '../models/ubt_question_model.dart';
import '../models/ubt_quiz_model.dart';

class UBTResultController extends GetxController {
  final loading = false.obs;
  late UBTQuizModel quiz;
  late List<UBTQuestionModel> questions;
  late List<List<UBTOptionModel>> selectedOptions;
  final maxPoint = 0.obs;
  final resultPoint = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    loading.value = true;
    quiz = await Get.arguments["quiz"] as UBTQuizModel;
    questions = quiz.questions;
    selectedOptions = await Get.arguments["selectedOptions"] as List<List<UBTOptionModel>>;
    if (questions.isNotEmpty) {
      esepteu();
    } else {
      maxPoint.value = -1;
    }
    loading.value = false;
  }

  void esepteu() {
    for (var i = 0; i < questions.length; i++) {
      var correctAnswerSize = 0;
      final correctAnswers = <UBTOptionModel>[].obs;
      var userAnswers = 0;
      for (final option in questions[i].options) {
        if (option.isCorrect) {
          correctAnswerSize++;
          correctAnswers.add(option);
        }
      }
      for (final selectedOption in selectedOptions[i]) {
        if (correctAnswers.contains(selectedOption)) {
          userAnswers++;
        } else {
          userAnswers--;
        }
      }
      if (correctAnswerSize == 0) {
        maxPoint.value++;
        continue;
      } else if (correctAnswerSize > 1) {
        maxPoint.value += 2;
        if (userAnswers / correctAnswerSize == 1) {
          resultPoint.value += 2;
        } else if (userAnswers / correctAnswerSize > 0.5) {
          resultPoint.value++;
        }
      } else if (correctAnswerSize == 1) {
        maxPoint.value++;
        if (userAnswers == 1) {
          resultPoint.value++;
        }
      }
    }
    saveToHistory();
  }

  Future<void> saveToHistory() async {
    final userId = AuthenticationRepository.instance.authUser?.uid;
    if (userId == null) {
      TLoaders.warningSnackBar(title: 'Тарих сақталмады');
      return;
    }
    final historyRecord = HistoryModel(
      historyId: userId,
      subjectTitle: quiz.subjectTitle ?? '',
      bookTitle: '',
      chapterTitle: '',
      quizTitle: quiz.title,
      passedDate: DateTime.now(),
      maxPoint: maxPoint.value,
      resultPoint: resultPoint.value,
    );
    await EducationRepository.instance.saveHistory(historyRecord);
  }
}
