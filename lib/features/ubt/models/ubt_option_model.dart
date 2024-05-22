import 'package:cloud_firestore/cloud_firestore.dart';

class UBTOptionModel {
  final String optionId;
  final String answer;
  final bool isCorrect;

  UBTOptionModel({
    required this.optionId,
    required this.answer,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      'optionId': optionId,
      'answer': answer,
      'isCorrect': isCorrect,
    };
  }

  Map<String, dynamic> toFirebase() {
    return {
      'answer': answer,
      'isCorrect': isCorrect,
    };
  }

  factory UBTOptionModel.fromJson(Map<String, dynamic> json) {
    return UBTOptionModel(
      optionId: json['optionId'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
    );
  }

  factory UBTOptionModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return UBTOptionModel(
      optionId: document.id,
      answer: data['answer'] as String? ?? '',
      isCorrect: data['isCorrect'] as bool? ?? false,
    );
  }

  static UBTOptionModel empty() {
    return UBTOptionModel(
      optionId: '',
      answer: '',
      isCorrect: false,
    );
  }

  UBTOptionModel copyWith({
    String? optionId,
    String? answer,
    bool? isCorrect,
  }) {
    return UBTOptionModel(
      optionId: optionId ?? this.optionId,
      answer: answer ?? this.answer,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
