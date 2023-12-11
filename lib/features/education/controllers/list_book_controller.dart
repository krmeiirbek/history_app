import 'package:get/get.dart';
import 'package:history_app/data/repository/education/education_repository.dart';
import 'package:history_app/features/education/models/book_model.dart';
import 'package:history_app/features/education/models/subject_model.dart';

class ListBookController extends GetxController {
  static ListBookController get instance => Get.find();

  var books = <BookModel>[].obs;
  final loading = true.obs;
  late SubjectModel subject;

  @override
  void onInit() {
    subject = Get.arguments as SubjectModel;
    getBooksDate();
    super.onInit();
  }

  void getBooksDate() async {
    loading.value = true;
    books.value = await EducationRepository.instance.getBooks(subject.subjectId);
    loading.value = false;
  }
}