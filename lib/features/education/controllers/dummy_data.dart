import 'package:history_app/features/education/models/book_model.dart';
import 'package:history_app/features/education/models/chapter_model.dart';

import '../../../utils/constants/image_strings.dart';
import '../../personalization/models/user_model.dart';
import '../models/history_model.dart';
import '../models/quiz_model.dart';
import '../models/subject_model.dart';

class TDummyData {
  /// -- User
  static final UserModel user = UserModel(
    firstName: 'Kazybek',
    lastName: 'Meiirbek',
    email: 'support@kazmei.com',
    phoneNumber: '+77775552001',
    password: '',
    profilePicture: TImages.user,
    balance: 1000,
  );

  /// -- history
  static final List<HistoryModel> histories = [
    HistoryModel(
      historyId: '',
      orderDate: DateTime(2023, 09, 1),
      maxPoint: 35,
      resultPoint: 18,
      item: QuizModel(
        subjectId: 'worldHistory',
        chapterId: 'chapterId',
        price: 500,
        title: 'Ottoman Empires',
        quizId: '',
        bookId: '',
        discount: 0,
        questions: [],
      ),
    ),
  ];

  static final List<SubjectModel> subjects = [
    SubjectModel(
      subjectId: 'iuhs61256',
      title: 'Қазақстан тарихы',
      image: 'assets/images/buttons/history_of_kazakhstan.png',
      price: 10000,
      discount: 0,
      books: books,
    ),
    SubjectModel(
      subjectId: 'ijoads123',
      title: 'Дүниежүзі тарихы',
      image: 'assets/images/buttons/world_history.png',
      price: 10000,
      discount: 0,
      books: [],
    ),
  ];
  static final List<BookModel> books = [
    BookModel(
      bookId: 'bookId',
      subjectId: 'subjectId',
      title: '6 Сынып',
      image: 'assets/images/buttons/history_of_kazakhstan.png',
      price: 5000,
      discount: 0,
      chapters: chapters,
    ),
    BookModel(
      bookId: 'bookId',
      subjectId: 'subjectId',
      title: '7 Сынып',
      image: 'assets/images/buttons/world_history.png',
      price: 5000,
      discount: 0,
      chapters: [],
    ),
  ];

  static final List<ChapterModel> chapters = [
    ChapterModel(
      chapterId: 'chapterId',
      bookId: 'bookId',
      subjectId: 'subjectId',
      image: 'assets/images/buttons/world_history.png',
      title: 'title',
      price: 1000,
      discount: 0,
      quizzes: quizzes,
    ),
    ChapterModel(
      chapterId: 'chapterId',
      bookId: 'bookId',
      subjectId: 'subjectId',
      image: 'assets/images/buttons/world_history.png',
      title: 'title222',
      price: 1000,
      discount: 0,
      quizzes: [],
    ),
  ];

  static final List<QuizModel> quizzes = [
    QuizModel(
      quizId: 'quizId',
      chapterId: 'chapterId',
      bookId: 'bookId',
      subjectId: 'subjectId',
      price: 500,
      discount: 0,
      title: '1 нұсқа',
      questions: [],
    ),
  ];
}
