// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/model/chat_model.dart';
import 'package:dating/service/rest_service.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';

class ChatService {
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('conversation');

  Stream<QuerySnapshot<Object?>>? getMessagedUsers(BuildContext context) {
    try {
      return chatCollection
          .orderBy('last_message_on', descending: true)
          .snapshots();
    } on FirebaseException catch (e) {
      logs('Catch error in getMessagedUsers : ${e.message}');
      showMessage(context, message: e.message, isError: true);
      return null;
    }
  }

  Future<void> sendMessage(BuildContext context,
      {@required String? chatRoomId, @required ChatModel? chatModel, @required String? token}) async {
    try {
      await chatCollection
          .doc(chatRoomId)
          .collection('Chats')
          .add(chatModel!.toJson());
      await chatCollection
          .doc(chatRoomId)
          .set({'last_message_on': DateTime.now().microsecondsSinceEpoch});
      await RestServices.sendNotificationRestCall(
        context,
        message: chatModel.message,
        title: 'New message from ${chatModel.senderName}',
        token: token,
      );
    } on FirebaseException catch (e) {
      logs('Catch error in Add Conversation Message : ${e.message}');
      showMessage(context, message: e.message, isError: true);
    }
  }

  Future<void> sendImage(BuildContext context,
      {@required String? chatRoomId,
      @required String? token,
      @required String? fileName,
      @required ChatModel? chatModel}) async {
    try {
      await chatCollection
          .doc(chatRoomId)
          .collection('Chats')
          .doc(fileName)
          .set(chatModel!.toJson());
      await chatCollection
          .doc(chatRoomId)
          .set({'last_message_on': DateTime.now().microsecondsSinceEpoch});
      await RestServices.sendNotificationRestCall(
        context,
        message: chatModel.message,
        title: 'New message from ${chatModel.senderName}',
        token: token,
        isImage: true,
      );
    } on FirebaseException catch (e) {
      logs('Catch error in Add Conversation Message : ${e.message}');
      showMessage(context, message: e.message, isError: true);
    }
  }

  Future<void> updateImage(BuildContext context,
      {@required String? chatRoomId,
      @required String? fileName,
      @required ChatModel? chatModel}) async {
    try {
      await chatCollection
          .doc(chatRoomId)
          .collection('Chats')
          .doc(fileName)
          .update(chatModel!.toJson());
      await chatCollection
          .doc(chatRoomId)
          .set({'last_message_on': DateTime.now().microsecondsSinceEpoch});
    } on FirebaseException catch (e) {
      logs('Catch error in Add Conversation Message : ${e.message}');
      showMessage(context, message: e.message, isError: true);
    }
  }

  Stream<QuerySnapshot<Object?>>? getConversationMessage(BuildContext context,
      {@required String? chatRoomId}) {
    try {
      Stream<QuerySnapshot> querySnapshot = chatCollection
          .doc(chatRoomId)
          .collection('Chats')
          .orderBy('messageTime', descending: true)
          .snapshots();
      return querySnapshot;
    } on FirebaseException catch (e) {
      logs('Catch error in Get Conversation Message : ${e.message}');
      showMessage(context, message: e.message, isError: true);
      return null;
    }
  }

  Future<void> clearChat(BuildContext context,
      {@required String? groupId}) async {
    try {
      final instance = FirebaseFirestore.instance;
      final batch = instance.batch();
      CollectionReference<Map<String, dynamic>> collection =
          instance.collection('conversation').doc(groupId).collection('Chats');
      QuerySnapshot<Map<String, dynamic>> snapshots = await collection.get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      chatCollection.doc(groupId).delete();
    } on FirebaseException catch (e) {
      logs('Catch error in clearChat : ${e.message}');
      showMessage(context, message: e.message, isError: true);
    }
  }

  Future<void> readMessage(
      String documentId, String receiverId, String groupId) async {
    chatCollection
        .doc(groupId)
        .collection('Chats')
        .where('receiverId', isEqualTo: receiverId)
        .snapshots()
        .listen((event) async {
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection("conversation")
          .doc(groupId)
          .collection("Chats")
          .doc(documentId);
      documentReference.update({'isRead': true});
    });
  }

  Stream<QuerySnapshot<Object?>>? getMessageStatus(BuildContext context,
      {@required String? chatRoomId, @required String? id}) {
    try {
      Stream<QuerySnapshot> querySnapshot = chatCollection
          .doc(chatRoomId)
          .collection("Chats")
          .where('groupId', isEqualTo: chatRoomId)
          .where('senderId', isEqualTo: id)
          .where('isRead', isEqualTo: false)
          .snapshots();
      return querySnapshot;
    } on FirebaseException catch (e) {
      logs('Catch error in Get Message Status : ${e.message}');
      showMessage(context, message: e.message, isError: true);
      return null;
    }
  }

  static Future<void> removeChat(BuildContext context,
      {@required String? userId}) async {
    try {
      final instance = FirebaseFirestore.instance;
      final batch = instance.batch();
      CollectionReference<Map<String, dynamic>> collection =
          instance.collection('conversation');
      QuerySnapshot<Map<String, dynamic>> snapshots = await collection.get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshots.docs) {
        if (doc.reference.id.contains(userId!)) {
          batch.delete(doc.reference);
        }
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      logs('Catch error in clearChat : ${e.message}');
      showMessage(context, message: e.message, isError: true);
    }
  }
}
