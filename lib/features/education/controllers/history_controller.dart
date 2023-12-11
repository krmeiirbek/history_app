import 'package:get/get.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/features/education/models/history_model.dart';

class HistoryController extends GetxController {
  static HistoryController get instance => Get.find();
  var histories = <HistoryModel>[].obs;
  final loading = true.obs;

  @override
  void onInit() {
    getSubjectsDate();
    super.onInit();
  }

  void getSubjectsDate() async {
    loading.value = true;
    histories.value = await EducationRepository.instance.getHistories();
    loading.value = false;
  }
}