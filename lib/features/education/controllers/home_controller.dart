import 'package:get/get.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/features/education/models/subject_model.dart';
import 'package:history_app/features/personalization/controllers/personalization_controller.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var userModel = UserModel.empty();
  var subjects = <SubjectModel>[];
  final loading = true.obs;


  @override
  void onInit() {
    getUserDate();
    getSubjectsDate();
    super.onInit();
  }

  void getUserDate() async {
    loading.value = true;
    PersonalizationController.instance.getUserData();
    userModel = PersonalizationController.instance.userModel;
    loading.value = false;
  }

  void getSubjectsDate() async {
    loading.value = true;
    subjects = await EducationRepository().instance.getSubjects();
    loading.value = false;
  }
}