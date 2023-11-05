class QuizItemModel {
  String subjectId;
  String chapterId;
  String titleId;
  double? price;
  String? image;
  String? subjectName;
  String? chapterName;
  String? title;

  QuizItemModel({
    required this.subjectId,
    required this.chapterId,
    required this.titleId,
    this.image,
    this.price,
    this.subjectName,
    this.chapterName,
    this.title,
  });

  static QuizItemModel empty() => QuizItemModel(subjectId: '', chapterId: '', titleId: '');
}