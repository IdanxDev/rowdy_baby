import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';

class AdminService {
  static CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('admin');

  static Stream<QuerySnapshot<Object?>>? getAdminMessage(BuildContext context) {
    try {
      return adminCollection.orderBy('messageOn', descending: true).snapshots();
    } on FirebaseException catch (e) {
      logs('Catch error in getAdminMessage : ${e.message}');
      showMessage(context, message: e.message, isError: true);
      return null;
    }
  }
}
