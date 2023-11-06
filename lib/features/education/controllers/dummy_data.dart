import 'package:history_app/features/education/models/quiz_item_model.dart';
import 'package:history_app/features/education/models/history_model.dart';

import '../../../utils/constants/image_strings.dart';
import '../../personalization/models/user_model.dart';

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
      id: 'CWT0012',
      orderDate: DateTime(2023, 09, 1),
      maxPoint: 35,
      resultPoint: 18,
      item: QuizItemModel(
        subjectId: 'worldHistory',
        chapterId: 'chapterId',
        titleId: 'titleId',
        price: 500,
        subjectName: 'World History',
        chapterName: 'Middle west',
        title: 'Ottoman Empires'
      ),
    ),
    HistoryModel(
      id: 'CWT0025',
      item: QuizItemModel(
          subjectId: 'historyOfKazakh',
          chapterId: 'chapterId',
          titleId: 'titleId',
          price: 500,
          subjectName: 'History Of Kazakhstan',
          chapterName: 'Tas dauiri',
          title: 'Paleolit'
      ),
      orderDate: DateTime(2023, 10, 2),
      maxPoint: 40,
      resultPoint: 25,
    ),
  ];
}
