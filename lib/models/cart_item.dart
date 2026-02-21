// //
// //
// // class CartItem {
// //   final String name;
// //   final double price;
// //   final int qty;
// //   final String imageUrl;
// //   final String vendorId;     // Vendor document ID
// //   final String vendorName;   // Friendly vendor name
// //   final double discount;     // Discount amount per item
// //
// //   CartItem({
// //     required this.name,
// //     required this.price,
// //     required this.qty,
// //     required this.imageUrl,
// //     required this.vendorId,
// //     required this.vendorName,
// //     this.discount = 0.0,
// //   });
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'name': name,
// //       'price': price,
// //       'qty': qty,
// //       'imageUrl': imageUrl,
// //       'vendorId': vendorId,
// //       'vendorName': vendorName,
// //       'discount': discount,
// //     };
// //   }
// //
// //   factory CartItem.fromMap(Map<String, dynamic> map) {
// //     return CartItem(
// //       name: map['name'] ?? 'Unknown',
// //       price: (map['price'] is int)
// //           ? (map['price'] as int).toDouble()
// //           : (map['price'] as double? ?? 0.0),
// //       qty: map['qty'] ?? 0,
// //       imageUrl: map['imageUrl'] ?? '',
// //       vendorId: map['vendorId'] ?? '',
// //       vendorName: map['vendorName'] ?? '',
// //       discount: (map['discount'] is int)
// //           ? (map['discount'] as int).toDouble()
// //           : (map['discount'] as double? ?? 0.0),
// //     );
// //   }
// //
// //   double get totalPrice => (price - discount) * qty; // Apply discount
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class CartItem {
//   final String name;
//   final double price;
//   final int qty;
//   final String imageUrl;
//   final String vendorId;
//   final String vendorName;
//   final double discount;
//
//   CartItem({
//     required this.name,
//     required this.price,
//     required this.qty,
//     required this.imageUrl,
//     required this.vendorId,
//     required this.vendorName,
//     this.discount = 0.0,
//   });
//
//   // Convert CartItem → Map for Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'price': price,
//       'qty': qty,
//       'imageUrl': imageUrl,
//       'vendorId': vendorId,
//       'vendorName': vendorName,
//       'discount': discount,
//     };
//   }
//
//   // Create CartItem from Map
//   factory CartItem.fromMap(Map<String, dynamic> map) {
//     return CartItem(
//       name: map['name'] ?? 'Unknown',
//       price: (map['price'] is int)
//           ? (map['price'] as int).toDouble()
//           : (map['price'] as double? ?? 0.0),
//       qty: map['qty'] ?? 0,
//       imageUrl: map['imageUrl'] ?? '',
//       vendorId: map['vendorId'] ?? '',
//       vendorName: map['vendorName'] ?? '',
//       discount: (map['discount'] is int)
//           ? (map['discount'] as int).toDouble()
//           : (map['discount'] as double? ?? 0.0),
//     );
//   }
//
//   // Create CartItem from Firestore DocumentSnapshot
//   factory CartItem.fromDoc(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>? ?? {};
//     return CartItem.fromMap(data);
//   }
//
//   double get totalPrice => (price - discount) * qty; // Apply discount
// }



class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String image;
  final String? description;
  final String vendorId;
  final String vendorName;
  final double? discount;
  final bool? available;
  final double? rating;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    this.description,
    required this.vendorId,
    required this.vendorName,
    this.discount,
    this.available,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
      'description': description,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'discount': discount,
      'available': available,
      'rating': rating,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      image: map['image'] ?? '',
      description: map['description'],
      vendorId: map['vendorId'] ?? '',
      vendorName: map['vendorName'] ?? '',
      discount: (map['discount'] ?? 0.0).toDouble(),
      available: map['available'] ?? true,
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? image,
    String? description,
    String? vendorId,
    String? vendorName,
    double? discount,
    bool? available,
    double? rating,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      description: description ?? this.description,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      discount: discount ?? this.discount,
      available: available ?? this.available,
      rating: rating ?? this.rating,
    );
  }
}