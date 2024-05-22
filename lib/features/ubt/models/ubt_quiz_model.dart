import 'package:cloud_firestore/cloud_firestore.dart';

import 'ubt_question_model.dart';

class UBTQuizModel {
  final String subjectId;
  final String quizId;
  final String title;
  String? subjectTitle;
  final List<UBTQuestionModel> questions;

  UBTQuizModel({
    required this.subjectId,
    required this.quizId,
    required this.title,
    required this.questions,
    this.subjectTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'quizId': quizId,
      'title': title,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  Map<String, dynamic> toFirebase() {
    return {
      'title': title,
    };
  }

  factory UBTQuizModel.fromJson(Map<String, dynamic> json) {
    return UBTQuizModel(
      subjectId: json['subjectId'] as String? ?? '',
      quizId: json['quizId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      questions: (json['questions'] as List<dynamic>?)?.map((e) => UBTQuestionModel.fromJson(e)).toList() ?? [],
    );
  }

  factory UBTQuizModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return UBTQuizModel(
      subjectId: data['subjectId'] ?? '',
      quizId: document.id,
      title: data['title'] ?? '',
      questions: (data['questions'] as List<dynamic>?)?.map((e) => UBTQuestionModel.fromJson(e)).toList() ?? [],
    );
  }

  static UBTQuizModel empty() {
    return UBTQuizModel(
      subjectId: '',
      quizId: '',
      title: '',
      questions: [],
    );
  }

  UBTQuizModel copyWith({
    String? subjectId,
    String? quizId,
    String? title,
    String? subjectTitle,
    List<UBTQuestionModel>? questions,
  }) =>
      UBTQuizModel(
        subjectId: subjectId ?? this.subjectId,
        quizId: quizId ?? this.quizId,
        title: title ?? this.title,
        questions: questions ?? this.questions,
        subjectTitle: subjectTitle ?? this.subjectTitle,
      );
}
