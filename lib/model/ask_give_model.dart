class AskGiveModel {
  int? id;
  DateTime? date;
  String? given;
  String? ask;
  String? remark;
  int? status;
  int? memberId;

  AskGiveModel(
      {this.id,
        this.date,
        this.given,
        this.ask,
        this.remark,
        this.status,
        this.memberId});

  AskGiveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = (json['date']!= null && json['date']!.isNotEmpty) ? DateTime.parse(json['date']).toLocal() : null;
    given = json['given'];
    ask = json['ask'];
    remark = json['remark'];
    status = json['status'];
    memberId = json['member_id'];
  }


  static List<AskGiveModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => AskGiveModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['given'] = this.given;
    data['ask'] = this.ask;
    data['remark'] = this.remark;
    data['status'] = this.status;
    data['member_id'] = this.memberId;
    return data;
  }
}