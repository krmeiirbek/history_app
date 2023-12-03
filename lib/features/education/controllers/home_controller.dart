import 'package:get/get.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/data/repository/user/user_repository.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/features/education/models/subject_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var userModel = UserModel.empty().obs;
  var subjects = <SubjectModel>[].obs;
  final loading = true.obs;


  @override
  void onInit() {
    getUserDate();
    getSubjectsDate();
    super.onInit();
  }

  void getUserDate() async {
    loading.value = true;
    userModel.value = await UserRepository().instance.getUserData();
    loading.value = false;
  }

  void getSubjectsDate() async {
    loading.value = true;
    subjects.value = await EducationRepository().instance.getSubjects();
    loading.value = false;
  }
}