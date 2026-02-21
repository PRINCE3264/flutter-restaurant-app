import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_item.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final List<FoodItem> _cartItems = [];
  final _uuid = const Uuid();
  final FirebaseFirestore _firestore;
  final bool persistToFirestore;

  String? _userId;

  // ✅ Public getter
  String? get userId => _userId;

  CartProvider({FirebaseFirestore? firestore, this.persistToFirestore = true})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ---------------- User ID ----------------
  void updateUserId(String? userId) {
    _userId = userId;
    debugPrint('🔑 CartProvider: User ID updated: $_userId');

    if (_userId != null && _userId!.isNotEmpty) {
      loadCartFromFirestore(_userId!);
    } else {
      clearLocalCart();
    }
  }

  // ---------------- Cart Info ----------------
  List<FoodItem> get cartItems => List.unmodifiable(_cartItems);

  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += ((item.price ?? 0) - (item.discount ?? 0)) * (item.quantity ?? 1);
    }
    return total;
  }

  int get totalItems {
    int total = 0;
    for (var item in _cartItems) {
      total += item.quantity ?? 1;
    }
    return total;
  }

  // ---------------- Cart Operations ----------------
  Future<void> addToCart(FoodItem item, [String? userId]) async {
    final uid = userId ?? _userId;
    if (uid == null || uid.isEmpty) return;

    final index = _cartItems.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      _cartItems[index].quantity = (_cartItems[index].quantity ?? 0) + 1;
    } else {
      _cartItems.add(FoodItem(
        id: item.id.isNotEmpty ? item.id : _uuid.v4(),
        name: item.name ?? '',
        description: item.description ?? '',
        image: item.image ?? '',
        price: item.price ?? 0,
        quantity: 1,
        discount: item.discount ?? 0,
        available: item.available ?? true,
        rating: item.rating ?? 0,
        vendorId: item.vendorId ?? '',
        vendorName: item.vendorName ?? '',
      ));
    }

    if (persistToFirestore) await _saveCartToFirestore(uid);
    notifyListeners();
  }

  Future<void> decreaseQuantity(FoodItem item, [String? userId]) async {
    final uid = userId ?? _userId;
    if (uid == null || uid.isEmpty) return;

    final index = _cartItems.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      if ((_cartItems[index].quantity ?? 0) > 1) {
        _cartItems[index].quantity = (_cartItems[index].quantity ?? 0) - 1;
      } else {
        _cartItems.removeAt(index);
      }
      if (persistToFirestore) await _saveCartToFirestore(uid);
      notifyListeners();
    }
  }

  Future<void> removeItem(FoodItem item, [String? userId]) async {
    final uid = userId ?? _userId;
    if (uid == null || uid.isEmpty) return;

    _cartItems.removeWhere((i) => i.id == item.id);
    if (persistToFirestore) await _saveCartToFirestore(uid);
    notifyListeners();
  }

  Future<void> clearCart([String? userId]) async {
    final uid = userId ?? _userId;
    _cartItems.clear();

    if (persistToFirestore && uid != null && uid.isNotEmpty) {
      final cartRef = _firestore.collection('users').doc(uid).collection('cart');
      final snapshot = await cartRef.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // ---------------- Firestore Persistence ----------------
  Future<void> loadCartFromFirestore(String userId) async {
    if (!persistToFirestore || userId.isEmpty) return;

    try {
      final cartRef = _firestore.collection('users').doc(userId).collection('cart');
      final snapshot = await cartRef.get();

      _cartItems.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        _cartItems.add(FoodItem(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          image: data['image'] ?? '',
          price: (data['price'] as num?)?.toDouble() ?? 0,
          discount: (data['discount'] as num?)?.toDouble() ?? 0,
          quantity: data['quantity'] ?? 1,
          available: data['available'] ?? true,
          rating: (data['rating'] as num?)?.toDouble() ?? 0,
          vendorId: data['vendorId'] ?? '',
          vendorName: data['vendorName'] ?? '',
        ));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading cart from Firestore: $e');
    }
  }

  Future<void> _saveCartToFirestore(String userId) async {
    if (userId.isEmpty) return;

    try {
      final cartRef = _firestore.collection('users').doc(userId).collection('cart');

      // Delete old docs
      final snapshot = await cartRef.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Add current cart
      for (var item in _cartItems) {
        await cartRef.doc(item.id).set({
          'id': item.id,
          'name': item.name,
          'description': item.description,
          'image': item.image,
          'price': item.price,
          'discount': item.discount,
          'quantity': item.quantity,
          'available': item.available,
          'rating': item.rating,
          'vendorId': item.vendorId,
          'vendorName': item.vendorName,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('❌ Error saving cart to Firestore: $e');
    }
  }

  // ---------------- Place Order ----------------
  Future<String> placeOrder({
    String? userId,
    required double currentWalletBalance,
    double fuelCharge = 20,
  }) async {
    final uid = userId ?? _userId;
    if (_cartItems.isEmpty || uid == null || uid.isEmpty) return '';

    final totalAmount = totalPrice + fuelCharge;
    final amountFromWallet =
    currentWalletBalance >= totalAmount ? totalAmount : currentWalletBalance;
    final amountToPayOnline = totalAmount - amountFromWallet;

    // Deduct wallet safely
    if (amountFromWallet > 0) {
      final walletRef = _firestore.collection('wallets').doc(uid);
      await walletRef.set({
        'balance': FieldValue.increment(-amountFromWallet),
        'transactions': FieldValue.arrayUnion([
          {
            'type': 'debit',
            'amount': amountFromWallet,
            'description': 'Order Payment',
            'date': FieldValue.serverTimestamp(),
          }
        ])
      }, SetOptions(merge: true));
    }

    // Prepare order items
    final orderItems = _cartItems.map((item) => {
      'id': item.id,
      'name': item.name,
      'price': item.price,
      'discount': item.discount,
      'quantity': item.quantity,
      'image': item.image,
      'vendorId': item.vendorId,
      'vendorName': item.vendorName,
      'finalPrice': (item.price ?? 0) - (item.discount ?? 0),
      'totalItemPrice':
      ((item.price ?? 0) - (item.discount ?? 0)) * (item.quantity ?? 0),
    }).toList();

    final orderDoc = _firestore.collection('orders').doc();
    await orderDoc.set({
      'orderId': orderDoc.id,
      'userId': uid,
      'items': orderItems,
      'totalPrice': totalPrice,
      'fuelCharge': fuelCharge,
      'finalTotal': totalAmount,
      'amountPaidFromWallet': amountFromWallet,
      'amountToPayOnline': amountToPayOnline,
      'totalItems': totalItems,
      'status': 'Placed',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await clearCart(uid);
    return orderDoc.id;
  }
}

