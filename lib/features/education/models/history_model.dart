import '../../../utils/helpers/helper_functions.dart';
import 'quiz_model.dart';


class HistoryModel {
  final String historyId;
  final DateTime orderDate;
  final int maxPoint;
  final int resultPoint;
  final QuizModel item;

  HistoryModel({
    required this.historyId,
    required this.item,
    required this.orderDate,
    required this.maxPoint,
    required this.resultPoint,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);
}
