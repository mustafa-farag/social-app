
import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toMap());

class PostModel {
  PostModel({
     this.uId,
     this.name,
     this.dateTime,
     this.image,
     this.postImage,
     this.text,
  });

  String? uId;
  String? name;
  String? dateTime;
  String? image;
  String? postImage;
  String? text;

  factory PostModel.fromJson(Map<String, dynamic>? json) => PostModel(
    uId: json?["uId"],
    name: json?["name"],
    dateTime: json?["dateTime"],
    image: json?["image"],
    postImage: json?["postImage"],
    text: json?["text"],
  );

  Map<String, dynamic> toMap() => {
    "uId": uId,
    "name": name,
    "dateTime": dateTime,
    "image": image,
    "postImage": postImage,
    "text": text,
  };
}
