// lib/models/notification_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // 'order', 'offer', 'system'
  final String? orderId;
  final String? imageUrl;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.orderId,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'orderId': orderId,
      'imageUrl': imageUrl,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
      'data': data,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return NotificationModel(
      id: documentId,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: map['type'] ?? 'system',
      orderId: map['orderId'],
      imageUrl: map['imageUrl'],
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      data: map['data'] != null ? Map<String, dynamic>.from(map['data']) : null,
    );
  }

  NotificationModel copyWith({
    bool? isRead,
  }) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      orderId: orderId,
      imageUrl: imageUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      data: data,
    );
  }
}