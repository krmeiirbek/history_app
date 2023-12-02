import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/helpers/helper_functions.dart';
import 'quiz_model.dart';


class HistoryModel {
  final String historyId;
  final DateTime passedDate;
  final int maxPoint;
  final int resultPoint;
  final QuizModel quiz;

  HistoryModel({
    required this.historyId,
    required this.quiz,
    required this.passedDate,
    required this.maxPoint,
    required this.resultPoint,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(passedDate);

  Map<String, dynamic> toJson() {
    return {
      'historyId': historyId,
      'passedDate': passedDate.toIso8601String(),
      'maxPoint': maxPoint,
      'resultPoint': resultPoint,
      'quiz': quiz.toJson(),
    };
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      historyId: json['historyId'] as String? ?? '',
      passedDate: DateTime.parse(json['passedDate'] as String? ?? DateTime.now().toIso8601String()),
      maxPoint: json['maxPoint'] as int? ?? 0,
      resultPoint: json['resultPoint'] as int? ?? 0,
      quiz: QuizModel.fromJson(json['quiz'] as Map<String, dynamic>? ?? {}),
    );
  }

  factory HistoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return HistoryModel(
      historyId: document.id,
      passedDate: DateTime.parse(data['passedDate'] as String? ?? DateTime.now().toIso8601String()),
      maxPoint: data['maxPoint'] as int? ?? 0,
      resultPoint: data['resultPoint'] as int? ?? 0,
      quiz: QuizModel.fromJson(data['quiz'] as Map<String, dynamic>? ?? {}),
    );
  }

  static HistoryModel empty() {
    return HistoryModel(
      historyId: '',
      passedDate: DateTime.now(),
      maxPoint: 0,
      resultPoint: 0,
      quiz: QuizModel.empty(),
    );
  }

  HistoryModel copyWith({
    String? historyId,
    DateTime? passedDate,
    int? maxPoint,
    int? resultPoint,
    QuizModel? quiz,
  }) {
    return HistoryModel(
      historyId: historyId ?? this.historyId,
      passedDate: passedDate ?? this.passedDate,
      maxPoint: maxPoint ?? this.maxPoint,
      resultPoint: resultPoint ?? this.resultPoint,
      quiz: quiz ?? this.quiz,
    );
  }
}
