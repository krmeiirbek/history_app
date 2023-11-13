import 'package:history_app/features/education/models/book_model.dart';
import 'package:history_app/features/education/models/chapter_model.dart';
import 'package:history_app/features/education/models/option_model.dart';
import 'package:history_app/features/education/models/question_model.dart';

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
        isBuy: false,
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
      isBuy: true,
      questions: questions,
    ),
    QuizModel(
      quizId: 'quizId',
      chapterId: 'chapterId',
      bookId: 'bookId',
      subjectId: 'subjectId',
      price: 500,
      discount: 0,
      title: '2 нұсқа',
      isBuy: false,
      questions: questions,
    ),
  ];

  static final List<QuestionModel> questions = [
    QuestionModel(
      questionId: '1',
      question:
          'Which city is known as the "City of Apples" and is a major cultural and economic center in Kazakhstan?',
      image: 'assets/images/buttons/img.png',
      options: [
        OptionModel(
          optionId: 'A',
          answer: 'Almaty',
          isCorrect: true,
        ),
        OptionModel(
          optionId: 'B',
          answer: 'Astana',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'C',
          answer: 'Karaganda',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'D',
          answer: 'Shymkent',
          isCorrect: false,
        ),
      ],
    ),
    QuestionModel(
      questionId: '2',
      question: 'Who was the first president of the United States?',
      options: [
        OptionModel(
          optionId: 'A',
          answer: 'Thomas Jefferson',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'B',
          answer: 'Benjamin Franklin',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'C',
          answer: 'John Adams',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'D',
          answer: 'George Washington',
          isCorrect: true,
        ),
      ],
    ),
    QuestionModel(
      questionId: '3',
      question: 'When did the American Civil War end?',
      options: [
        OptionModel(
          optionId: 'A',
          answer: 'July 4, 1776',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'B',
          answer: 'November 11, 1918',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'C',
          answer: 'April 9, 1865',
          isCorrect: true,
        ),
        OptionModel(
          optionId: 'D',
          answer: 'December 7, 1941',
          isCorrect: false,
        ),
      ],
    ),
    QuestionModel(
      questionId: '4',
      question: 'What is the chemical symbol for gold?',
      options: [
        OptionModel(
          optionId: 'A',
          answer: 'Ag',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'B',
          answer: 'Pt',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'C',
          answer: 'Hg',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'D',
          answer: 'Au',
          isCorrect: true,
        ),
      ],
    ),
    QuestionModel(
      questionId: '5',
      question: 'Who developed the theory of relativity?',
      options: [
        OptionModel(
          optionId: 'A',
          answer: 'Isaac Newton',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'B',
          answer: 'Galileo Galilei',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'C',
          answer: 'Marie Curie',
          isCorrect: false,
        ),
        OptionModel(
          optionId: 'D',
          answer: 'Albert Einstein',
          isCorrect: true,
        ),
      ],
    ),
  ];
}
