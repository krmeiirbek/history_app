import '../models/history_model.dart';
import '../models/quiz_model.dart';

class TDummyData {
  /// -- history
  static final List<HistoryModel> histories = [
    HistoryModel(
      historyId: '',
      passedDate: DateTime(2023, 09, 1),
      maxPoint: 35,
      resultPoint: 18,
      quiz: QuizModel(
        subjectId: 'worldHistory',
        chapterId: 'chapterId',
        price: 500,
        title: 'Ottoman Empires',
        quizId: '',
        bookId: '',
        discount: 0,
        isBuy: false,
        questions: [],
      ),
    ),
  ];

}
