// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/wallet_transaction.dart';
//
// class WalletProvider extends ChangeNotifier {
//   // ---------------- User ----------------
//   String _userId = '';
//   String get userId => _userId;
//
//   // ---------------- Wallet balance ----------------
//   double _balance = 0.0;
//   double get balance => _balance;
//
//   // ---------------- Loading state ----------------
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   // ---------------- Transactions ----------------
//   List<WalletTransaction> _transactions = [];
//   List<WalletTransaction> get transactions => _transactions;
//
//   // ---------------- Update userId ----------------
//   void updateUserId(String userId) {
//     _userId = userId;
//     _balance = 0;
//     _transactions.clear();
//     notifyListeners();
//   }
//
//   // ---------------- Get current user ID ----------------
//   String _getCurrentUserId() {
//     if (_userId.isNotEmpty) return _userId;
//
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       _userId = user.uid;
//       return _userId;
//     }
//     throw Exception('User not logged in');
//   }
//
//   // ---------------- Fetch wallet ----------------
//   Future<void> fetchWallet() async {
//     final uid = _getCurrentUserId(); // Ensure user is logged in
//
//     _isLoading = true;
//     notifyListeners();
//
//     await Future.delayed(const Duration(seconds: 1)); // Mock API call or fetch from Firebase
//
//     // For now, keep existing balance and transactions
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   // ---------------- Top-up wallet ----------------
//   Future<void> topUp(double amount, {String description = 'Wallet Top-up'}) async {
//     final uid = _getCurrentUserId();
//
//     _balance += amount;
//     _transactions.insert(
//       0,
//       WalletTransaction(
//         id: DateTime.now().millisecondsSinceEpoch.toString(), // unique ID
//         type: 'credit',
//         amount: amount,
//         description: description,
//         date: DateTime.now(),
//       ),
//     );
//     notifyListeners();
//   }
//
//   // ---------------- Debit wallet ----------------
//   Future<void> debit(double amount, String description) async {
//     final uid = _getCurrentUserId();
//
//     if (amount > _balance) throw Exception('Insufficient balance');
//
//     _balance -= amount;
//     _transactions.insert(
//       0,
//       WalletTransaction(
//         id: DateTime.now().millisecondsSinceEpoch.toString(), // unique ID
//         type: 'debit',
//         amount: amount,
//         description: description,
//         date: DateTime.now(),
//       ),
//     );
//     notifyListeners();
//   }
//
//   // ---------------- Reset wallet (optional) ----------------
//   void resetWallet() {
//     _balance = 0;
//     _transactions.clear();
//     _userId = '';
//     notifyListeners();
//   }
// }
//
//


//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/wallet_transaction.dart';
//
// class WalletProvider extends ChangeNotifier {
//   double _balance = 0.0;
//   double get balance => _balance;
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   List<WalletTransaction> _transactions = [];
//   List<WalletTransaction> get transactions => _transactions;
//
//   String _userId = '';
//   String get userId => _userId;
//
//   // ---------------- Update user ID safely ----------------
//   void updateUserId(String? uid) {
//     if (uid != null && uid.isNotEmpty) {
//       _userId = uid;
//       notifyListeners();
//     }
//   }
//
//   // ---------------- Fetch wallet data ----------------
//   Future<void> fetchWallet() async {
//     if (_userId.isEmpty) {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return; // user not logged in
//       _userId = user.uid;
//     }
//
//     _isLoading = true;
//     notifyListeners();
//
//     await Future.delayed(const Duration(seconds: 1)); // Mock fetch
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   // ---------------- Top-up wallet ----------------
//   Future<void> topUp(double amount, {String description = 'Wallet Top-up'}) async {
//     _balance += amount;
//     _transactions.insert(
//       0,
//       WalletTransaction(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         type: 'credit',
//         amount: amount,
//         description: description,
//         date: DateTime.now(),
//       ),
//     );
//     notifyListeners();
//   }
//
//   // ---------------- Debit wallet ----------------
//   Future<void> debit(double amount, String description) async {
//     if (amount > _balance) throw Exception('Insufficient balance');
//     _balance -= amount;
//     _transactions.insert(
//       0,
//       WalletTransaction(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         type: 'debit',
//         amount: amount,
//         description: description,
//         date: DateTime.now(),
//       ),
//     );
//     notifyListeners();
//   }
// }


//work
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletTransaction {
  final String id;
  final String type; // 'credit' or 'debit'
  final double amount;
  final String description;
  final DateTime date;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'amount': amount,
    'description': description,
    'date': date.toIso8601String(),
  };

  factory WalletTransaction.fromMap(Map<String, dynamic> map) => WalletTransaction(
    id: map['id'],
    type: map['type'],
    amount: map['amount'],
    description: map['description'],
    date: DateTime.parse(map['date']),
  );
}

class WalletProvider extends ChangeNotifier {
  double _balance = 0.0;
  double get balance => _balance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<WalletTransaction> _transactions = [];
  List<WalletTransaction> get transactions => _transactions;

  String _userId = '';
  String get userId => _userId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateUserId(String? uid) {
    if (uid != null && uid.isNotEmpty) {
      _userId = uid;
      notifyListeners();
    }
  }

  Future<void> fetchWallet() async {
    if (_userId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    final doc = await _firestore.collection('wallets').doc(_userId).get();
    if (doc.exists) {
      _balance = doc['balance']?.toDouble() ?? 0.0;

      final txSnapshot =
      await _firestore.collection('wallets').doc(_userId).collection('transactions').orderBy('date', descending: true).get();

      _transactions = txSnapshot.docs.map((e) => WalletTransaction.fromMap(e.data())).toList();
    } else {
      _balance = 0.0;
      _transactions = [];
      await _firestore.collection('wallets').doc(_userId).set({'balance': 0.0});
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> topUp(double amount, {String description = 'Wallet Top-up via Razorpay'}) async {
    if (_userId.isEmpty) return;

    final tx = WalletTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'credit',
      amount: amount,
      description: description,
      date: DateTime.now(),
    );

    _balance += amount;
    _transactions.insert(0, tx);
    notifyListeners();

    // Save to Firestore
    await _firestore.collection('wallets').doc(_userId).update({'balance': _balance});
    await _firestore.collection('wallets').doc(_userId).collection('transactions').doc(tx.id).set(tx.toMap());
  }

  Future<void> debit(double amount, String description) async {
    if (_userId.isEmpty) return;
    if (amount > _balance) throw Exception('Insufficient balance');

    final tx = WalletTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'debit',
      amount: amount,
      description: description,
      date: DateTime.now(),
    );

    _balance -= amount;
    _transactions.insert(0, tx);
    notifyListeners();

    // Save to Firestore
    await _firestore.collection('wallets').doc(_userId).update({'balance': _balance});
    await _firestore.collection('wallets').doc(_userId).collection('transactions').doc(tx.id).set(tx.toMap());
  }
}


