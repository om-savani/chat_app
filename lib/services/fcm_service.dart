import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FCMService {
  FCMService._();
  static FCMService instance = FCMService._();

  Future<String?> getAccessToken() async {
    try {
      String jsonString = await rootBundle.loadString('assets/json/fcm.json');
      var jsonDecoded = jsonDecode(jsonString);
      jsonDecoded['private_key'] =
          (jsonDecoded['private_key'] as String).replaceAll(r'\n', '\n');
      var accountCredential =
          ServiceAccountCredentials.fromJson(jsonEncode(jsonDecoded));

      List<String> scopes = [
        "https://www.googleapis.com/auth/firebase.messaging"
      ];

      var accessToken =
          await clientViaServiceAccount(accountCredential, scopes);
      return accessToken.credentials.accessToken.data;
    } catch (e, stacktrace) {
      log("⚠️ Error in getAccessToken: $e");
      log("🔍 StackTrace: $stacktrace");
      return null;
    }
  }

  /// Send FCM Notification
  Future<void> sendFCM({
    required String title,
    required String body,
    required String token,
  }) async {
    try {
      String? accessToken = await getAccessToken();
      if (accessToken == null) {
        log("❌ Failed to get access token.");
        return;
      }

      String apiUrl =
          "https://fcm.googleapis.com/v1/projects/chat-app-ed4b3/messages:send";

      Map<String, dynamic> apiBody = {
        'message': {
          'token': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'age': '22',
            'school': 'PQR',
          }
        },
      };

      http.Response res = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(apiBody),
      );

      if (res.statusCode == 200) {
        log('✅ Notification sent successfully: ${res.body}');
      } else {
        log('❌ Failed to send notification. Status Code: ${res.statusCode}');
        log('Response: ${res.body}');
      }
    } catch (e, stacktrace) {
      log("⚠️ Error in sendFCM: $e");
      log("🔍 StackTrace: $stacktrace");
    }
  }
}
