// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../screens/dashboard/dashboard_screen.dart';
//
// class CartProvider extends ChangeNotifier {
//   List<FoodItem> _cartItems = [];
//
//   List<FoodItem> get cartItems => _cartItems;
//
//   void addToCart(FoodItem item) {
//     _cartItems.add(item);
//     notifyListeners();
//   }
//
//   void removeFromCart(FoodItem item) {
//     _cartItems.remove(item);
//     notifyListeners();
//   }
//
//   Future<void> placeOrder() async {
//     if (_cartItems.isEmpty) return;
//
//     final orderData = {
//       'items': _cartItems
//           .map((e) => {
//         'name': e.name,
//         'description': e.description,
//         'image': e.image,
//         'price': e.price,
//         'quantity': e.quantity,
//       })
//           .toList(),
//       'totalPrice':
//       _cartItems.fold(0, (sum, item) => sum + item.price * item.quantity),
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     };
//
//     await FirebaseFirestore.instance.collection('orders').add(orderData);
//
//     _cartItems.clear();
//     notifyListeners();
//   }
//
//   // Fetch orders for display
//   Stream<QuerySnapshot> getOrdersStream() {
//     return FirebaseFirestore.instance
//         .collection('orders')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }
// }
