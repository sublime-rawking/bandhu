class User {
  String email;
  String name;
  String phone;
  String image;
  String userid;
  int? askGiveCount;
  String dcp;

  User(
      {required this.email,
      required this.name,
      required this.userid,
      required this.image,
      this.dcp = "",
      this.askGiveCount = 0,
      required this.phone});

  User.fromMap(Map<String, dynamic> map)
      : email = map['email'].toString(),
        name = map['Name'].toString(),
        dcp = map['DCP'].toString(),
        askGiveCount = map["give_ask_count"] != null
            ? map["give_ask_count"].runtimeType == String
                ? int.parse(map["give_ask_count"])
                : map["give_ask_count"].toInt()
            : 0,
        phone = map['Mobile'].toString(),
        userid = map['user_id'].toString(),
        image = map['Profile'].toString();

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'Name': name,
      'Mobile': phone,
      'Profile': image,
    };
  }
}
