
import 'dart:convert';

MassageModel postModelFromJson(String str) => MassageModel.fromJson(json.decode(str));

String postModelToJson(MassageModel data) => json.encode(data.toMap());

class MassageModel {
  MassageModel({
    this.dateTime,
    this.senderId,
    this.receiverId,
    this.text,
  });

  String? dateTime;
  String? senderId;
  String? receiverId;
  String? text;

  factory MassageModel.fromJson(Map<String, dynamic>? json) => MassageModel(
    dateTime: json?["dateTime"],
    senderId: json?["senderId"],
    receiverId: json?["receiverId"],
    text: json?["text"],
  );

  Map<String, dynamic> toMap() => {
    "dateTime": dateTime,
    "senderId": senderId,
    "receiverId": receiverId,
    "text": text,
  };
}
