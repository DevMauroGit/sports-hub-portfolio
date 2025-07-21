import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Instance of the FlutterLocalNotificationsPlugin to manage notifications
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initializes local notifications for both Android and iOS
  Future<void> initNotification() async {
    // Android-specific initialization settings, using the 'flutter' icon
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('flutter');

    // iOS-specific initialization settings, requesting permissions
    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combine Android and iOS settings into one initialization object
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin with the above settings and a callback
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // Handle what happens when the notification is tapped
      },
    );
  }

  /// Returns platform-specific notification details (sound, priority, etc.)
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',      // Channel ID for Android
        'channelName',    // Channel name for Android
        importance: Importance.max, // Max importance ensures heads-up notifications
      ),
      iOS: DarwinNotificationDetails(), // Basic iOS notification config
    );
  }

  /// Displays a local notification with optional payload
  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    return notificationsPlugin.show(
      id,               // Notification ID (used to update or cancel later)
      title,            // Title of the notification
      body,             // Body text of the notification
      await notificationDetails(), // Notification configuration
    );
  }
}
