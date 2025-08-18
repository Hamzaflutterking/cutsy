// import 'dart:convert';
// import 'dart:developer';
// import 'dart:developer' as dev;

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:forgot_me_not/main.dart';
// import 'package:get/get.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
//   // ✅ NEW: Store pending initial message
//   static RemoteMessage? pendingInitialMessage;

//   @pragma('vm:entry-point')
//   static void notificationTapBackground(NotificationResponse response) {
//     if (response.payload != null) {
//       try {
//         final payload = jsonDecode(response.payload!);
//         // _handleNotificationNavigation(payload);
//         // handleInitialMessageIfAppKilled();
//       } catch (e) {
//         log("❌ Background tap decode error: $e");
//       }
//     }
//   }

//   static Future<void> initialize() async {
//     // Initialize local notifications (Android + iOS)
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       notificationCategories: [
//         DarwinNotificationCategory(
//           'default_category',
//           actions: [
//             DarwinNotificationAction.plain('action_1', 'Yes'),
//             DarwinNotificationAction.plain('action_2', 'No'),
//           ],
//         ),
//       ],
//     );

//     final initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
//     await _localNotifications.initialize(initSettings, onDidReceiveNotificationResponse: (NotificationResponse response) {
//       if (response.payload != null) {
//         final payload = jsonDecode(response.payload!);
//         // _handleNotificationNavigation(payload);
//       }
//       dev.log("Notification tapped: ${response.payload}");
//     }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

//     // iOS: Configure foreground presentation
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Request permission
//     final permission = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: true,
//     );
//     dev.log("📲 Notification Permission: ${permission.authorizationStatus}");

//     if (permission.authorizationStatus == AuthorizationStatus.authorized || permission.authorizationStatus == AuthorizationStatus.provisional) {
//       // ✅ Get FCM Token (for both iOS & Android)
//       // final token = await FirebaseMessaging.instance.getToken();
//       // if (token != null) {
//       //   dev.log("✅ FCM Token: $token");
//       //   fcmToken = token;
//       // } else {
//       //   dev.log("⚠️ FCM Token is null");
//       // }

//       // 🔑 Get APNs Token (iOS only)
//       // if (Platform.isIOS) {
//       //   final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//       //   if (apnsToken != null) {
//       //      dev. log("📱 APNs Token: $apnsToken");
//       //   } else {
//       //      dev. log("⚠️ APNs Token not available yet");
//       //   }
//       // }
//     } else {
//       dev.log("❌ Notification permissions denied");
//     }

//     // 🔁 Handle token refresh
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       dev.log("🔄 FCM Token refreshed: $newToken");
//       fcmToken = newToken;
//     });

//     // 🔔 Foreground notification handler
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       dev.log("📩 Foreground notification received ${message.data}");
//       _showLocalNotification(message);
//     });

//     // 🚀 App opened via notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       dev.log("🔗 Notification tapped: ${message.data}");

//       // _handleNotificationNavigation(message.data);
//     });
//     dev.log("✅ Firebase Messaging initialized successfully");

//     // 💤 Background handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   static bool _hasNavigatedFromInitialMessage = false;
//   // ✅ NEW: Handle notification when app is terminated
//   static Future<void> handleInitialMessageIfAppKilled() async {
//     try {
//       if (_hasNavigatedFromInitialMessage) return; // Prevent duplicate nav

//       RemoteMessage? message;

//       // First check if we have a pending message from main.dart
//       if (pendingInitialMessage != null) {
//         message = pendingInitialMessage;
//         pendingInitialMessage = null; // Clear it
//         dev.log("📦 Using pending initial message from main.dart");
//       } else {
//         // Fallback to getInitialMessage
//         message = await FirebaseMessaging.instance.getInitialMessage();
//         dev.log("📦 Getting fresh initial message");
//       }

//       if (message != null) {
//         dev.log("📦 Processing initial message: ${message.data}");

//         for (int i = 0; i < 5; i++) {
//           await Future.delayed(const Duration(milliseconds: 500));
//           if (Get.context != null) {
//             dev.log("✅ Get.context available, navigating...");
//             // _handleNotificationNavigation(message.data);
//             _hasNavigatedFromInitialMessage = true;
//             return;
//           } else {
//             dev.log("⏳ Waiting for Get.context...");
//           }
//         }
//       } else {
//         dev.log("📝 No initial message found");
//       }
//     } catch (e) {
//       dev.log("❌ Error handling initial message: $e");
//     }
//   }

//   // static void _handleNotificationNavigation(dynamic payload) {
//   //   try {
//   //     late Map<String, dynamic> data;

//   //     if (payload is String) {
//   //       data = jsonDecode(payload);
//   //     } else if (payload is Map) {
//   //       data = Map<String, dynamic>.from(payload);
//   //     } else {
//   //     dev.    log("❌ Invalid payload type: $payload");
//   //       return;
//   //     }

//   //     // Extract custom_data
//   //     dynamic customData = data["custom_data"];
//   //     if (customData is String) {
//   //       customData = jsonDecode(customData);
//   //     }

//   //     if (customData is! Map) {
//   //        dev. log("❌ custom_data is not a valid Map");
//   //       return;
//   //     }

//   //     if (customData["identifier"] == "chat") {
//   //       // ✅ Handle nested custom_data safely

//   //       final senderData = customData["custom_data"]["sender_data"];

//   //       if (senderData is String) {
//   //         // In case inner custom_data is JSON string
//   //         try {
//   //           customData = jsonDecode(senderData);
//   //         } catch (_) {}
//   //       }

//   //       final senderId = (senderData is Map && senderData["id"] != null) ? senderData["id"].toString() : "";

//   //       final name = (senderData is Map && senderData["name"] != null) ? senderData["name"].toString() : "";

//   //       final receiverData = {
//   //         "user-id": senderId, // fallback to empty string
//   //         "user-name": name,
//   //       };
//   //       dev.log("📥 Navigating to ChatView with receiverData: $receiverData");
//   //       navigatorKey.currentState?.push(
//   //         createAnimatedRoute(navigation: ChatView(reciverData: receiverData)),
//   //       );

//   //       // Get.to(() => ChatView(
//   //       //       reciverData: receiverData,
//   //       //     ));
//   //     }
//   //   } catch (e, s) {
//   //      dev. log("❌ Navigation error: $e");
//   //      dev. log(s.toString());
//   //   }
//   // }

//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     final notification = message.notification;
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'Default Channel',
//       channelDescription: 'Used for app notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//     );
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       interruptionLevel: InterruptionLevel.active,
//       sound: "10",
//     );

//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     if (notification != null) {
//       await _localNotifications.show(
//         notification.hashCode,
//         notification.title ?? 'No Title',
//         notification.body ?? 'No Body',
//         notificationDetails,
//         payload: jsonEncode(message.data),
//       );
//     }
//   }

//   @pragma('vm:entry-point')
//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     dev.log("💤 Background notification received ${message.data}");
//     await _showLocalNotification(message);
//   }
// }
