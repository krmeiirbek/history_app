import 'package:cloud_firestore/cloud_firestore.dart';

import 'book_model.dart';

class SubjectModel {
  final String subjectId;
  final String title;
  final String image;
  final double price;
  final double discount; // 0-100
  List<BookModel> books;

  SubjectModel({
    required this.subjectId,
    required this.title,
    required this.image,
    required this.price,
    required this.discount,
    required this.books,
  });

  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'title': title,
      'image': image,
      'price': price,
      'discount': discount,
      'books': books.map((book) => book.toJson()).toList(),
    };
  }

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['subjectId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      price: json['price'] as double? ?? 0.0,
      discount: json['discount'] as double? ?? 0.0,
      books: (json['books'] as List<dynamic>?)
              ?.map((e) => BookModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  factory SubjectModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return SubjectModel(
        subjectId: document.id,
        title: data['title'] ?? '',
        image: data['image'] ?? '',
        price: _ensureDouble(data['price']),
        discount: _ensureDouble(data['discount']),
        books: (data['books'] as List<dynamic>?)
            ?.map((e) => BookModel.fromJson(e))
            .toList() ?? [],
      );
    } else {
      return SubjectModel(
        subjectId: '',
        title: '',
        image: '',
        price: 0.0,
        discount: 0.0,
        books: [],
      );
    }
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

  static SubjectModel empty() {
    return SubjectModel(
      subjectId: '',
      title: '',
      image: '',
      price: 0.0,
      discount: 0.0,
      books: [],
    );
  }

  SubjectModel copyWith({
    String? subjectId,
    String? title,
    String? image,
    double? price,
    double? discount,
    List<BookModel>? books,
    DateTime? lastUpdated,
  }) {
    return SubjectModel(
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      books: books ?? this.books,
    );
  }
}
