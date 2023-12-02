import 'package:get/get.dart';
import 'package:history_app/data/repository/user/user_repository.dart';
import 'package:history_app/features/authentication/models/user_model.dart';

class PersonalizationController extends GetxController {
  static PersonalizationController get instance => Get.find();

  var userModel = UserModel.empty();
  final loading = true.obs;

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  void getUserData() async {
    loading.value = true;
    userModel = await UserRepository().instance.getUserData();
    loading.value = false;
  }
}
