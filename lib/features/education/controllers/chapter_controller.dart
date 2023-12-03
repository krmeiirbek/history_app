import 'package:get/get.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/features/education/models/book_model.dart';
import 'package:history_app/features/education/models/chapter_model.dart';

class ChapterController extends GetxController {
  static ChapterController get instance => Get.find();

  var chapters = <ChapterModel>[].obs;
  final loading = true.obs;
  late BookModel book;

  @override
  void onInit() {
    book = Get.arguments as BookModel;
    getChaptersDate();
    super.onInit();
  }

  void getChaptersDate() async {
    loading.value = true;
    chapters.value = await EducationRepository()
        .instance
        .getChapters(book.subjectId, book.bookId);
    loading.value = false;
  }
}
