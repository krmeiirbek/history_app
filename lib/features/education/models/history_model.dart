import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/helpers/helper_functions.dart';
import 'quiz_model.dart';


class HistoryModel {
  final String historyId;
  final String subjectTitle;
  final String bookTitle;
  final String chapterTitle;
  final String quizTitle;
  final DateTime passedDate;
  final int maxPoint;
  final int resultPoint;

  HistoryModel({
    required this.historyId,
    required this.subjectTitle,
    required this.bookTitle,
    required this.chapterTitle,
    required this.quizTitle,
    required this.passedDate,
    required this.maxPoint,
    required this.resultPoint,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(passedDate);

  Map<String, dynamic> toJson() {
    return {
      'historyId': historyId,
      'subjectTitle': subjectTitle,
      'bookTitle': bookTitle,
      'chapterTitle': chapterTitle,
      'quizTitle': quizTitle,
      'passedDate': passedDate.toIso8601String(),
      'maxPoint': maxPoint,
      'resultPoint': resultPoint,
    };
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      historyId: json['historyId'] as String? ?? '',
      subjectTitle: json['subjectTitle'] as String? ?? '',
      bookTitle: json['bookTitle'] as String? ?? '',
      chapterTitle: json['chapterTitle'] as String? ?? '',
      quizTitle: json['quizTitle'] as String? ?? '',
      passedDate: DateTime.parse(json['passedDate'] as String? ?? DateTime.now().toIso8601String()),
      maxPoint: json['maxPoint'] as int? ?? 0,
      resultPoint: json['resultPoint'] as int? ?? 0,
    );
  }

  factory HistoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return HistoryModel(
      historyId: document.id,
      subjectTitle: data['subjectTitle'] as String? ?? '',
      bookTitle: data['bookTitle'] as String? ?? '',
      chapterTitle: data['chapterTitle'] as String? ?? '',
      quizTitle: data['quizTitle'] as String? ?? '',
      passedDate: DateTime.parse(data['passedDate'] as String? ?? DateTime.now().toIso8601String()),
      maxPoint: data['maxPoint'] as int? ?? 0,
      resultPoint: data['resultPoint'] as int? ?? 0,
    );
  }

  static HistoryModel empty() {
    return HistoryModel(
      historyId: '',
      subjectTitle: '',
      bookTitle: '',
      chapterTitle: '',
      quizTitle: '',
      passedDate: DateTime.now(),
      maxPoint: 0,
      resultPoint: 0,
    );
  }

  HistoryModel copyWith({
    String? historyId,
    String? subjectTitle,
    String? bookTitle,
    String? chapterTitle,
    String? quizTitle,
    DateTime? passedDate,
    int? maxPoint,
    int? resultPoint,
    QuizModel? quiz,
  }) {
    return HistoryModel(
      historyId: historyId ?? this.historyId,
      subjectTitle: subjectTitle ?? this.subjectTitle,
      bookTitle: bookTitle ?? this.bookTitle,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      quizTitle: quizTitle ?? this.quizTitle,
      passedDate: passedDate ?? this.passedDate,
      maxPoint: maxPoint ?? this.maxPoint,
      resultPoint: resultPoint ?? this.resultPoint,
    );
  }
}
