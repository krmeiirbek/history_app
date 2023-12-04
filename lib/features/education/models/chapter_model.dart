import 'package:cloud_firestore/cloud_firestore.dart';

import 'quiz_model.dart';

class ChapterModel {
  final String chapterId;
  final String bookId;
  final String subjectId;
  final String image;
  final String title;
  final double price;
  final double discount; // 0-100
  String? subjectTitle;
  String? bookTitle;
  List<QuizModel> quizzes;

  ChapterModel({
    required this.chapterId,
    required this.bookId,
    required this.subjectId,
    required this.image,
    required this.title,
    required this.price,
    required this.discount,
    required this.quizzes,
    this.subjectTitle,
    this.bookTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'bookId': bookId,
      'subjectId': subjectId,
      'image': image,
      'title': title,
      'price': price,
      'discount': discount,
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(),
    };
  }

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      chapterId: json['chapterId'] as String? ?? '',
      bookId: json['bookId'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      image: json['image'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: json['price'] as double? ?? 0.0,
      discount: json['discount'] as double? ?? 0.0,
      quizzes: (json['quizzes'] as List<dynamic>?)
          ?.map((e) => QuizModel.fromJson(e))
          .toList() ?? [],
    );
  }

  factory ChapterModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return ChapterModel(
      chapterId: document.id,
      bookId: data['bookId'] ?? '',
      subjectId: data['subjectId'] ?? '',
      image: data['image'] ?? '',
      title: data['title'] ?? '',
      price: _ensureDouble(data['price']),
      discount: _ensureDouble(data['discount']),
      quizzes: (data['quizzes'] as List<dynamic>?)
          ?.map((e) => QuizModel.fromJson(e))
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

  static ChapterModel empty() {
    return ChapterModel(
      chapterId: '',
      bookId: '',
      subjectId: '',
      image: '',
      title: '',
      price: 0.0,
      discount: 0.0,
      quizzes: [],
    );
  }

  ChapterModel copyWith({
    String? chapterId,
    String? bookId,
    String? subjectId,
    String? image,
    String? title,
    double? price,
    double? discount,
    String? subjectTitle,
    String? bookTitle,
    List<QuizModel>? quizzes,
  }) {
    return ChapterModel(
      chapterId: chapterId ?? this.chapterId,
      bookId: bookId ?? this.bookId,
      subjectId: subjectId ?? this.subjectId,
      image: image ?? this.image,
      title: title ?? this.title,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      quizzes: quizzes ?? this.quizzes,
      subjectTitle: subjectTitle ?? this.subjectTitle,
      bookTitle: bookTitle ?? this.bookTitle,
    );
  }
}
