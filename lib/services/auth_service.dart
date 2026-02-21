
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔹 Signup with email & password
  Future<User?> signup(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// 🔹 Login with email & password
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// 🔹 Phone number login (send OTP)
  Future<void> loginWithPhone(
      String phoneNumber,
      Function(String verificationId) codeSent,
      ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification (instant login if SIM present)
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// 🔹 Verify OTP
  Future<User?> verifyOtp(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// 🔹 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// 🔹 Get current logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// 🔹 Listen to auth state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}

//
//
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   /// Logged-in user role (user/admin)
//   String userRole = 'user';
//
//   /// 🔹 Login with email & password
//   Future<User?> login(String email, String password) async {
//     try {
//       // Sign in with Firebase Auth
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       final uid = userCredential.user?.uid;
//       if (uid == null) throw Exception('User ID not found.');
//
//       // Fetch role from Firestore
//       final userDoc = await _firestore.collection('users').doc(uid).get();
//       if (!userDoc.exists) throw Exception('User data not found in Firestore.');
//
//       final role = userDoc.data()?['role'] ?? 'user';
//       userRole = role; // store role for navigation
//
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.message ?? 'Login failed');
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   /// 🔹 Logout
//   Future<void> logout() async {
//     await _auth.signOut();
//     userRole = 'user';
//   }
//
//   /// 🔹 Get current logged-in user
//   User? getCurrentUser() => _auth.currentUser;
//
//   /// 🔹 Listen to auth state changes
//   Stream<User?> authStateChanges() => _auth.authStateChanges();
// }
