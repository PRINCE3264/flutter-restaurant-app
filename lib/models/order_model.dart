import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Order {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final List<OrderItem> items;
  final double totalAmount;
  final String deliveryAddress;
  final DateTime date;
  final String status; // pending, confirmed, preparing, ready, delivered
  final String paymentStatus; // pending, paid, failed
  final String? specialInstructions;
  final String? vendorPhone;
  final String? orderType; // pickup, delivery
  final String? pickupTime;

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.date,
    required this.status,
    required this.paymentStatus,
    this.specialInstructions,
    this.vendorPhone,
    this.orderType,
    this.pickupTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'date': date.toIso8601String(),
      'status': status,
      'paymentStatus': paymentStatus,
      'specialInstructions': specialInstructions,
      'vendorPhone': vendorPhone,
      'orderType': orderType,
      'pickupTime': pickupTime,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      customerEmail: map['customerEmail'] ?? '',
      items: List<OrderItem>.from(
          (map['items'] as List<dynamic>).map((x) => OrderItem.fromMap(x))),
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      deliveryAddress: map['deliveryAddress'] ?? '',
      date: DateTime.parse(map['date']),
      status: map['status'] ?? 'pending',
      paymentStatus: map['paymentStatus'] ?? 'pending',
      specialInstructions: map['specialInstructions'],
      vendorPhone: map['vendorPhone'],
      orderType: map['orderType'],
      pickupTime: map['pickupTime'],
    );
  }

  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order.fromMap({...data, 'id': doc.id});
  }

  // Copy with method for updating order
  Order copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    List<OrderItem>? items,
    double? totalAmount,
    String? deliveryAddress,
    DateTime? date,
    String? status,
    String? paymentStatus,
    String? specialInstructions,
    String? vendorPhone,
    String? orderType,
    String? pickupTime,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      date: date ?? this.date,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      vendorPhone: vendorPhone ?? this.vendorPhone,
      orderType: orderType ?? this.orderType,
      pickupTime: pickupTime ?? this.pickupTime,
    );
  }

  // Helper methods
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String get formattedTime {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get taxAmount {
    return subtotal * 0.18; // 18% GST
  }

  double get deliveryCharge {
    return orderType == 'delivery' ? 40.0 : 0.0;
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isPreparing => status == 'preparing';
  bool get isReady => status == 'ready';
  bool get isDelivered => status == 'delivered';
  bool get isPaid => paymentStatus == 'paid';

  // Get order status color
  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'ready':
        return Colors.green;
      case 'delivered':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // Get order status icon
  IconData get statusIcon {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.emoji_food_beverage;
      case 'delivered':
        return Icons.delivery_dining;
      default:
        return Icons.question_mark;
    }
  }

  // Convert to string for display
  @override
  String toString() {
    return 'Order(id: $id, customer: $customerName, total: ₹$totalAmount, status: $status)';
  }

  // Equality check
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? image;
  final String? description;
  final String? category;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
    this.description,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
      'description': description,
      'category': category,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as int?) ?? 0,
      image: map['image'],
      description: map['description'],
      category: map['category'],
    );
  }

  // Copy with method
  OrderItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? image,
    String? description,
    String? category,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }

  // Helper methods
  double get totalPrice => price * quantity;

  bool get hasImage => image != null && image!.isNotEmpty;

  // Convert to string for display
  @override
  String toString() {
    return 'OrderItem(name: $name, quantity: $quantity, price: ₹$price)';
  }

  // Equality check
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}




