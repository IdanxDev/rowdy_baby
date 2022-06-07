import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/model/user_model.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';

class UserService {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUser(BuildContext context, UserModel userModel) async {
    try {
      await userCollection.doc(userModel.userId).set(userModel.toJson());
    } on FirebaseException catch (e) {
      showMessage(context, message: e.message, isError: true);
    }
  }

  Future<UserModel?> getCurrentUser(BuildContext context,
      {@required String? userId}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await userCollection.doc(userId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userMap =
            documentSnapshot.data() as Map<String, dynamic>?;
        UserModel userData = UserModel.fromJson(userMap!);
        return userData;
      }
      return null;
    } on FirebaseException catch (e) {
      showMessage(message: e.message, context, isError: true);
      return null;
    }
  }
}
