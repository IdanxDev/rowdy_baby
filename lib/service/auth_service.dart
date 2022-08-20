// ignore_for_file: use_build_context_synchronously

import 'package:dating/model/user_model.dart';
import 'package:dating/service/user_service.dart';
import 'package:dating/utils/shared_preference.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserModel userModel = UserModel();

  //     ======================= Forgot Password =======================     //
  forgotPassword(BuildContext context, [String? email]) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email!);
      showMessage(context, message: 'Please check your $email account.!');
    } on FirebaseException catch (e) {
      logs('Catch error in Forgot Password --> ${e.message}');
      showMessage(context,
          message: e.message!.split('. ')[0].trim(), isError: true);
    }
  }

  //     ======================= SignOut =======================     //
  Future<void> userSignOut(BuildContext context) async {
    await setPrefBoolValue(isLoggedIn, false);
    await setPrefBoolValue(isProfileCompleted, false);
    await setPrefBoolValue(isPDCompleted, false);
    await setPrefStringValue(savedProfileData, '');
    String userId = FirebaseAuth.instance.currentUser!.uid;
    logs('User id --> $userId');
    await UserService().updateProfile(
      context,
      currentUserId: userId,
      key: 'userStatus',
      value: false,
    );
    await UserService().updateProfile(
      context,
      currentUserId: userId,
      key: 'lastOnline',
      value: DateTime.now().toIso8601String(),
    );
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }

  //     ======================= Google Sign In =======================     //
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final credentials = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential authResult =
            await firebaseAuth.signInWithCredential(credentials);
        logs('Google --> ${authResult.user}');
        return authResult;
      }
      return null;
    } on FirebaseException catch (e) {
      logs('Catch error in Verify User : ${e.message}');
      showMessage(context, message: e.message, isError: true);
      return null;
    }
  }

  //     ======================= Facebook Sign In =======================     //
  Future<UserCredential?> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);
      logs('Result --> ${result.status}');
      switch (result.status) {
        case LoginStatus.success:
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          UserCredential authResult = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);
          return authResult;
        case LoginStatus.cancelled:
          return null;
        case LoginStatus.failed:
          return null;
        default:
          return null;
      }
    } on FirebaseException catch (e) {
      logs('Catch error in Verify User : ${e.message}');
      showMessage(context, message: e.message, isError: true);
      return null;
    }
  }
}
