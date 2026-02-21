//
// // lib/order/order_notification_helper.dart
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class OrderNotificationHelper {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   late FlutterLocalNotificationsPlugin _localNotifications;
//
//   OrderNotificationHelper() {
//     _localNotifications = FlutterLocalNotificationsPlugin();
//     _initializeNotifications();
//   }
//
//   Future<void> _initializeNotifications() async {
//     // Request permission
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     print('User granted permission: ${settings.authorizationStatus}');
//
//     // Initialize local notifications
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const DarwinInitializationSettings iosSettings =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await _localNotifications.initialize(initSettings);
//
//     // Create notification channel for Android
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'order_channel',
//       'Order Notifications',
//       description: 'Notifications for order updates',
//       importance: Importance.high,
//     );
//
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     // Configure FCM
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
//
//     // Get FCM token
//     String? token = await _firebaseMessaging.getToken();
//     print('FCM Token: $token');
//   }
//
//   void _handleForegroundMessage(RemoteMessage message) {
//     print('Got a message whilst in the foreground!');
//     print('Message data: ${message.data}');
//
//     if (message.notification != null) {
//       _showLocalNotification(
//         message.notification!.title ?? 'New Notification',
//         message.notification!.body ?? '',
//         message.data,
//       );
//     }
//   }
//
//   void _handleBackgroundMessage(RemoteMessage message) {
//     print('Handling a background message: ${message.messageId}');
//   }
//
//   Future<void> _showLocalNotification(String title, String body, Map<String, dynamic> data) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'order_channel',
//       'Order Notifications',
//       channelDescription: 'Order updates',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//     );
//
//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _localNotifications.show(
//       DateTime.now().millisecondsSinceEpoch.remainder(100000),
//       title,
//       body,
//       details,
//       payload: data.toString(),
//     );
//   }
//
//   // Save FCM token to user document
//   Future<void> saveFCMToken(String userId) async {
//     try {
//       String? token = await _firebaseMessaging.getToken();
//       if (token != null) {
//         await FirebaseFirestore.instance.collection('users').doc(userId).update({
//           'fcmToken': token,
//           'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
//         });
//         print('FCM token saved for user: $userId');
//       }
//     } catch (e) {
//       print('Error saving FCM token: $e');
//     }
//   }
//
//   // Send order placed notification
//   Future<void> sendOrderPlacedNotification({
//     required String userId,
//     required String orderId,
//     required double totalAmount,
//   }) async {
//     try {
//       // Save notification to Firestore
//       await FirebaseFirestore.instance.collection('notifications').add({
//         'userId': userId,
//         'orderId': orderId,
//         'title': '🎉 Order Placed Successfully!',
//         'body': 'Order #${orderId.substring(0, 6)} • Total: ₹${totalAmount.toStringAsFixed(2)}',
//         'type': 'order_placed',
//         'timestamp': FieldValue.serverTimestamp(),
//         'read': false,
//       });
//
//       // Show local notification
//       await _showLocalNotification(
//         '🎉 Order Placed Successfully!',
//         'Order #${orderId.substring(0, 6)} • Total: ₹${totalAmount.toStringAsFixed(2)}',
//         {'orderId': orderId, 'type': 'order_placed'},
//       );
//
//       print('✅ Order placed notification sent for order $orderId');
//     } catch (e) {
//       print('❌ Error sending order placed notification: $e');
//     }
//   }
//
//   // Send payment success notification
//   Future<void> sendPaymentSuccessNotification({
//     required String userId,
//     required String orderId,
//     required double amount,
//   }) async {
//     try {
//       // Save notification to Firestore
//       await FirebaseFirestore.instance.collection('notifications').add({
//         'userId': userId,
//         'orderId': orderId,
//         'title': '💰 Payment Successful!',
//         'body': 'Payment of ₹${amount.toStringAsFixed(2)} completed for order #${orderId.substring(0, 6)}',
//         'type': 'payment_success',
//         'timestamp': FieldValue.serverTimestamp(),
//         'read': false,
//       });
//
//       // Show local notification
//       await _showLocalNotification(
//         '💰 Payment Successful!',
//         'Payment of ₹${amount.toStringAsFixed(2)} completed for order #${orderId.substring(0, 6)}',
//         {'orderId': orderId, 'type': 'payment_success'},
//       );
//
//       print('✅ Payment success notification sent for order $orderId');
//     } catch (e) {
//       print('❌ Error sending payment success notification: $e');
//     }
//   }
//
//   // Send order status update notification
//   Future<void> sendOrderStatusNotification({
//     required String userId,
//     required String orderId,
//     required String status,
//   }) async {
//     try {
//       final statusMessages = {
//         'Accepted': '👨‍🍳 Order Accepted',
//         'Preparing': '👨‍🍳 Preparing Your Order',
//         'Ready': '✅ Order Ready for Pickup',
//         'Completed': '🎉 Order Completed',
//       };
//
//       final title = statusMessages[status] ?? 'Order Updated';
//       final body = 'Order #${orderId.substring(0, 6)} is now $status';
//
//       // Save notification to Firestore
//       await FirebaseFirestore.instance.collection('notifications').add({
//         'userId': userId,
//         'orderId': orderId,
//         'title': title,
//         'body': body,
//         'type': 'status_update',
//         'status': status,
//         'timestamp': FieldValue.serverTimestamp(),
//         'read': false,
//       });
//
//       // Show local notification
//       await _showLocalNotification(
//         title,
//         body,
//         {'orderId': orderId, 'type': 'status_update', 'status': status},
//       );
//
//       print('✅ Status notification sent: $status for order $orderId');
//     } catch (e) {
//       print('❌ Error sending status notification: $e');
//     }
//   }
// }



import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class OrderNotificationHelper {

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'order_channel';

  OrderNotificationHelper() {
    _setup();
  }

  // ================= INITIAL SETUP =================

  Future<void> _setup() async {
    await _requestPermission();
    await _initLocalNotifications();
    await _createAndroidChannel();
    _configureFCMListeners();
  }

  Future<void> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔔 Notification permission: ${settings.authorizationStatus}');
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _local.initialize(settings);
  }

  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      'Order Notifications',
      description: 'Order updates and payments',
      importance: Importance.high,
    );

    final androidPlugin =
    _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
  }

  void _configureFCMListeners() {

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        _showLocal(
          message.notification!.title!,
          message.notification!.body!,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('📲 Opened from notification: ${message.data}');
    });
  }

  // ================= LOCAL DISPLAY =================

  Future<void> _showLocal(String title, String body) async {

    const android = AndroidNotificationDetails(
      _channelId,
      'Order Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const ios = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: android,
      iOS: ios,
    );

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  // ================= TOKEN SAVE =================

  Future<void> saveFCMToken(String userId) async {
    final token = await _fcm.getToken();

    if (token == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({
      'fcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    print('✅ FCM Token saved');
  }

  // ================= NOTIFICATION TYPES =================

  Future<void> sendOrderPlaced({
    required String userId,
    required String orderId,
    required double total,
  }) async {

    final title = '🎉 Order Placed!';
    final body =
        'Order #${orderId.substring(0, 6)} • ₹${total.toStringAsFixed(2)}';

    await _saveToFirestore(
      userId,
      orderId,
      title,
      body,
      'order_placed',
    );

    await _showLocal(title, body);
  }

  Future<void> sendPaymentSuccess({
    required String userId,
    required String orderId,
    required double amount,
  }) async {

    final title = '💰 Payment Successful';
    final body =
        '₹${amount.toStringAsFixed(2)} paid for Order #${orderId.substring(0, 6)}';

    await _saveToFirestore(
      userId,
      orderId,
      title,
      body,
      'payment_success',
    );

    await _showLocal(title, body);
  }

  Future<void> sendStatusUpdate({
    required String userId,
    required String orderId,
    required String status,
  }) async {

    final title = '📦 Order Update';
    final body = 'Order #${orderId.substring(0, 6)} is $status';

    await _saveToFirestore(
      userId,
      orderId,
      title,
      body,
      'status_update',
    );

    await _showLocal(title, body);
  }

  // ================= FIRESTORE STORE =================

  Future<void> _saveToFirestore(
      String userId,
      String orderId,
      String title,
      String body,
      String type,
      ) async {

    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': userId,
      'orderId': orderId,
      'title': title,
      'body': body,
      'type': type,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}