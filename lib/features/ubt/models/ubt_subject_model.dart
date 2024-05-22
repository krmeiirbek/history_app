import 'package:cloud_firestore/cloud_firestore.dart';

import 'ubt_quiz_model.dart';

class UBTSubjectModel {
  final String subjectId;
  final String title;
  final String image;
  List<UBTQuizModel> quizzes;

  UBTSubjectModel({
    required this.subjectId,
    required this.title,
    required this.image,
    required this.quizzes,
  });

  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'title': title,
      'image': image,
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(),
    };
  }

  factory UBTSubjectModel.fromJson(Map<String, dynamic> json) {
    return UBTSubjectModel(
      subjectId: json['subjectId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      quizzes: (json['quizzes'] as List<dynamic>?)?.map((e) => UBTQuizModel.fromJson(e)).toList() ?? [],
    );
  }

  factory UBTSubjectModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UBTSubjectModel(
        subjectId: document.id,
        title: data['title'] ?? '',
        image: data['image'] ?? '',
        quizzes: (data['quizzes'] as List<dynamic>?)?.map((e) => UBTQuizModel.fromJson(e)).toList() ?? [],
      );
    } else {
      return UBTSubjectModel(
        subjectId: '',
        title: '',
        image: '',
        quizzes: [],
      );
    }
  }

  static UBTSubjectModel empty() {
    return UBTSubjectModel(
      subjectId: '',
      title: '',
      image: '',
      quizzes: [],
    );
  }

  UBTSubjectModel copyWith({
    String? subjectId,
    String? title,
    String? image,
    List<UBTQuizModel>? quizzes,
  }) {
    return UBTSubjectModel(
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      image: image ?? this.image,
      quizzes: quizzes ?? this.quizzes,
    );
  }
}
