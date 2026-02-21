//
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'screens/dashboard/dashboard_screen.dart';
// import 'screens/auth/login_screen.dart';
//
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         final user = snapshot.data;
//
//         if (user != null) {
//           // ✅ User is signed in, go to Dashboard
//           return const DashboardScreen();
//         } else {
//           // ✅ No user signed in, show Login
//           return const LoginScreen();
//         }
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/auth/login_screen.dart';

/// AuthWrapper decides which screen to show based on FirebaseAuth state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to authentication state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While waiting for Firebase response
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If there is an error
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Something went wrong!")),
          );
        }

        final user = snapshot.data;

        // ✅ User is logged in
        if (user != null) {
          return const DashboardScreen();
        }

        // ❌ User not logged in
        return const LoginScreen();
      },
    );
  }
}
