import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PrivacyPolicyController extends GetxController {
  static PrivacyPolicyController get instance => Get.find();

  Future<String> fetchMarkdownContent(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Markdown файлы жүктелмеді');
    }
  }
}
