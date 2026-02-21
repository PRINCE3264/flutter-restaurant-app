



// lib/services/notification_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Local notifications
  late FlutterLocalNotificationsPlugin _localNotifications;

  // Initialize notifications
  Future<void> initialize() async {
    // Initialize local notifications first
    _localNotifications = FlutterLocalNotificationsPlugin();

    // Android settings
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Create notification channel
    await _createNotificationChannel();

    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ User granted permission for notifications');
    }

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      debugPrint('✅ FCM Token: $token');
      await _saveTokenToFirestore(token);
    } else {
      debugPrint('❌ FCM Token is null');
    }

    // Handle background messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Token refresh
    _firebaseMessaging.onTokenRefresh.listen(_saveTokenToFirestore);

    debugPrint('✅ Notification Service Initialized Successfully');
  }

  // Create notification channel
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'order_channel', // Channel ID
      'Order Notifications', // Channel name
      description: 'Notifications for order updates',
      importance: Importance.max,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Save FCM token to Firestore
  Future<void> _saveTokenToFirestore(String token) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fcmTokens': FieldValue.arrayUnion([token]),
          'updatedAt': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'email': user.email,
        }, SetOptions(merge: true));

        debugPrint('✅ FCM Token saved to Firestore for user: ${user.uid}');
      } else {
        debugPrint('❌ No user logged in, cannot save FCM token');
      }
    } catch (e) {
      debugPrint('❌ Error saving FCM token: $e');
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📱 Received foreground message: ${message.notification?.title}');

    // Show local notification
    _showLocalNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? 'You have a new message',
    );
  }

  // Handle background messages when app is opened
  void _handleBackgroundMessage(RemoteMessage message) {
    debugPrint('🔔 Opened app from background message: ${message.notification?.title}');

    // Navigate to specific screen based on message data
    _handleNotificationTap(message.data);
  }

  // Show local notification
  Future<void> _showLocalNotification({required String title, required String body}) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'order_channel', // Must match channel ID
        'Order Notifications',
        channelDescription: 'Order updates',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        sound: 'default',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        details,
      );

      debugPrint('✅ Local notification shown: $title');
    } catch (e) {
      debugPrint('❌ Error showing local notification: $e');
    }
  }

  // Handle notification tap
  void _handleNotificationTap(Map<String, dynamic> data) {
    final type = data['type'];
    final orderId = data['orderId'];

    debugPrint('📍 Notification tapped - Type: $type, OrderId: $orderId');
  }

  // Simple method to show notification from anywhere
  Future<void> showSimpleNotification(String title, String body) async {
    await _showLocalNotification(title: title, body: body);

    // Also save to Firestore
    await _saveNotificationToFirestore(title, body);
  }

  // Save notification to Firestore
  Future<void> _saveNotificationToFirestore(String title, String body) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final notification = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          body: body,
          type: 'general',
          isRead: false,
          createdAt: DateTime.now(),
          data: {},
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .doc(notification.id)
            .set(notification.toMap());

        debugPrint('✅ Notification saved to Firestore: $title');
      }
    } catch (e) {
      debugPrint('❌ Error saving notification to Firestore: $e');
    }
  }

  // ✅ ADD THIS MISSING METHOD - Send order notification to user
  Future<void> sendOrderNotification({
    required String userId,
    required String orderId,
    required String title,
    required String body,
    required String status,
  }) async {
    try {
      // Show local notification immediately
      await _showLocalNotification(title: title, body: body);

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: 'order',
        orderId: orderId,
        isRead: false,
        createdAt: DateTime.now(),
        data: {
          'orderId': orderId,
          'status': status,
          'type': 'order',
        },
      );

      // Save to user's notifications
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toMap());

      debugPrint('✅ Order notification sent: $title');
    } catch (e) {
      debugPrint('❌ Error sending order notification: $e');
      // Fallback: Show local notification even if Firestore fails
      await _showLocalNotification(title: title, body: body);
    }
  }

  // ✅ ADD THIS MISSING METHOD - Send offer notification
  Future<void> sendOfferNotification({
    required String title,
    required String body,
    required String imageUrl,
    required String offerId,
  }) async {
    try {
      // Show local notification immediately
      await _showLocalNotification(title: title, body: body);

      // Get current user to save notification
      final user = _auth.currentUser;
      if (user != null) {
        final notification = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          body: body,
          type: 'offer',
          imageUrl: imageUrl,
          isRead: false,
          createdAt: DateTime.now(),
          data: {
            'offerId': offerId,
            'type': 'offer',
            'imageUrl': imageUrl,
          },
        );

        // Save to user's notifications
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .doc(notification.id)
            .set(notification.toMap());
      }

      debugPrint('✅ Offer notification sent: $title');
    } catch (e) {
      debugPrint('❌ Error sending offer notification: $e');
      // Fallback: Show local notification even if Firestore fails
      await _showLocalNotification(title: title, body: body);
    }
  }

  // Get FCM token
  Future<String?> getFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token);
      }
      return token;
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
      return null;
    }
  }

  // Test notification method
  Future<void> testNotification() async {
    final user = _auth.currentUser;
    if (user != null) {
      await showSimpleNotification(
          'Test Notification ✅',
          'This is a test notification at ${DateTime.now().toString()}'
      );
    } else {
      debugPrint('❌ No user logged in for test notification');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  // Get user notifications stream
  Stream<List<NotificationModel>> getUserNotifications() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Get unread notifications count
  Stream<int> getUnreadCount() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}