import 'package:get/get.dart';
import 'package:history_app/features/education/models/option_model.dart';
import 'package:history_app/features/education/models/question_model.dart';

class ResultWithOptionsController extends GetxController {
  final loading = false.obs;
  late List<QuestionModel> questions;
  late List<List<OptionModel>> selectedOptions;
  final questionId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loading.value = true;
    questions = Get.arguments["questions"] as List<QuestionModel>;
    selectedOptions = Get.arguments["selectedOptions"] as List<List<OptionModel>>;
    loading.value = false;
  }


  void changeQuestion(int index) {
    questionId.value = index;
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