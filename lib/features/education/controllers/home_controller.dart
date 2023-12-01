import 'package:get/get.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/features/personalization/controllers/personalization_controller.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var userModel = UserModel.empty();
  final loading = true.obs;

  @override
  void onInit() {
    loading.value = true;
    PersonalizationController.instance.getUserData();
    userModel = PersonalizationController.instance.userModel;
    loading.value = false;
    super.onInit();
  }
}