import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  LocalNotificationService._();
  static LocalNotificationService instance = LocalNotificationService._();

  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  Future<void> getPermissions() async {
    PermissionStatus permission = await Permission.notification.request();

    if (permission.isDenied) {
      getPermissions();
    }
  }

  Future<void> sendNotification() async {
    await getPermissions();
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iOS = const DarwinInitializationSettings();

    InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    plugin
        .initialize(
          settings,
        )
        .then(
          (value) => log("Notification initialization Done ..."),
        )
        .onError(
          (error, _) => log("Error : $error"),
        );
  }
}
