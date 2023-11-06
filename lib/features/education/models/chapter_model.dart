class ChapterModel {
  final String image;
  final String id;
  final String title;

  ChapterModel({
    required this.id,
    required this.image,
    required this.title,
  });
}

List chapterModel = [
  ChapterModel(
      id: '1',
      image: 'assets/images/animations/sammy-line-come-back-later.png',
      title: 'title'),
  ChapterModel(
      id: '2',
      image: 'assets/images/animations/sammy-line-come-back-later.png',
      title: 'title'),
  ChapterModel(
      id: '3',
      image: 'assets/images/animations/sammy-line-come-back-later.png',
      title: 'title'),
];
