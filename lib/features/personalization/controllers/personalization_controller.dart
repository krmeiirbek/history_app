import 'package:get/get.dart';
import 'package:history_app/data/repository/user/user_repository.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

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

  void launchWhatsAppUri() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+77475551101',
      text: "Мен тарих қолданбасындағы теңгерімімді толтырғым келеді.\nUID: ${userModel.id}",
    );
    await launchUrl(link.asUri());
  }
}
