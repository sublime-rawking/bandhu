class User {
  String email;
  String name;
  String phone;
  String image;
  String userid;
  int ask;
  int give;

  User(
      {required this.email,
      required this.name,
      required this.userid,
      required this.image,
      this.ask = 0,
      this.give = 0,
      required this.phone});

  User.fromMap(Map<String, dynamic> map)
      : email = map['email'].toString(),
        name = map['name'].toString(),
        phone = map['mobileNo'].toString(),
        ask = map['ask'] ?? 0,
        give = map['give'] ?? 0,
        userid = map['_id'].toString(),
        image = map['profileImage'].toString();

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'mobileNo': phone,
      'image': image,
    };
  }
}
