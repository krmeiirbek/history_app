import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/dummy_data.dart';
import 'package:history_app/features/education/models/history_model.dart';
import 'package:history_app/features/education/models/option_model.dart';
import 'package:history_app/features/education/models/question_model.dart';
import 'package:history_app/features/education/models/quiz_model.dart';

class ResultController extends GetxController {
  final loading = false.obs;
  late QuizModel quiz;
  late List<QuestionModel> questions;
  late List<List<OptionModel>> selectedOptions;
  final maxPoint = 0.obs;
  final resultPoint = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loading.value = true;
    quiz = Get.arguments["quiz"] as QuizModel;
    questions = quiz.questions;
    selectedOptions =
        Get.arguments["selectedOptions"] as List<List<OptionModel>>;
    loading.value = false;
    esepteu();
    saveToHistory();
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
  }

  void saveToHistory() {
    TDummyData.histories.add(
      HistoryModel(
        historyId: '',
        item: quiz,
        orderDate: DateTime.now(),
        maxPoint: maxPoint.value,
        resultPoint: resultPoint.value,
      ),
    );
  }
}
