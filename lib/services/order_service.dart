// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/order_model.dart';
//
// class OrderService {
//   final CollectionReference ordersCollection =
//   FirebaseFirestore.instance.collection("orders");
//
//   Future<void> placeOrder(OrderModel order) async {
//     await ordersCollection.add(order.toMap());
//   }
//
//   Stream<List<OrderModel>> getOrders() {
//     return ordersCollection
//         .orderBy("createdAt", descending: true)
//         .snapshots()
//         .map((snapshot) =>
//         snapshot.docs.map((doc) => OrderModel.fromDoc(doc)).toList());
//   }
// }
//

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order_model.dart'; // Change to import your Order class

class OrderService {
  final CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection("orders");

  Future<void> placeOrder(Order order) async {
    await ordersCollection.add(order.toMap());
  }

  Stream<List<Order>> getOrders() {
    return ordersCollection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
  }

  // Additional methods for order management
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await ordersCollection.doc(orderId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> assignDeliveryBoy(String orderId, String deliveryBoyId) async {
    await ordersCollection.doc(orderId).update({
      'deliveryBoyId': deliveryBoyId,
      'status': 'assigned',
      'assignedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markOrderAsDelivered(String orderId) async {
    await ordersCollection.doc(orderId).update({
      'status': 'delivered',
      'deliveredAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Order>> getUserOrders(String userId) {
    return ordersCollection
        .where('customerId', isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
  }

  Stream<List<Order>> getPendingOrders() {
    return ordersCollection
        .where('status', isEqualTo: 'pending')
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
  }

  Stream<List<Order>> getCompletedOrders() {
    return ordersCollection
        .where('status', isEqualTo: 'delivered')
        .orderBy("deliveredAt", descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
  }

  Future<Order?> getOrderById(String orderId) async {
    final doc = await ordersCollection.doc(orderId).get();
    if (doc.exists) {
      return Order.fromFirestore(doc);
    }
    return null;
  }

  Future<void> cancelOrder(String orderId) async {
    await ordersCollection.doc(orderId).update({
      'status': 'cancelled',
      'cancelledAt': FieldValue.serverTimestamp(),
    });
  }

  // Get orders for a specific delivery boy
  Stream<List<Order>> getDeliveryBoyOrders(String deliveryBoyId) {
    return ordersCollection
        .where('deliveryBoyId', isEqualTo: deliveryBoyId)
        .orderBy("assignedAt", descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
  }

  // Get active orders for delivery boy (not delivered or cancelled)
  Stream<List<Order>> getDeliveryBoyActiveOrders(String deliveryBoyId) {
    return ordersCollection
        .where('deliveryBoyId', isEqualTo: deliveryBoyId)
        .where('status', whereIn: ['assigned', 'picked_up', 'on_the_way'])
        .orderBy("assignedAt", descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
  }
}
