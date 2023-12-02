import 'package:cloud_firestore/cloud_firestore.dart';

import 'option_model.dart';

class QuestionModel {
  final String questionId;
  final String question;
  final String? image;
  final List<OptionModel> options;

  QuestionModel({
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

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionId: json['questionId'] as String? ?? '',
      question: json['question'] as String? ?? '',
      image: json['image'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => OptionModel.fromJson(e))
          .toList() ?? [],
    );
  }

  factory QuestionModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return QuestionModel(
      questionId: document.id,
      question: data['question'] ?? '',
      image: data['image'] as String?,
      options: (data['options'] as List<dynamic>?)
          ?.map((e) => OptionModel.fromJson(e))
          .toList() ?? [],
    );
  }

  static QuestionModel empty() {
    return QuestionModel(
      questionId: '',
      question: '',
      image: null,
      options: [],
    );
  }

  QuestionModel copyWith({
    String? questionId,
    String? question,
    String? image,
    List<OptionModel>? options,
  }) {
    return QuestionModel(
      questionId: questionId ?? this.questionId,
      question: question ?? this.question,
      image: image ?? this.image,
      options: options ?? this.options,
    );
  }
}
