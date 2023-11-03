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
        give = map["given"].toString(),
        remark = map["remark"].toString(),
        date = DateTime.parse(map["date"]),
        id = int.parse(map["give_ask_id"]);
}
