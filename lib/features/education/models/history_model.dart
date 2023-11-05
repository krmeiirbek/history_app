import '../../../utils/helpers/helper_functions.dart';
import 'quiz_item_model.dart';

class HistoryModel {
  final String id;
  final DateTime orderDate;
  final int maxPoint;
  final int resultPoint;
  final QuizItemModel item;

  HistoryModel({
    required this.id,
    required this.item,
    required this.orderDate,
    required this.maxPoint,
    required this.resultPoint,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);
}
