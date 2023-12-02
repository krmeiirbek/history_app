import 'package:cloud_firestore/cloud_firestore.dart';

import 'chapter_model.dart';

class BookModel {
  final String bookId;
  final String subjectId;
  final String title;
  final String image;
  final double price;
  final double discount; // 0-100
  List<ChapterModel> chapters;

  BookModel({
    required this.bookId,
    required this.subjectId,
    required this.title,
    required this.image,
    required this.price,
    required this.discount,
    required this.chapters,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'subjectId': subjectId,
      'title': title,
      'image': image,
      'price': price,
      'discount': discount,
      'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
    };
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      bookId: json['bookId'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      price: json['price'] as double? ?? 0.0,
      discount: json['discount'] as double? ?? 0.0,
      chapters: (json['chapters'] as List<dynamic>?)
          ?.map((e) => ChapterModel.fromJson(e))
          .toList() ?? [],
    );
  }

  factory BookModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return BookModel(
      bookId: document.id,
      subjectId: data['subjectId'] ?? '',
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      price: data['price'] is String ? double.parse(data['price']) : (data['price'] as double?) ?? 0.0,
      discount: data['discount'] is String ? double.parse(data['discount']) : (data['discount'] as double?) ?? 0.0,
      chapters: (data['chapters'] as List<dynamic>?)
          ?.map((e) => ChapterModel.fromJson(e))
          .toList() ?? [],
    );
  }

  static BookModel empty() {
    return BookModel(
      bookId: '',
      subjectId: '',
      title: '',
      image: '',
      price: 0.0,
      discount: 0.0,
      chapters: [],
    );
  }

  BookModel copyWith({
    String? bookId,
    String? subjectId,
    String? title,
    String? image,
    double? price,
    double? discount,
    List<ChapterModel>? chapters,
  }) {
    return BookModel(
      bookId: bookId ?? this.bookId,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      chapters: chapters ?? this.chapters,
    );
  }
}
