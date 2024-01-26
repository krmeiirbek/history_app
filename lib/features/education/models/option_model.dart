import 'package:cloud_firestore/cloud_firestore.dart';

class OptionModel {
  final String optionId;
  final String answer;
  final bool isCorrect;

  OptionModel({
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

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      optionId: json['optionId'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
    );
  }

  factory OptionModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};
    return OptionModel(
      optionId: document.id,
      answer: data['answer'] as String? ?? '',
      isCorrect: data['isCorrect'] as bool? ?? false,
    );
  }

  static OptionModel empty() {
    return OptionModel(
      optionId: '',
      answer: '',
      isCorrect: false,
    );
  }

  OptionModel copyWith({
    String? optionId,
    String? answer,
    bool? isCorrect,
  }) {
    return OptionModel(
      optionId: optionId ?? this.optionId,
      answer: answer ?? this.answer,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
