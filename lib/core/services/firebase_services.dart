import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../app_routing/route_names.dart';
import 'navigation_service.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    await _requestPermission();
    await setupFlutterNotifications();
    await _setupMessageHandlers();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String> getDeviceToken() async {
    if (Platform.isAndroid) {
      return await getFcmToken(); // Get FCM Token
    } else if (Platform.isIOS) {
      return await getFcmToken(); // iOS only supports FCM
    } else {
      return '';
    }
  }

  Future<String> getFcmToken() async {
    try {
      String? fcmToken = await _messaging.getToken();
      return fcmToken ?? '';
    } catch (e) {
      print("Error getting FCM token: $e");
      return '';
    }
  }

  /// ✅ Correct way to get HMS token (using a Completer)

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    const channel = AndroidNotificationChannel(
      'elfarouk_app',
      'Elfarouk App',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsDarwin = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log('Notification Details: ${details.payload}');

        if (details.payload != null) {
          getIt<NavigationService>().navigateTo(
            RouteNames.debtorsView,

          );
        }
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Map<String, dynamic> _parsePayload(String payload) {
    try {
      return Map<String, dynamic>.from(json.decode(payload));
    } catch (e) {
      log('Error parsing payload: $e');
      return {};
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'elfarouk_app',
            'Elfarouk App',
            channelDescription: 'Important notifications for Elfarouk App.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((message) async {
      log('message data ${message.data}');

      await showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('message data ${message.data}');
      _handleForegroundMessage(message);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      log('message data ${initialMessage.data}');
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    log('Foreground Message Payload: ${message.data}');

      getIt<NavigationService>().navigateTo(
        RouteNames.debtorsView,

      );
      // getIt<NavigationService>().navigateTo(
      //   RouteNames.singleRequestScreen,
      //   arguments: {'id': int.parse(parsedId.toString()),
      //     "work_flow_name":workflowName,
      //     "channel_id":message.data['channel_id']
      //
      //
      //   },
      // );

  }

  void _handleBackgroundMessage(RemoteMessage message) {
    log('Background Message Payload: ${message.data}');
    if (message.data.containsKey('request_id')) {

      getIt<NavigationService>().navigateTo(
        RouteNames.debtorsView,

      );
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationService = NotificationService();
  await notificationService.setupFlutterNotifications();
  if (message.notification != null) {
    await notificationService.showNotification(message);
  }
  log('Background Handler Payload: ${message.data}');
}
