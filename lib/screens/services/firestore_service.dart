// // import 'dart:io';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
// import 'package:firebase_storage/firebase_storage.dart';
// import '../../models/food_item.dart';
// import '../../models/order_model.dart'; // Change from OrderModel to Order
// import '../../models/delivery_boy.dart';
//
// class FirestoreService {
//   final firestore.FirebaseFirestore _db = firestore.FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   // ---------------- Orders ----------------
//   Stream<List<Order>> getOrders() {
//     return _db.collection('orders').snapshots().map(
//           (snapshot) =>
//           snapshot.docs.map((doc) =>Order.fromFirestore(doc)).toList()
//     );
//   }
//
//   Stream<List<Order>> getPendingOrders() {
//     return _db
//         .collection('orders')
//         .where('status', isEqualTo: 'pending')
//         .snapshots()
//         .map(
//           (snapshot) =>
//           snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
//     );
//   }
//
//   Stream<List<Order>> getCompletedOrders() {
//     return _db
//         .collection('orders')
//         .where('status', isEqualTo: 'completed')
//         .snapshots()
//         .map(
//           (snapshot) =>
//           snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
//     );
//   }
//
//   Future<void> updateOrderStatus(String orderId, String newStatus) async {
//     await _db.collection('orders').doc(orderId).update({'status': newStatus});
//   }
//
//   // ---------------- Users ----------------
//   Stream<List<Map<String, dynamic>>> getAllUsers() {
//     return _db.collection('users').snapshots().map(
//           (snapshot) => snapshot.docs.map((doc) {
//         final data = doc.data();
//         data['uid'] = doc.id;
//         return data;
//       }).toList(),
//     );
//   }
//
//   Future<void> addUser(Map<String, dynamic> userData) async {
//     if (userData['uid'] != null && userData['uid'].toString().isNotEmpty) {
//       await _db.collection('users').doc(userData['uid']).set(userData);
//     } else {
//       await _db.collection('users').add(userData);
//     }
//   }
//
//   Future<void> updateUser(String uid, Map<String, dynamic> data) async {
//     await _db.collection('users').doc(uid).update(data);
//   }
//
//   Future<void> deleteUser(String uid) async {
//     await _db.collection('users').doc(uid).delete();
//   }
//
//   // ---------------- Food Items ----------------
//   Future<String> uploadFoodImage(File file) async {
//     try {
//       final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       final ref = _storage.ref().child('food_images').child(fileName);
//       await ref.putFile(file);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       throw Exception("Image upload failed: $e");
//     }
//   }
//
//   Future<void> addFoodItem(FoodItem item) async {
//     if (item.id.isEmpty) {
//       final docRef = _db.collection('menu').doc();
//       await docRef.set(item.toMap());
//     } else {
//       await _db.collection('menu').doc(item.id).set(item.toMap());
//     }
//   }
//
//   Future<void> updateFoodItem(String id, Map<String, dynamic> data) async {
//     await _db.collection('menu').doc(id).update(data);
//   }
//
//   Future<void> deleteFoodItem(String id) async {
//     await _db.collection('menu').doc(id).delete();
//   }
//
//   Stream<List<FoodItem>> getFoodItems() {
//     return _db.collection('menu').snapshots().map(
//           (snapshot) => snapshot.docs
//           .map((doc) => FoodItem.fromMap(
//         doc.data() as Map<String, dynamic>,
//         doc.id,
//       ))
//           .toList(),
//     );
//   }
//
//   Stream<List<FoodItem>> getAvailableFoodItems() {
//     return _db
//         .collection('menu')
//         .where('available', isEqualTo: true)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//           .map((doc) => FoodItem.fromMap(
//         doc.data() as Map<String, dynamic>,
//         doc.id,
//       )).toList(),
//     );
//   }
//
//   // ---------------- Delivery Boy Management ----------------
//
//   // Get all delivery boys
//   Stream<List<DeliveryBoy>> getDeliveryBoys() {
//     return _db.collection('deliveryBoys').snapshots().map(
//           (snapshot) => snapshot.docs
//           .map((doc) => DeliveryBoy.fromMap(
//         doc.data() as Map<String, dynamic>,
//         doc.id,
//       ))
//           .toList(),
//     );
//   }
//
//   // Get delivery boys by status
//   Stream<List<DeliveryBoy>> getDeliveryBoysByStatus(String status) {
//     return _db
//         .collection('deliveryBoys')
//         .where('status', isEqualTo: status)
//         .where('isActive', isEqualTo: true)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//           .map((doc) => DeliveryBoy.fromMap(
//         doc.data() as Map<String, dynamic>,
//         doc.id,
//       ))
//           .toList(),
//     );
//   }
//
//   // Get available delivery boys (for order assignment)
//   Stream<List<DeliveryBoy>> getAvailableDeliveryBoys() {
//     return _db
//         .collection('deliveryBoys')
//         .where('status', isEqualTo: 'Available')
//         .where('isActive', isEqualTo: true)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//           .map((doc) => DeliveryBoy.fromMap(
//         doc.data() as Map<String, dynamic>,
//         doc.id,
//       ))
//           .toList(),
//     );
//   }
//
//   // Add new delivery boy
//   Future<void> addDeliveryBoy(DeliveryBoy deliveryBoy) async {
//     try {
//       await _db.collection('deliveryBoys').doc(deliveryBoy.id).set(deliveryBoy.toMap());
//     } catch (e) {
//       throw Exception("Failed to add delivery boy: $e");
//     }
//   }
//
//   // Update delivery boy
//   Future<void> updateDeliveryBoy(DeliveryBoy deliveryBoy) async {
//     try {
//       await _db.collection('deliveryBoys').doc(deliveryBoy.id).update(deliveryBoy.toMap());
//     } catch (e) {
//       throw Exception("Failed to update delivery boy: $e");
//     }
//   }
//
//   // Update delivery boy status
//   Future<void> updateDeliveryBoyStatus(String deliveryBoyId, String status) async {
//     try {
//       await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
//         'status': status,
//         'lastActive': DateTime.now().millisecondsSinceEpoch,
//       });
//     } catch (e) {
//       throw Exception("Failed to update delivery boy status: $e");
//     }
//   }
//
//   // Assign order to delivery boy
//   Future<void> assignOrderToDeliveryBoy(String deliveryBoyId, String orderId) async {
//     try {
//       await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
//         'status': 'Busy',
//         'currentOrderId': orderId,
//         'lastActive': DateTime.now().millisecondsSinceEpoch,
//       });
//
//       // Also update the order with delivery boy info
//       await _db.collection('orders').doc(orderId).update({
//         'deliveryBoyId': deliveryBoyId,
//         'status': 'assigned',
//         'assignedAt': firestore.FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception("Failed to assign order: $e");
//     }
//   }
//
//   // Complete delivery and update stats
//   Future<void> completeDelivery(String deliveryBoyId, String orderId) async {
//     try {
//       final deliveryBoyDoc = await _db.collection('deliveryBoys').doc(deliveryBoyId).get();
//       final deliveryBoyData = deliveryBoyDoc.data() as Map<String, dynamic>;
//
//       final currentTotal = deliveryBoyData['totalDeliveries'] ?? 0;
//       final currentCompleted = deliveryBoyData['completedDeliveries'] ?? 0;
//
//       await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
//         'status': 'Available',
//         'currentOrderId': null,
//         'totalDeliveries': currentTotal + 1,
//         'completedDeliveries': currentCompleted + 1,
//         'lastActive': DateTime.now().millisecondsSinceEpoch,
//       });
//
//       // Update order status to delivered
//       await _db.collection('orders').doc(orderId).update({
//         'status': 'delivered',
//         'deliveredAt': firestore.FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception("Failed to complete delivery: $e");
//     }
//   }
//
//   // Delete delivery boy
//   Future<void> deleteDeliveryBoy(String deliveryBoyId) async {
//     try {
//       await _db.collection('deliveryBoys').doc(deliveryBoyId).delete();
//     } catch (e) {
//       throw Exception("Failed to delete delivery boy: $e");
//     }
//   }
//
//   // Upload delivery boy profile image
//   Future<String> uploadDeliveryBoyImage(File file) async {
//     try {
//       final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       final ref = _storage.ref().child('delivery_boys').child(fileName);
//       await ref.putFile(file);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       throw Exception("Delivery boy image upload failed: $e");
//     }
//   }
//
//   // Get orders assigned to a specific delivery boy
//   Stream<List<Order>> getDeliveryBoyOrders(String deliveryBoyId) {
//     return _db
//         .collection('orders')
//         .where('deliveryBoyId', isEqualTo: deliveryBoyId)
//         .where('status', whereIn: ['assigned', 'picked_up', 'on_the_way', 'confirmed', 'preparing'])
//         .snapshots()
//         .map(
//           (snapshot) =>
//           snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
//     );
//   }
//
//   // Get delivery boy performance stats
//   Stream<Map<String, dynamic>> getDeliveryBoyStats(String deliveryBoyId) {
//     return _db
//         .collection('deliveryBoys')
//         .doc(deliveryBoyId)
//         .snapshots()
//         .map((snapshot) {
//       final data = snapshot.data() as Map<String, dynamic>? ?? {};
//       return {
//         'totalDeliveries': data['totalDeliveries'] ?? 0,
//         'completedDeliveries': data['completedDeliveries'] ?? 0,
//         'rating': data['rating'] ?? 0.0,
//         'successRate': data['totalDeliveries'] != null && data['totalDeliveries'] > 0
//             ? ((data['completedDeliveries'] ?? 0) / data['totalDeliveries'] * 100)
//             : 0.0,
//       };
//     });
//   }
//
//   // Update delivery boy rating
//   Future<void> updateDeliveryBoyRating(String deliveryBoyId, double newRating) async {
//     try {
//       final deliveryBoyDoc = await _db.collection('deliveryBoys').doc(deliveryBoyId).get();
//       final deliveryBoyData = deliveryBoyDoc.data() as Map<String, dynamic>;
//
//       final currentRating = deliveryBoyData['rating'] ?? 0.0;
//       final totalRatings = deliveryBoyData['totalRatings'] ?? 0;
//
//       // Calculate new average rating
//       final newAverage = ((currentRating * totalRatings) + newRating) / (totalRatings + 1);
//
//       await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
//         'rating': newAverage,
//         'totalRatings': totalRatings + 1,
//       });
//     } catch (e) {
//       throw Exception("Failed to update rating: $e");
//     }
//   }
//
//   // Get delivery boy by ID
//   Future<DeliveryBoy?> getDeliveryBoyById(String deliveryBoyId) async {
//     try {
//       final doc = await _db.collection('deliveryBoys').doc(deliveryBoyId).get();
//       if (doc.exists) {
//         return DeliveryBoy.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//       }
//       return null;
//     } catch (e) {
//       throw Exception("Failed to get delivery boy: $e");
//     }
//   }
//
//   // Search delivery boys by name or phone
//   Stream<List<DeliveryBoy>> searchDeliveryBoys(String query) {
//     return _db
//         .collection('deliveryBoys')
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//           .map((doc) => DeliveryBoy.fromMap(
//         doc.data() as Map<String, dynamic>,
//         doc.id,
//       ))
//           .where((boy) =>
//       boy.name.toLowerCase().contains(query.toLowerCase()) ||
//           boy.phone.contains(query) ||
//           boy.vehicleNumber.toLowerCase().contains(query.toLowerCase()))
//           .toList(),
//     );
//   }
//
//   // Toggle delivery boy active status
//   Future<void> toggleDeliveryBoyActiveStatus(String deliveryBoyId, bool isActive) async {
//     try {
//       await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
//         'isActive': isActive,
//         'status': isActive ? 'Available' : 'Offline',
//         'lastActive': DateTime.now().millisecondsSinceEpoch,
//       });
//     } catch (e) {
//       throw Exception("Failed to toggle active status: $e");
//     }
//   }
//
//   // Get delivery boy's completed orders history
//   Stream<List<Order>> getDeliveryBoyCompletedOrders(String deliveryBoyId) {
//     return _db
//         .collection('orders')
//         .where('deliveryBoyId', isEqualTo: deliveryBoyId)
//         .where('status', isEqualTo: 'delivered')
//         .orderBy('date', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) =>
//           snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
//     );
//   }
//
//   // Get orders that need delivery assignment
//   Stream<List<Order>> getOrdersNeedingDelivery() {
//     return _db
//         .collection('orders')
//         .where('status', whereIn: ['confirmed', 'ready'])
//         .where('orderType', isEqualTo: 'delivery')
//         .where('deliveryBoyId', isNull: true)
//         .snapshots()
//         .map(
//           (snapshot) =>
//           snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
//     );
//   }
// }


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/food_item.dart';
import '../../models/order_model.dart';
import '../../models/delivery_boy.dart';

