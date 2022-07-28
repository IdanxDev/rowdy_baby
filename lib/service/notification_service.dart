// ignore_for_file: use_build_context_synchronously

import 'package:dating/screen/home_screen/home_screen.dart';
import 'package:dating/widgets/app_logs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    logs('Background message Id : ${message.messageId}');
    logs('Background message Time : ${message.sentTime}');
  }

  //     ======================= Generate FCM Token =======================     //
  static Future<String?> generateFCMToken(BuildContext context) async {
    try {
      String? token = await firebaseMessaging.getToken();
      logs('Firebase FCM Token --> $token');
      return token;
    } on FirebaseException catch (e) {
      logs('Catch error in generateFCMToken --> ${e.message}');
      showMessage(context, message: e.message, isError: true);
      return null;
    }
  }

  static Future<void> initializeNotification(BuildContext context) async {
    await Firebase.initializeApp();
    await initializeLocalNotification();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    logs('FCM Token --> $fcmToken');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      if (remoteMessage.notification!.body == 'Tap to see') {
        // navigatorKey.currentState!.pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) => const HomeScreen(selectedIndex: 2),
        //   ),
        //   (route) => false,
        // );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(selectedIndex: 2),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(selectedIndex: 2),
          ),
          (route) => false,
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      if (remoteMessage.notification!.body == 'Tap to see') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(selectedIndex: 2),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(selectedIndex: 2),
          ),
          (route) => false,
        );
      }
    });

    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(announcement: true);

    logs(
        'Notification permission status : ${notificationSettings.authorizationStatus.name}');
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
        logs(
            'Message title: ${remoteMessage.notification!.title}, body: ${remoteMessage.notification!.body}');

        AndroidNotificationDetails androidNotificationDetails =
            const AndroidNotificationDetails(
          'CHANNEL ID',
          'CHANNEL NAME',
          channelDescription: 'CHANNEL DESCRIPTION',
          importance: Importance.max,
          priority: Priority.max,
        );
        IOSNotificationDetails iosNotificationDetails =
            const IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
        NotificationDetails notificationDetails = NotificationDetails(
            android: androidNotificationDetails, iOS: iosNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
          0,
          remoteMessage.notification!.title!,
          remoteMessage.notification!.body!,
          notificationDetails,
        );

        await flutterLocalNotificationsPlugin.initialize(
          initializeLocalNotification(),
          onSelectNotification: (String? payload) async {
            if (remoteMessage.notification!.body == 'Tap to see') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(selectedIndex: 2),
                ),
                (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(selectedIndex: 2),
                ),
                (route) => false,
              );
            }
          },
        );
      });
    }
  }

  static initializeLocalNotification() {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@drawable/app_icon');
    IOSInitializationSettings ios = const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    InitializationSettings platform =
        InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }
}
