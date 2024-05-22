import 'package:get/get.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/features/ubt/models/ubt_quiz_model.dart';
import 'package:history_app/features/ubt/models/ubt_subject_model.dart';

class UBTQuizController extends GetxController {
  static UBTQuizController get instance => Get.find();

  var quizzes = <UBTQuizModel>[].obs;
  final loading = true.obs;
  late UBTSubjectModel subject;

  @override
  void onInit() {
    subject = Get.arguments as UBTSubjectModel;
    getQuizzesDate();
    super.onInit();
  }

  void getQuizzesDate() async {
    loading.value = true;
    quizzes.value = await EducationRepository.instance.getUBTQuizzes(subject.subjectId);
    loading.value = false;
  }
}
