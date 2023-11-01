import 'package:intl/intl.dart';

class AskGiveModel {
  String ask;
  String give;
  String remark;
  DateTime date;
  int id;

  AskGiveModel(
      {required this.ask,
      required this.give,
      required this.remark,
      required this.date,
      required this.id});

  AskGiveModel.fromMap(Map<String, dynamic> map)
      : ask = map["ask"].toString(),
        give = map["give"].toString(),
        remark = map["remark"].toString(),
        date = DateFormat('M/d/yyyy').parse(map["date"]),
        id = map["id"].toInt();
}