// lib/models/order_model.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class OrderModel {
//   final String id;
//   final String userId;
//   final List<Map<String, dynamic>> items;
//   final double total;
//   final double fuelCharge;
//   final double walletUsed;
//   final String status;
//   final String paymentStatus;
//   final String? paymentId;
//   final DateTime createdAt;
//   final String? deliveryBoyId;
//   final String? deliveryBoyName;
//   final String? deliveryBoyPhone;
//   final String? deliveryStatus;
//   final DateTime? assignedAt;
//   final DateTime? acceptedAt;
//   final DateTime? pickedUpAt;
//   final DateTime? deliveredAt;
//   final String? deliveryAddress;
//   final double? deliveryLat;
//   final double? deliveryLng;
//   final String? customerPhone;
//   final String? customerName;
//   final List<Map<String, dynamic>> statusHistory;
//
//   OrderModel({
//     required this.id,
//     required this.userId,
//     required this.items,
//     required this.total,
//     required this.fuelCharge,
//     required this.walletUsed,
//     required this.status,
//     required this.paymentStatus,
//     this.paymentId,
//     required this.createdAt,
//     this.deliveryBoyId,
//     this.deliveryBoyName,
//     this.deliveryBoyPhone,
//     this.deliveryStatus = 'pending',
//     this.assignedAt,
//     this.acceptedAt,
//     this.pickedUpAt,
//     this.deliveredAt,
//     this.deliveryAddress,
//     this.deliveryLat,
//     this.deliveryLng,
//     this.customerPhone,
//     this.customerName,
//     required this.statusHistory,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'userId': userId,
//       'items': items,
//       'total': total,
//       'fuelCharge': fuelCharge,
//       'walletUsed': walletUsed,
//       'status': status,
//       'paymentStatus': paymentStatus,
//       'paymentId': paymentId,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'deliveryBoyId': deliveryBoyId,
//       'deliveryBoyName': deliveryBoyName,
//       'deliveryBoyPhone': deliveryBoyPhone,
//       'deliveryStatus': deliveryStatus,
//       'assignedAt': assignedAt != null ? Timestamp.fromDate(assignedAt!) : null,
//       'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
//       'pickedUpAt': pickedUpAt != null ? Timestamp.fromDate(pickedUpAt!) : null,
//       'deliveredAt': deliveredAt != null ? Timestamp.fromDate(deliveredAt!) : null,
//       'deliveryAddress': deliveryAddress,
//       'deliveryLat': deliveryLat,
//       'deliveryLng': deliveryLng,
//       'customerPhone': customerPhone,
//       'customerName': customerName,
//       'statusHistory': statusHistory,
//     };
//   }
//
//   factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
//     return OrderModel(
//       id: documentId,
//       userId: map['userId'] ?? '',
//       items: List<Map<String, dynamic>>.from(map['items'] ?? []),
//       total: (map['total'] ?? 0.0).toDouble(),
//       fuelCharge: (map['fuelCharge'] ?? 0.0).toDouble(),
//       walletUsed: (map['walletUsed'] ?? 0.0).toDouble(),
//       status: map['status'] ?? 'Placed',
//       paymentStatus: map['paymentStatus'] ?? 'Pending',
//       paymentId: map['paymentId'],
//       createdAt: (map['createdAt'] as Timestamp).toDate(),
//       deliveryBoyId: map['deliveryBoyId'],
//       deliveryBoyName: map['deliveryBoyName'],
//       deliveryBoyPhone: map['deliveryBoyPhone'],
//       deliveryStatus: map['deliveryStatus'] ?? 'pending',
//       assignedAt: map['assignedAt'] != null ? (map['assignedAt'] as Timestamp).toDate() : null,
//       acceptedAt: map['acceptedAt'] != null ? (map['acceptedAt'] as Timestamp).toDate() : null,
//       pickedUpAt: map['pickedUpAt'] != null ? (map['pickedUpAt'] as Timestamp).toDate() : null,
//       deliveredAt: map['deliveredAt'] != null ? (map['deliveredAt'] as Timestamp).toDate() : null,
//       deliveryAddress: map['deliveryAddress'],
//       deliveryLat: map['deliveryLat']?.toDouble(),
//       deliveryLng: map['deliveryLng']?.toDouble(),
//       customerPhone: map['customerPhone'],
//       customerName: map['customerName'],
//       statusHistory: List<Map<String, dynamic>>.from(map['statusHistory'] ?? []),
//     );
//   }
//
//   OrderModel copyWith({
//     String? status,
//     String? deliveryStatus,
//     String? deliveryBoyId,
//     String? deliveryBoyName,
//     String? deliveryBoyPhone,
//     DateTime? acceptedAt,
//     DateTime? pickedUpAt,
//     DateTime? deliveredAt,
//   }) {
//     return OrderModel(
//       id: id,
//       userId: userId,
//       items: items,
//       total: total,
//       fuelCharge: fuelCharge,
//       walletUsed: walletUsed,
//       status: status ?? this.status,
//       paymentStatus: paymentStatus,
//       paymentId: paymentId,
//       createdAt: createdAt,
//       deliveryBoyId: deliveryBoyId ?? this.deliveryBoyId,
//       deliveryBoyName: deliveryBoyName ?? this.deliveryBoyName,
//       deliveryBoyPhone: deliveryBoyPhone ?? this.deliveryBoyPhone,
//       deliveryStatus: deliveryStatus ?? this.deliveryStatus,
//       assignedAt: assignedAt,
//       acceptedAt: acceptedAt ?? this.acceptedAt,
//       pickedUpAt: pickedUpAt ?? this.pickedUpAt,
//       deliveredAt: deliveredAt ?? this.deliveredAt,
//       deliveryAddress: deliveryAddress,
//       deliveryLat: deliveryLat,
//       deliveryLng: deliveryLng,
//       customerPhone: customerPhone,
//       customerName: customerName,
//       statusHistory: statusHistory,
//     );
//   }
// }