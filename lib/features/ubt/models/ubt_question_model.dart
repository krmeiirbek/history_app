import 'package:cloud_firestore/cloud_firestore.dart';

import 'ubt_option_model.dart';

class UBTQuestionModel {
  final String questionId;
  final String question;
  final String? image;
  final List<UBTOptionModel> options;

  UBTQuestionModel({
    required this.questionId,
    required this.question,
    this.image,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'question': question,
      'image': image,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }

  Map<String, dynamic> toFirebase() {
    return {
      'question': question,
    };
  }

  factory UBTQuestionModel.fromJson(Map<String, dynamic> json) {
    return UBTQuestionModel(
      questionId: json['questionId'] as String? ?? '',
      question: json['question'] as String? ?? '',
      image: json['image'] as String?,
      options: (json['options'] as List<dynamic>?)?.map((e) => UBTOptionModel.fromJson(e)).toList() ?? [],
    );
  }

  factory UBTQuestionModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return UBTQuestionModel(
      questionId: document.id,
      question: data['question'] ?? '',
      image: data['image'] as String?,
      options: (data['options'] as List<dynamic>?)?.map((e) => UBTOptionModel.fromJson(e)).toList() ?? [],
    );
  }

  static UBTQuestionModel empty() {
    return UBTQuestionModel(
      questionId: '',
      question: '',
      image: null,
      options: [],
    );
  }

  UBTQuestionModel copyWith({
    String? questionId,
    String? question,
    String? image,
    List<UBTOptionModel>? options,
  }) {
    return UBTQuestionModel(
      questionId: questionId ?? this.questionId,
      question: question ?? this.question,
      image: image ?? this.image,
      options: options ?? this.options,
    );
  }
}
