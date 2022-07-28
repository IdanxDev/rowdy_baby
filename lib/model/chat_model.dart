// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

List<ChatModel> chatModelFromJson(String str) =>
    List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String chatModelToJson(List<ChatModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
  ChatModel({
    this.message,
    this.senderName,
    this.receiverName,
    this.messageType,
    this.messageTime,
    this.groupId,
    this.receiverId,
    this.senderId,
    this.isRead = false,
  });

  String? message;
  String? senderName;
  String? receiverName;
  String? messageType;
  DateTime? messageTime;
  String? groupId;
  String? receiverId;
  String? senderId;
  bool isRead;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        message: json["message"],
        senderName: json["senderName"],
        receiverName: json["receiverName"],
        messageType: json["messageType"],
        messageTime: DateTime.parse(json["messageTime"]),
        groupId: json["groupId"],
        receiverId: json["receiverId"],
        senderId: json["senderId"],
        isRead: json["isRead"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "senderName": senderName,
        "receiverName": receiverName,
        "messageType": messageType,
        "messageTime": messageTime!.toIso8601String(),
        "groupId": groupId,
        "receiverId": receiverId,
        "senderId": senderId,
        "isRead": isRead,
      };
}
