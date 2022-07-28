// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:convert';

import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class RestConstants {
  /// Define all endpoints and base url(s) here
  /// DO NOT USE STATIC STRING ANYWHERE IN 'rest_api' call.

  static const getCountryBaseUrl =
      'https://countriesnow.space/api/v0.1/countries';
  static const getCities = '/cities';
  static const baseUrl = 'https://test.cashfree.com/api/v2';
  static const cfTokenGen = 'cftoken/order';
  static const notificationRestCall = 'https://fcm.googleapis.com/fcm/send';
}

class RestServices {
  Map<String, String> headers = {
    'content-type': 'application/json',
    'x-client-id': '17680219264356bed32cd160c1208671',
    'x-client-secret': '478b474f36a4d305a4f057067a31cd72370a9158'
  };

  static void showRequestLogs(Uri url, {Map<String, String>? headers}) {
    logs('<----------------- Requested server data Logs ----------------->');
    logs('Requested url --> $url');
    logs('Header --> $headers');
    logs('<----------------- Requested server data Logs ----------------->');
  }

  static void showResponseLogs({@required Response? response}) {
    logs('<----------------- Requested server data Logs ----------------->');
    logs('Response --> ${response!.statusCode} : ${response.request!.url}');
    logs('RHeader --> ${response.request!.headers}');
    logs('Response body --> ${response.body}');
    logs('<----------------- Requested server data Logs ----------------->');
  }

  static dynamic getCountryRestCall(BuildContext context) async {
    String? responseData;
    try {
      Uri? requestedUri = Uri.tryParse(RestConstants.getCountryBaseUrl);
      showRequestLogs(requestedUri!);

      Response response = await http.get(requestedUri);

      if (response != null) {
        showResponseLogs(response: response);
      }

      switch (response.statusCode) {
        case 200:
        case 201:
          responseData = response.body;
          break;
        case 500:
        case 400:
        case 404:
          logs('${response.statusCode}');
          showMessage(
            context,
            message: '${response.statusCode} : Something went wrong.',
            isError: true,
          );
          break;
        case 401:
          showMessage(
            context,
            message: '${response.statusCode} : Something went wrong with authorization.',
            isError: true,
          );
          logs('401 : ${response.body}');
          break;
        default:
          logs('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in Get country --> ${e.message}');
      showMessage(
        context,
        message: e.message,
        isError: true,
      );
    }
    return responseData;
  }

  static dynamic getCityRestCall(BuildContext context,
      {@required String? countryName}) async {
    String? responseData;
    try {
      String getUrl = '${RestConstants.getCountryBaseUrl}${RestConstants.getCities}/q?country=$countryName';
      Uri? requestedUri = Uri.tryParse(getUrl);
      showRequestLogs(requestedUri!);

      Response response = await http.get(requestedUri);

      if (response != null) {
        showResponseLogs(response: response);
      }

      switch (response.statusCode) {
        case 200:
        case 201:
          responseData = response.body;
          break;
        case 400:
        case 404:
          logs('${response.statusCode}');
          showMessage(
            context,
            message: '${response.statusCode} : Something went wrong.',
            isError: true,
          );
          break;
        case 401:
          showMessage(
            context,
            message: '${response.statusCode} : Something went wrong with authorization.',
            isError: true,
          );
          logs('401 : ${response.body}');
          break;
        default:
          logs('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in Get city --> ${e.message}');
      showMessage(
        context,
        message: e.message,
        isError: true,
      );
    }
    return responseData;
  }

  dynamic postRestCall(BuildContext context,
      {@required String? endpoint,
      @required Map<String, dynamic>? body,
      String? addOns}) async {
    logs('Body --> $body');
    String? responseData;
    try {
      String requestUrl = addOns != null
          ? '${RestConstants.baseUrl}/$endpoint/$addOns'
          : '${RestConstants.baseUrl}/$endpoint';
      Uri? requestedUri = Uri.tryParse(requestUrl);
      showRequestLogs(requestedUri!);

      Response response = await http.post(requestedUri,
          headers: headers, body: jsonEncode(body));

      if (response != null) {
        showResponseLogs(response: response);
      }

      switch (response.statusCode) {
        case 200:
        case 201:
          responseData = response.body;
          break;
        case 500:
        case 400:
        case 404:
          logs('${response.statusCode}');
          showMessage(
            context,
            message: '${response.statusCode} : Something went wrong.',
            isError: true,
          );
          break;
        case 401:
          showMessage(
            context,
            message: '${response.statusCode} : Something went wrong with authorization.',
            isError: true,
          );
          logs('401 : ${response.body}');
          break;
        default:
          logs('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in Post --> ${e.message}');
      showMessage(
        context,
        message: e.message,
        isError: true,
      );
    }
    return responseData;
  }

  static dynamic sendNotificationRestCall(BuildContext context,
      {@required String? message,
      @required String? title,
      @required String? token,
      bool isImage = false}) async {
    String? responseData;
    try {
      Map<String, dynamic> body = {
        'notification': {
          'body': isImage ? 'Attachment' : message,
          'title': title,
          'image': isImage ? message : null
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'open_val': 'B',
          'image': isImage ? message : ''
        },
        'registration_ids': [token]
      };
      logs('Body --> $body');
      Map<String, String>? headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAA4PP-QkY:APA91bG2a2-4T2FuYwGEGSn4EVmB6iG9oo8NF3JdV4cffv9fH5zzNbBksrSzVuGOqmga-1Wbd3X48Xv-ymvxLtrICBO7ldVxh9-xaJP1S0xbWimg963ZEjw6n0jOrv7BZC0aR5nAomWp'
      };
      String requestUrl = RestConstants.notificationRestCall;
      Uri? requestedUri = Uri.tryParse(requestUrl);
      showRequestLogs(requestedUri!);

      Response response = await http.post(requestedUri,
          body: jsonEncode(body), headers: headers);

      if (response != null) {
        showResponseLogs(response: response);
      }

      switch (response.statusCode) {
        case 200:
        case 201:
          responseData = response.body;
          break;
        case 500:
        case 400:
        case 404:
          logs('${response.statusCode}');
          showMessage(
            context,
            message: '${response.statusCode} : Something went wrong.',
            isError: true,
          );
          break;
        case 401:
          showMessage(
            context,
            message: '${response.statusCode} : Something went wrong with authorization.',
            isError: true,
          );
          logs('401 : ${response.body}');
          break;
        default:
          logs('${response.statusCode} : ${response.body}');
          break;
      }
    } on PlatformException catch (e) {
      logs('PlatformException in sendNotificationRestCall --> ${e.message}');
      showMessage(
        context,
        message: e.message,
        isError: true,
      );
    }
    return responseData;
  }
}
