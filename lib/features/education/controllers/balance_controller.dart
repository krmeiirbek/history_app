import 'package:get/get.dart';
import 'package:history_app/features/education/controllers/dummy_data.dart';
class BalanceController extends GetxController {
  static BalanceController get instance => Get.find();

  final balance = TDummyData.user.balance;
  final quizzes = TDummyData.quizzes;


}
