import 'package:get/get.dart';
import 'package:history_app/data/repository/authentication/authentication_repository.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/features/education/models/history_model.dart';
import 'package:history_app/features/education/models/option_model.dart';
import 'package:history_app/features/education/models/question_model.dart';
import 'package:history_app/features/education/models/quiz_model.dart';
import 'package:history_app/utils/popups/loaders.dart';

class ResultController extends GetxController {
  final loading = false.obs;
  late QuizModel quiz;
  late List<QuestionModel> questions;
  late List<List<OptionModel>> selectedOptions;
  final maxPoint = 0.obs;
  final resultPoint = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    loading.value = true;
    quiz = await Get.arguments["quiz"] as QuizModel;
    questions = quiz.questions;
    selectedOptions =
        await Get.arguments["selectedOptions"] as List<List<OptionModel>>;
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
      final correctAnswers = <OptionModel>[].obs;
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
    if(userId == null){
      TLoaders.warningSnackBar(title: 'history not saved');
      return;
    }
    final historyRecord = HistoryModel(
      historyId: userId,
      subjectTitle: quiz.subjectTitle ?? '',
      bookTitle: quiz.bookTitle ?? '',
      chapterTitle: quiz.chapterTitle ?? '',
      quizTitle: quiz.title,
      passedDate: DateTime.now(),
      maxPoint: maxPoint.value,
      resultPoint: resultPoint.value,
    );
    await EducationRepository.instance.saveHistory(historyRecord);
  }
}