class FirestoreService {
  final firestore.FirebaseFirestore _db = firestore.FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ---------------- Orders ----------------
  Stream<List<Order>> getOrders() {
    return _db.collection('orders').snapshots().map(
          (snapshot) =>
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
    );
  }

  Stream<List<Order>> getPendingOrders() {
    return _db
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
    );
  }

  Stream<List<Order>> getCompletedOrders() {
    return _db
        .collection('orders')
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
    );
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _db.collection('orders').doc(orderId).update({'status': newStatus});
  }

  // ---------------- Users ----------------
  Stream<List<Map<String, dynamic>>> getAllUsers() {
    return _db.collection('users').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return data;
      }).toList(),
    );
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
    if (userData['uid'] != null && userData['uid'].toString().isNotEmpty) {
      await _db.collection('users').doc(userData['uid']).set(userData);
    } else {
      await _db.collection('users').add(userData);
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  // ---------------- Food Items ----------------
  Future<String> uploadFoodImage(File file) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('food_images').child(fileName);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }

  Future<void> addFoodItem(FoodItem item) async {
    if (item.id.isEmpty) {
      final docRef = _db.collection('menu').doc();
      await docRef.set(item.toMap());
    } else {
      await _db.collection('menu').doc(item.id).set(item.toMap());
    }
  }

  Future<void> updateFoodItem(String id, Map<String, dynamic> data) async {
    await _db.collection('menu').doc(id).update(data);
  }

  Future<void> deleteFoodItem(String id) async {
    await _db.collection('menu').doc(id).delete();
  }

  Stream<List<FoodItem>> getFoodItems() {
    return _db.collection('menu').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => FoodItem.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      ))
          .toList(),
    );
  }

  Stream<List<FoodItem>> getAvailableFoodItems() {
    return _db
        .collection('menu')
        .where('available', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => FoodItem.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      )).toList(),
    );
  }

  // ---------------- Delivery Boy Management ----------------

  // Get all delivery boys
  Stream<List<DeliveryBoy>> getDeliveryBoys() {
    return _db.collection('deliveryBoys').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => DeliveryBoy.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      ))
          .toList(),
    );
  }

  // Get all delivery boys with ordering
  Stream<List<DeliveryBoy>> getAllDeliveryBoys() {
    return _db.collection('deliveryBoys')
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => DeliveryBoy.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      ))
          .toList(),
    );
  }

  // Get delivery boys by status
  Stream<List<DeliveryBoy>> getDeliveryBoysByStatus(String status) {
    return _db
        .collection('deliveryBoys')
        .where('status', isEqualTo: status)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => DeliveryBoy.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      ))
          .toList(),
    );
  }

  // Get available delivery boys (for order assignment)
  Stream<List<DeliveryBoy>> getAvailableDeliveryBoys() {
    return _db
        .collection('deliveryBoys')
        .where('status', isEqualTo: 'Available')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => DeliveryBoy.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      ))
          .toList(),
    );
  }

  // Add new delivery boy
  Future<void> addDeliveryBoy(DeliveryBoy deliveryBoy) async {
    try {
      await _db.collection('deliveryBoys').doc(deliveryBoy.id).set(deliveryBoy.toMap());
    } catch (e) {
      throw Exception("Failed to add delivery boy: $e");
    }
  }

  // Update delivery boy
  Future<void> updateDeliveryBoy(DeliveryBoy deliveryBoy) async {
    try {
      await _db.collection('deliveryBoys').doc(deliveryBoy.id).update(deliveryBoy.toMap());
    } catch (e) {
      throw Exception("Failed to update delivery boy: $e");
    }
  }

  // Update delivery boy status
  Future<void> updateDeliveryBoyStatus(String deliveryBoyId, String status) async {
    try {
      await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
        'status': status,
        'lastActive': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception("Failed to update delivery boy status: $e");
    }
  }

  // Assign order to delivery boy
  Future<void> assignOrderToDeliveryBoy(String deliveryBoyId, String orderId) async {
    try {
      await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
        'status': 'Busy',
        'currentOrderId': orderId,
        'lastActive': DateTime.now().millisecondsSinceEpoch,
      });

      // Also update the order with delivery boy info
      await _db.collection('orders').doc(orderId).update({
        'deliveryBoyId': deliveryBoyId,
        'status': 'assigned',
        'assignedAt': firestore.FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to assign order: $e");
    }
  }

  // Enhanced assign order with delivery boy details
  Future<void> assignOrderToDeliveryBoyWithDetails(
      String orderId,
      String deliveryBoyId,
      String deliveryBoyName,
      [String? deliveryBoyPhone]
      ) async {
    try {
      final batch = _db.batch();

      // Update order
      final orderRef = _db.collection('orders').doc(orderId);
      batch.update(orderRef, {
        'deliveryBoyId': deliveryBoyId,
        'deliveryBoyName': deliveryBoyName,
        'deliveryBoyPhone': deliveryBoyPhone,
        'status': 'out_for_delivery',
        'assignedAt': firestore.FieldValue.serverTimestamp(),
      });

      // Update delivery boy
      final deliveryBoyRef = _db.collection('deliveryBoys').doc(deliveryBoyId);
      batch.update(deliveryBoyRef, {
        'status': 'Busy',
        'currentOrderId': orderId,
        'lastActive': DateTime.now().millisecondsSinceEpoch,
      });

      await batch.commit();
    } catch (e) {
      throw Exception("Failed to assign order: $e");
    }
  }

  // Complete delivery and update stats
  Future<void> completeDelivery(String deliveryBoyId, String orderId) async {
    try {
      final deliveryBoyDoc = await _db.collection('deliveryBoys').doc(deliveryBoyId).get();
      final deliveryBoyData = deliveryBoyDoc.data() as Map<String, dynamic>;

      final currentTotal = deliveryBoyData['totalDeliveries'] ?? 0;
      final currentCompleted = deliveryBoyData['completedDeliveries'] ?? 0;

      await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
        'status': 'Available',
        'currentOrderId': null,
        'totalDeliveries': currentTotal + 1,
        'completedDeliveries': currentCompleted + 1,
        'lastActive': DateTime.now().millisecondsSinceEpoch,
      });

      // Update order status to delivered
      await _db.collection('orders').doc(orderId).update({
        'status': 'delivered',
        'deliveredAt': firestore.FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to complete delivery: $e");
    }
  }

  // Delete delivery boy
  Future<void> deleteDeliveryBoy(String deliveryBoyId) async {
    try {
      await _db.collection('deliveryBoys').doc(deliveryBoyId).delete();
    } catch (e) {
      throw Exception("Failed to delete delivery boy: $e");
    }
  }

  // Upload delivery boy profile image
  Future<String> uploadDeliveryBoyImage(File file) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('delivery_boys').child(fileName);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Delivery boy image upload failed: $e");
    }
  }

  // Get orders assigned to a specific delivery boy
  Stream<List<Order>> getDeliveryBoyOrders(String deliveryBoyId) {
    return _db
        .collection('orders')
        .where('deliveryBoyId', isEqualTo: deliveryBoyId)
        .where('status', whereIn: ['assigned', 'picked_up', 'on_the_way', 'confirmed', 'preparing', 'out_for_delivery'])
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
    );
  }

  // Get delivery boy performance stats
  Stream<Map<String, dynamic>> getDeliveryBoyStats(String deliveryBoyId) {
    return _db
        .collection('deliveryBoys')
        .doc(deliveryBoyId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>? ?? {};
      return {
        'totalDeliveries': data['totalDeliveries'] ?? 0,
        'completedDeliveries': data['completedDeliveries'] ?? 0,
        'rating': data['rating'] ?? 0.0,
        'successRate': data['totalDeliveries'] != null && data['totalDeliveries'] > 0
            ? ((data['completedDeliveries'] ?? 0) / data['totalDeliveries'] * 100)
            : 0.0,
      };
    });
  }

  // Update delivery boy rating
  Future<void> updateDeliveryBoyRating(String deliveryBoyId, double newRating) async {
    try {
      final deliveryBoyDoc = await _db.collection('deliveryBoys').doc(deliveryBoyId).get();
      final deliveryBoyData = deliveryBoyDoc.data() as Map<String, dynamic>;

      final currentRating = deliveryBoyData['rating'] ?? 0.0;
      final totalRatings = deliveryBoyData['totalRatings'] ?? 0;

      // Calculate new average rating
      final newAverage = ((currentRating * totalRatings) + newRating) / (totalRatings + 1);

      await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
        'rating': newAverage,
        'totalRatings': totalRatings + 1,
      });
    } catch (e) {
      throw Exception("Failed to update rating: $e");
    }
  }

  // Get delivery boy by ID
  Future<DeliveryBoy?> getDeliveryBoyById(String deliveryBoyId) async {
    try {
      final doc = await _db.collection('deliveryBoys').doc(deliveryBoyId).get();
      if (doc.exists) {
        return DeliveryBoy.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to get delivery boy: $e");
    }
  }

  // Search delivery boys by name or phone
  Stream<List<DeliveryBoy>> searchDeliveryBoys(String query) {
    return _db
        .collection('deliveryBoys')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => DeliveryBoy.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      ))
          .where((boy) =>
      boy.name.toLowerCase().contains(query.toLowerCase()) ||
          boy.phone.contains(query) ||
          boy.vehicleNumber.toLowerCase().contains(query.toLowerCase()))
          .toList(),
    );
  }

  // Toggle delivery boy active status
  Future<void> toggleDeliveryBoyActiveStatus(String deliveryBoyId, bool isActive) async {
    try {
      await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
        'isActive': isActive,
        'status': isActive ? 'Available' : 'Offline',
        'lastActive': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception("Failed to toggle active status: $e");
    }
  }

  // Get delivery boy's completed orders history
  Stream<List<Order>> getDeliveryBoyCompletedOrders(String deliveryBoyId) {
    return _db
        .collection('orders')
        .where('deliveryBoyId', isEqualTo: deliveryBoyId)
        .where('status', isEqualTo: 'delivered')
        .orderBy('deliveredAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
    );
  }

  // Get orders that need delivery assignment
  Stream<List<Order>> getOrdersNeedingDelivery() {
    return _db
        .collection('orders')
        .where('status', whereIn: ['confirmed', 'ready'])
        .where('orderType', isEqualTo: 'delivery')
        .where('deliveryBoyId', isNull: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
    );
  }

  // Update order status with tracking
  Future<void> updateOrderStatusWithTracking({
    required String orderId,
    required String status,
    required String deliveryBoyId,
    String? note,
    String? location,
  }) async {
    try {
      final orderRef = _db.collection('orders').doc(orderId);

      // Create tracking entry
      final tracking = {
        'status': status,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'note': note,
        'location': location,
      };

      await orderRef.update({
        'status': status,
        'updatedAt': firestore.FieldValue.serverTimestamp(),
        'trackingHistory': firestore.FieldValue.arrayUnion([tracking]),
      });

      // Update delivery boy status if needed
      if (status == 'out_for_delivery') {
        await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
          'status': 'Busy',
          'currentOrderId': orderId,
          'lastActive': DateTime.now().millisecondsSinceEpoch,
        });
      } else if (status == 'delivered') {
        await _db.collection('deliveryBoys').doc(deliveryBoyId).update({
          'status': 'Available',
          'currentOrderId': null,
          'lastActive': DateTime.now().millisecondsSinceEpoch,
          'completedDeliveries': firestore.FieldValue.increment(1),
          'totalDeliveries': firestore.FieldValue.increment(1),
        });

        // Set delivery date
        await orderRef.update({
          'deliveryDate': firestore.FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception("Failed to update order status: $e");
    }
  }

  // Rate delivery experience
  Future<void> rateDelivery({
    required String orderId,
    required double rating,
    required String feedback,
    required String deliveryBoyId,
  }) async {
    try {
      final batch = _db.batch();

      // Update order with rating
      final orderRef = _db.collection('orders').doc(orderId);
      batch.update(orderRef, {
        'deliveryBoyRating': rating,
        'deliveryBoyFeedback': feedback,
      });

      // Update delivery boy's average rating
      final deliveryBoyRef = _db.collection('deliveryBoys').doc(deliveryBoyId);
      batch.update(deliveryBoyRef, {
        'totalRatings': firestore.FieldValue.increment(1),
        'ratingSum': firestore.FieldValue.increment(rating),
      });

      await batch.commit();
    } catch (e) {
      throw Exception("Failed to rate delivery: $e");
    }
  }

  // Get order by ID
  Stream<Order?> getOrderById(String orderId) {
    return _db
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((snapshot) => snapshot.exists ? Order.fromFirestore(snapshot) : null);
  }

  // Get today's deliveries for delivery boy
  Stream<List<Order>> getTodaysDeliveries(String deliveryBoyId) {
    final startOfDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return _db
        .collection('orders')
        .where('deliveryBoyId', isEqualTo: deliveryBoyId)
        .where('orderDate', isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
    );
  }

  // Get pending orders for admin assignment
  Stream<List<Order>> getPendingOrdersForAssignment() {
    return _db
        .collection('orders')
        .where('status', whereIn: ['confirmed', 'preparing'])
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList(),
    );
  }
}