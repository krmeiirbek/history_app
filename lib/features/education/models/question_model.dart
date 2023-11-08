class QuestionModel {
  final int id, answer;
  final String question;
  final List<String> options;

  QuestionModel({
    required this.id,
    required this.answer,
    required this.question,
    required this.options,
  });
}

List question = [
  QuestionModel(
    id: 1,
    answer: 2,
    question: "Why are you late?",
    options: ['A', 'B', 'C', 'D'],
  ),
  QuestionModel(
    id: 2,
    answer: 1,
    question: "When was she there?",
    options: ['A', 'B', 'C', 'D'],
  ),
  QuestionModel(
    id: 3,
    answer: 3,
    question: "How can I help?",
    options: ['A', 'B', 'C', 'D'],
  ),
  QuestionModel(
    id: 4,
    answer: 3,
    question: "Where have we met before?",
    options: ['A', 'B', 'C', 'D'],
  ),
  QuestionModel(
    id: 5,
    answer: 2,
    question: "Why you late?",
    options: ['A', 'B', 'C', 'D'],
  ),
  QuestionModel(
    id: 6,
    answer: 1,
    question: "When was ?",
    options: ['A', 'B', 'C', 'D'],
  ),
  QuestionModel(
    id: 7,
    answer: 0,
    question: "How  help?",
    options: ['A', 'B', 'C', 'D'],
  ),
  QuestionModel(
    id: 8,
    answer: 3,
    question: "Where met before?",
    options: ['A', 'B', 'C', 'D'],
  ),
  QuestionModel(
    id: 9,
    answer: 0,
    question: "How can I help?",
    options: ['A', 'B', 'C', 'D'],
  ),
  QuestionModel(
    id: 10,
    answer: 3,
    question: "Where  before?",
    options: ['A', 'B', 'C', 'D'],
  ),
];
