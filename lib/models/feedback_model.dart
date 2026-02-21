// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class FeedbackModel {
//   final String id;
//   final String userId;
//   final String foodId; // Or vendorId
//   final double rating;
//   final String comment;
//   final DateTime timestamp;
//
//   FeedbackModel({
//     required this.id,
//     required this.userId,
//     required this.foodId,
//     required this.rating,
//     required this.comment,
//     required this.timestamp,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'userId': userId,
//       'foodId': foodId,
//       'rating': rating,
//       'comment': comment,
//       'timestamp': timestamp,
//     };
//   }
//
//   factory FeedbackModel.fromMap(Map<String, dynamic> map, String docId) {
//     return FeedbackModel(
//       id: docId,
//       userId: map['userId'] ?? '',
//       foodId: map['foodId'] ?? '',
//       rating: (map['rating'] ?? 0).toDouble(),
//       comment: map['comment'] ?? '',
//       timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String userId;
  final String foodId;
  final double rating;
  final String comment;
  final DateTime timestamp;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'foodId': foodId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String docId) {
    return FeedbackModel(
      id: docId,
      userId: map['userId'] ?? '',
      foodId: map['foodId'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      comment: map['comment'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
