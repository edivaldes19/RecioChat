import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? email;
  String? name;
  String? lastname;
  String? phone;
  String? password;
  String? sessionToken;
  String? image;
  String? isAvailable;
  String? notificationToken;
  String? updatedAt;
  String? createdAt;
  User(
      {this.id,
      this.email,
      this.name,
      this.lastname,
      this.phone,
      this.password,
      this.sessionToken,
      this.image,
      this.isAvailable,
      this.notificationToken,
      this.updatedAt,
      this.createdAt});
  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      lastname: json["lastname"],
      phone: json["phone"],
      password: json["password"],
      sessionToken: json["session_token"],
      image: json["image"],
      isAvailable: json["is_available"],
      notificationToken: json["notification_token"],
      updatedAt: json["updated_at"],
      createdAt: json["created_at"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "lastname": lastname,
        "phone": phone,
        "password": password,
        "session_token": sessionToken,
        "image": image,
        "is_available": isAvailable,
        "notification_token": notificationToken,
        "updated_at": updatedAt,
        "created_at": createdAt,
      };
  static List<User> fromJsonList(List<dynamic> jsonList) {
    List<User> toList = [];
    for (var item in jsonList) {
      User user = User.fromJson(item);
      toList.add(user);
    }
    return toList;
  }
}
