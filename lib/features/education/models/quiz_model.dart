import 'package:cloud_firestore/cloud_firestore.dart';

import 'question_model.dart';

class QuizModel {
  final String quizId;
  final String chapterId;
  final String bookId;
  final String subjectId;
  final double price;
  final double discount; // 0-100
  final String title;
  final bool isBuy;
  String? subjectTitle;
  String? bookTitle;
  String? chapterTitle;
  final List<QuestionModel> questions;

  QuizModel({
    required this.quizId,
    required this.chapterId,
    required this.bookId,
    required this.subjectId,
    required this.price,
    required this.discount,
    required this.title,
    required this.isBuy,
    required this.questions,
    this.subjectTitle,
    this.bookTitle,
    this.chapterTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'chapterId': chapterId,
      'bookId': bookId,
      'subjectId': subjectId,
      'price': price,
      'discount': discount,
      'title': title,
      'isBuy': isBuy,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      quizId: json['quizId'] as String? ?? '',
      chapterId: json['chapterId'] as String? ?? '',
      bookId: json['bookId'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      price: json['price'] as double? ?? 0.0,
      discount: json['discount'] as double? ?? 0.0,
      title: json['title'] as String? ?? '',
      isBuy: json['isBuy'] as bool? ?? false,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => QuestionModel.fromJson(e))
          .toList() ?? [],
    );
  }

  factory QuizModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return QuizModel(
      quizId: document.id,
      chapterId: data['chapterId'] ?? '',
      bookId: data['bookId'] ?? '',
      subjectId: data['subjectId'] ?? '',
      price: _ensureDouble(data['price']),
      discount: _ensureDouble(data['discount']),
      title: data['title'] ?? '',
      isBuy: data['isBuy'] as bool? ?? false,
      questions: (data['questions'] as List<dynamic>?)
          ?.map((e) => QuestionModel.fromJson(e))
          .toList() ?? [],
    );
  }

  static double _ensureDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0.0;
    }
  }

  static QuizModel empty() {
    return QuizModel(
      quizId: '',
      chapterId: '',
      bookId: '',
      subjectId: '',
      price: 0.0,
      discount: 0.0,
      title: '',
      isBuy: false,
      questions: [],
    );
  }

  QuizModel copyWith({
    String? quizId,
    String? chapterId,
    String? bookId,
    String? subjectId,
    double? price,
    double? discount,
    String? title,
    bool? isBuy,
    String? subjectTitle,
    String? bookTitle,
    String? chapterTitle,
    List<QuestionModel>? questions,
  }) =>
      QuizModel(
        quizId: quizId ?? this.quizId,
        chapterId: chapterId ?? this.chapterId,
        bookId: bookId ?? this.bookId,
        subjectId: subjectId ?? this.subjectId,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        title: title ?? this.title,
        questions: questions ?? this.questions,
        isBuy: isBuy ?? this.isBuy,
        subjectTitle: subjectTitle ?? this.subjectTitle,
        bookTitle: bookTitle ?? this.bookTitle,
        chapterTitle: chapterTitle ?? this.chapterTitle,
      );
}
