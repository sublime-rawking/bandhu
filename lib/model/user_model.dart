class User {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? profileImage;
  String? dcp;
  int? giveAsk;
  String? token;

  User(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.profileImage,
      this.dcp,
      this.giveAsk,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    profileImage = json['profile_image'];
    dcp = json['dcp'];
    giveAsk = json['give_ask'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['profile_image'] = this.profileImage;
    data['dcp'] = this.dcp;
    data['give_ask'] = this.giveAsk;
    data['token'] = this.token;
    return data;
  }
}
