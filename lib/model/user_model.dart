class User {
  String email;
  String name;
  String phone;
  String image;
  String userid;
  String? dcp;

  User(
      {required this.email,
      required this.name,
      required this.userid,
      required this.image,
      this.dcp = "",
      required this.phone});

  User.fromMap(Map<String, dynamic> map)
      : email = map['email'].toString(),
        name = map['Name'].toString(),
        dcp = map['DCP'].toString(),
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
