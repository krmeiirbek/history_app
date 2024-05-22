import 'package:get/get.dart';
import 'package:history_app/data/repository/education/education_repository.dart';

import '../models/ubt_subject_model.dart';

class UBTController extends GetxController {
  static UBTController get instance => Get.find();

  var ubt_subjects = <UBTSubjectModel>[].obs;
  final loading = true.obs;

  @override
  void onInit() {
    getSubjectsDate();
    super.onInit();
  }

  void getSubjectsDate() async {
    loading.value = true;
    ubt_subjects.value = await EducationRepository.instance.getUBTSubjects();
    loading.value = false;
    print('ubt subject length ${ubt_subjects.length}');
  }
}
