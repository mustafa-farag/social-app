// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toMap());

class UserModel {
  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.bio,
    required this.cover,
  });

  String? uId;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? bio;
  String? cover;

  factory UserModel.fromJson(Map<String, dynamic>? json) => UserModel(
    uId: json?["uId"],
    name: json?["name"],
    email: json?["email"],
    phone: json?["phone"],
    image: json?["image"],
    bio: json?["bio"],
    cover: json?["cover"],
  );

  Map<String, dynamic> toMap() => {
    "uId": uId,
    "name": name,
    "email": email,
    "phone": phone,
    "image": image,
    "bio": bio,
    "cover": cover,
  };
}
