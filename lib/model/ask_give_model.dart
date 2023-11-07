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

// List<String> dateFormats = [
//   "yyyy-MM-dd",
//   "MM/dd/yyyy",
// ];

// DateTime? parseDate(String dateString, List<String> dateFormats) {
//   for (String format in dateFormats) {
//     try {
//       return DateFormat(format).parseStrict(dateString);
//     } catch (e) {
//       // Ignore and try the next format
//     }
//   }
//   return null;
// }
