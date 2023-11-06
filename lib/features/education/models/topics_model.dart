class TopicsModel {
  final String title;
  final String id;

  TopicsModel({required this.id, required this.title});
}

List topicsModel1 = [
  TopicsModel(id: '1', title: 'title'),
  TopicsModel(id: '2', title: 'text'),
  TopicsModel(id: '3', title: 'test'),
  TopicsModel(id: '4', title: 'var'),
  TopicsModel(id: '5', title: 'final'),
];

List topicsModel2 = [
  TopicsModel(id: '1', title: 'var'),
  TopicsModel(id: '2', title: 'text'),
  TopicsModel(id: '3', title: 'title'),
  TopicsModel(id: '4', title: 'var'),
  TopicsModel(id: '5', title: 'final'),
  TopicsModel(id: '6', title: 'final'),
];

List topicsModel3 = [
  TopicsModel(id: '1', title: 'text'),
  TopicsModel(id: '2', title: 'text'),
];
