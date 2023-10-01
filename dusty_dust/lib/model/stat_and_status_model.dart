import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/model/status_model.dart';

class StatAndStatusModel {
  final ItemCode itemCode;
  final StatModel stat;
  final StatusModel status;

  StatAndStatusModel(
      {required this.itemCode, required this.stat, required this.status});

  @override
  String toString() {
    return 'StatAndStatusModel(ItemCode: $itemCode, StatModel: $stat, StatusModel: $status)';
  }
}
