import 'package:get/get.dart';
import 'package:history_app/data/repository/user/user_repository.dart';
import 'package:history_app/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(UserRepository());
  }
}
