// // lib/models/wallet_transaction.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class WalletTransaction {
//   final String id;
//   final String type; // 'credit' or 'debit'
//   final double amount;
//   final DateTime date;
//   final String description;
//   final String? orderId;
//   final String? vendorId;
//
//   WalletTransaction({
//     required this.id,
//     required this.type,
//     required this.amount,
//     required this.date,
//     required this.description,
//     this.orderId,
//     this.vendorId,
//   });
//
//   /// ✅ Convert object to Firestore-friendly Map
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'type': type,
//       'amount': amount,
//       // Firestore prefers Timestamp for better queries/sorting
//       'date': Timestamp.fromDate(date),
//       'description': description,
//       'orderId': orderId,
//       'vendorId': vendorId,
//     };
//   }
//
//   /// ✅ Safely build from Firestore Map (handles Timestamp/int/String)
//   factory WalletTransaction.fromMap(Map<String, dynamic> map) {
//     DateTime parsedDate;
//
//     final dynamic dateData = map['date'];
//     if (dateData is Timestamp) {
//       parsedDate = dateData.toDate();
//     } else if (dateData is int) {
//       parsedDate = DateTime.fromMillisecondsSinceEpoch(dateData);
//     } else if (dateData is String) {
//       parsedDate = DateTime.tryParse(dateData) ?? DateTime.now();
//     } else {
//       parsedDate = DateTime.now();
//     }
//
//     return WalletTransaction(
//       id: map['id'] ?? '',
//       type: map['type'] ?? 'credit',
//       amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
//       date: parsedDate,
//       description: map['description'] ?? '',
//       orderId: map['orderId'],
//       vendorId: map['vendorId'],
//     );
//   }
// }


// lib/models/wallet_transaction.dart
class WalletTransaction {
  final String id;
  final double amount;
  final String type; // "credit" or "debit"
  final String description;
  final DateTime date;

  WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
  });

  factory WalletTransaction.fromMap(Map<String, dynamic> map) {
    return WalletTransaction(
      id: map['id'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? 'credit',
      description: map['description'] ?? '',
      date: (map['date'] as DateTime?) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date,
    };
  }
}
