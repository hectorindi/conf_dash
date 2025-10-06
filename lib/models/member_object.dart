class MemberObject {
  String name = '';
  String accessToken = '';
  String? uid = '';
  String? email = '';
  String? address = '';
  String? createdAt = '';
  DateTime? memberSince;
  String? specialization = '';
  String? phoneNumber = '';
  String? lastID = '';
  bool isAdmin = false;

  MemberObject(
      {required this.uid,
      required this.name,
      required this.accessToken,
      required this.isAdmin,
      this.specialization,
      this.address,
      this.email,
      this.createdAt,
      this.phoneNumber});

  // You can also add methods to your custom object
  MemberObject.fromJson(Map<String, dynamic> json) {
    uid = json['id'];
    accessToken = json['accessToken'];
    name = json['username'];
    //address = json['address'];
    email = json['email'];
    //createdAt = json['createdAt'];
    //specialization = json['specialization'];
    isAdmin = json['roles'][0] != 'ROLE_USER' ? true : false;
    //phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['address'] = address;
    data['email'] = email;
    data['createdAt'] = createdAt.toString();
    data['specialization'] = specialization;
    data['isAdmin'] = isAdmin;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
