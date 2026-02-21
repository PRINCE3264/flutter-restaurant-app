//
//
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'cart_provider.dart';
// import 'wallet_provider.dart';
//
// /// User roles in the app
// enum UserRole { admin, staff, chef }
//
// /// AuthProvider to manage user authentication state
// class AuthProvider extends ChangeNotifier {
//   // ---------------------------
//   // STATE
//   // ---------------------------
//   bool _isLoggedIn = false;
//   bool get isLoggedIn => _isLoggedIn;
//
//   UserRole? _userRole;
//   UserRole? get userRole => _userRole;
//
//   String _email = '';
//   String get email => _email;
//
//   String? _userId;
//   String? get userId => _userId;
//
//   String _generatedOtp = '';
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // ---------------------------
//   // SIGNUP (Firebase)
//   // ---------------------------
//   Future<void> signup(
//       String email,
//       String password,
//       BuildContext context,
//       ) async {
//     try {
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       _email = email;
//       _userId = userCredential.user?.uid;
//       _isLoggedIn = true;
//       _userRole = UserRole.staff; // default role
//
//       // Update providers that need userId
//       context.read<CartProvider>().updateUserId(_userId!);
//       context.read<WalletProvider>().updateUserId(_userId!);
//
//       debugPrint('✅ Signup success for $email (uid: $_userId)');
//       notifyListeners();
//     } catch (e) {
//       debugPrint('❌ Signup failed: $e');
//       rethrow;
//     }
//   }
//
//   // ---------------------------
//   // LOGIN (Firebase)
//   // ---------------------------
//   Future<bool> login(
//       String email,
//       String password,
//       BuildContext context,
//       ) async {
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       _isLoggedIn = true;
//       _email = email;
//       _userId = userCredential.user?.uid;
//
//       // Assign role based on email keywords
//       final lowerEmail = email.toLowerCase();
//       if (lowerEmail.contains('admin')) {
//         _userRole = UserRole.admin;
//       } else if (lowerEmail.contains('chef')) {
//         _userRole = UserRole.chef;
//       } else {
//         _userRole = UserRole.staff;
//       }
//
//       // 🔥 Update Cart + Wallet providers with Firebase userId
//       if (_userId != null) {
//         context.read<CartProvider>().updateUserId(_userId!);
//         context.read<WalletProvider>().updateUserId(_userId!);
//         debugPrint('✅ Providers updated with userId: $_userId');
//       }
//
//       debugPrint('✅ Login success for $email as $_userRole');
//       notifyListeners();
//       return true;
//     } catch (e) {
//       debugPrint('❌ Login failed: $e');
//       return false;
//     }
//   }
//
//   // ---------------------------
//   // LOGOUT
//   // ---------------------------
//   Future<void> logout(BuildContext context) async {
//     await _auth.signOut();
//     _isLoggedIn = false;
//     _userRole = null;
//     _email = '';
//     _userId = null;
//     _generatedOtp = '';
//
//     context.read<CartProvider>().updateUserId('');
//     context.read<WalletProvider>().updateUserId('');
//
//     debugPrint('👋 User logged out');
//     notifyListeners();
//   }
//
//   // ---------------------------
//   // OTP (Optional demo)
//   // ---------------------------
//   String _generateOtp() {
//     final random = Random();
//     return (100000 + random.nextInt(900000)).toString();
//   }
// }
//

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'wallet_provider.dart';

/// User roles in the app
enum UserRole { admin, staff, chef }

/// AuthProvider to manage user authentication state
class AuthProvider extends ChangeNotifier {
  // ---------------------------
  // STATE
  // ---------------------------
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  UserRole? _userRole;
  UserRole? get userRole => _userRole;

  String _email = '';
  String get email => _email;

  String? _userId;
  String? get userId => _userId;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  get currentUser => null;

  // ---------------------------
  // SIGNUP (Firebase)
  // ---------------------------
  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _email = email;
      _userId = userCredential.user?.uid;
      _isLoggedIn = true;
      _userRole = UserRole.staff; // default role

      // Update Cart + Wallet providers
      if (_userId != null) {
        context.read<CartProvider>().updateUserId(_userId!);
        context.read<WalletProvider>().updateUserId(_userId!);
      }

      debugPrint('✅ Signup success for $email (uid: $_userId)');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Signup failed: $e');
      rethrow;
    }
  }

  // ---------------------------
  // LOGIN (Firebase)
  // ---------------------------
  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isLoggedIn = true;
      _email = email;
      _userId = userCredential.user?.uid;

      // Assign role based on email keywords
      final lowerEmail = email.toLowerCase();
      if (lowerEmail.contains('admin')) {
        _userRole = UserRole.admin;
      } else if (lowerEmail.contains('chef')) {
        _userRole = UserRole.chef;
      } else {
        _userRole = UserRole.staff;
      }

      // Update Cart + Wallet providers
      if (_userId != null) {
        context.read<CartProvider>().updateUserId(_userId!);
        context.read<WalletProvider>().updateUserId(_userId!);
        debugPrint('✅ Providers updated with userId: $_userId');
      }

      debugPrint('✅ Login success for $email as $_userRole');
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Login failed: $e');
      return false;
    }
  }

  // ---------------------------
  // LOGOUT
  // ---------------------------
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    _isLoggedIn = false;
    _userRole = null;
    _email = '';
    _userId = null;

    context.read<CartProvider>().updateUserId('');
    context.read<WalletProvider>().updateUserId('');

    debugPrint('👋 User logged out');
    notifyListeners();
  }

  // ---------------------------
  // CHECK CURRENT USER
  // ---------------------------
  void checkCurrentUser(BuildContext context) {
    final user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
      _isLoggedIn = true;

      context.read<CartProvider>().updateUserId(_userId!);
      context.read<WalletProvider>().updateUserId(_userId!);

      debugPrint('🔑 Current user found: $_userId');
    } else {
      _userId = null;
      _isLoggedIn = false;
      debugPrint('❌ No user logged in');
    }

    notifyListeners();
  }

  // ---------------------------
  // OTP (Optional demo)
  // ---------------------------
  String generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }
}



