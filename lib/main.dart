// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:uuid/uuid.dart';
//
// // Screens
// import 'order/notifications_screen.dart';
// import 'order/offer_screen.dart';
// import 'order/order.dart';
// import 'order/order_tracking_screen.dart';
// import 'order/pickup_slot_screen.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/signup_screen.dart';
// import 'screens/admin/admin_dashboard.dart';
// import 'screens/dashboard/dashboard_screen.dart';
// import 'screens/camera/camere_screen.dart';
// import 'screens/card/cart_screen.dart';
// import 'screens/favorites/favorites_screen.dart';
// import 'screens/screens/menu/menu_screen.dart';
// import 'screens/screens/vendor/vendor_list_screen.dart';
// import 'screens/services/firestore_service.dart';
// import 'screens/wallet/wallet_screen.dart';
// import 'screens/auth/otp_verification_screen.dart';
//
//
//
// // Providers
// import 'providers/auth_provider.dart' as app_auth;
// import 'providers/cart_provider.dart';
// import 'providers/wallet_provider.dart';
// import 'screens/screens/providers/vendor_provider.dart';
//
// // Firebase options
// import 'firebase_options.dart';
// import 'auth_wrapper.dart';
//
// /// ------------------ Theme Provider ------------------
// class ThemeProvider extends ChangeNotifier {
//   bool isDarkMode = false;
//
//   void toggleTheme() {
//     isDarkMode = !isDarkMode;
//     notifyListeners();
//   }
//
//   ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;
// }
//
// /// ------------------ Main ------------------
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
//         ChangeNotifierProvider(create: (_) => CartProvider()),
//         ChangeNotifierProvider(create: (_) => VendorProvider()),
//         ChangeNotifierProvider(create: (_) => WalletProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         Provider<FirestoreService>(create: (_) => FirestoreService()), // Add this line
//       ],
//       child: const RestaurantApp(),
//     ),
//   );
// }
//
// /// ------------------ RestaurantApp ------------------
// class RestaurantApp extends StatefulWidget {
//   const RestaurantApp({super.key});
//
//   @override
//   State<RestaurantApp> createState() => _RestaurantAppState();
// }
//
// class _RestaurantAppState extends State<RestaurantApp> {
//   late final FirebaseAuth _auth;
//
//   @override
//   void initState() {
//     super.initState();
//     _auth = FirebaseAuth.instance;
//
//     // Listen to authentication changes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final cartProvider = Provider.of<CartProvider>(context, listen: false);
//       final walletProvider = Provider.of<WalletProvider>(context, listen: false);
//
//       _auth.authStateChanges().listen((User? user) async {
//         if (!mounted) return;
//
//         if (user != null) {
//           final userId = user.uid;
//           debugPrint("🔄 Auth State Changed — Current UserId: $userId");
//
//           cartProvider.updateUserId(userId);
//           walletProvider.updateUserId(userId);
//
//           try {
//             await cartProvider.loadCartFromFirestore(userId);
//           } catch (e) {
//             debugPrint('⚠️ Error loading cart: $e');
//           }
//
//           try {
//             await walletProvider.fetchWallet();
//           } catch (e) {
//             debugPrint('⚠️ Error loading wallet: $e');
//           }
//         } else {
//           cartProvider.clearLocalCart();
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//     // ✅ Define custom theme with AppBar styling
//     final lightTheme = ThemeData(
//       brightness: Brightness.light,
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Color(0xFFE0F7FA),
//         iconTheme: IconThemeData(color: Colors.black),
//         titleTextStyle: TextStyle(
//           color: Colors.black,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//
//     final darkTheme = ThemeData(
//       brightness: Brightness.dark,
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Color(0xFF121212),
//         iconTheme: IconThemeData(color: Colors.white),
//         titleTextStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Restaurant Management',
//       theme: lightTheme,
//       darkTheme: darkTheme,
//       themeMode: themeProvider.currentTheme,
//       home: const AuthWrapper(),
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/signup': (context) => const SignupScreen(),
//         '/admin-dashboard': (context) => const AdminDashboard(),
//         '/dashboard': (context) => const DashboardScreen(),
//         '/camera': (context) => const CameraScreen(),
//         '/cart': (context) => const CartScreen(),
//         '/vendors': (context) => const VendorListScreen(),
//         '/menu': (context) => const MenuScreen(),
//         '/offers': (context) => const OfferScreen(),
//         '/favorites': (context) => FavoritesScreen(
//           userId: FirebaseAuth.instance.currentUser?.uid ?? '',
//         ),
//         '/pickup-slots': (context) => const PickupSlotBookingScreen(),
//         '/order-tracking': (context) => const OrderTrackingScreen(),
//
//         // ✅ Added Notification Route
//         '/notifications': (context) => const NotificationsScreen(),
//       },
//       onGenerateRoute: (settings) {
//         final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//
//         if (settings.name == '/wallet') {
//           if (userId.isEmpty) return null;
//
//           final args = settings.arguments as Map<String, dynamic>? ?? {};
//           final orderId = args['orderId'] ?? const Uuid().v4();
//           final amount = args['amount'] ?? 0.0;
//
//           return MaterialPageRoute(
//             builder: (context) => WalletScreen(
//               userId: userId,
//               orderId: orderId,
//               amount: amount,
//             ),
//           );
//         }
//
//         if (settings.name == '/order') {
//           return MaterialPageRoute(
//             builder: (context) => OrderPage(userId: userId),
//           );
//         }
//
//         if (settings.name == '/otp') {
//           final args = settings.arguments as Map<String, dynamic>? ?? {};
//           return MaterialPageRoute(
//             builder: (context) => OTPVerificationScreen(
//               email: args['email'] ?? '',
//               userId: args['userId'] ?? '',
//             ),
//           );
//         }
//
//         return null;
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurent_management/services/notification_service.dart';
import 'package:uuid/uuid.dart';

// Screens
import 'order/notifications_screen.dart';
import 'order/offer_screen.dart';
import 'order/order.dart';
import 'order/order_tracking_screen.dart';
import 'order/pickup_slot_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/camera/camere_screen.dart';
import 'screens/card/cart_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/screens/menu/menu_screen.dart';
import 'screens/screens/vendor/vendor_list_screen.dart';
import 'screens/services/firestore_service.dart';
import 'screens/wallet/wallet_screen.dart';
import 'screens/auth/otp_verification_screen.dart';

// Providers
import 'providers/auth_provider.dart' as app_auth;
import 'providers/cart_provider.dart';
import 'providers/wallet_provider.dart';
import 'screens/screens/providers/vendor_provider.dart';
import 'utils/order_notification_helper.dart';

// Firebase options
import 'firebase_options.dart';
import 'auth_wrapper.dart';
import 'utils/order_notification_helper.dart';

/// ------------------ Theme Provider ------------------
class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;
}

/// ------------------ Main ------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        //Provider<OrderNotificationHelper>(create: (_) => OrderNotificationHelper()), // Add this line
        // 🔥 THIS WAS MISSING (VERY IMPORTANT)
        Provider<NotificationService>(
          create: (_) => NotificationService()..initialize(),
        ),

      ],
      child: const RestaurantApp(),
    ),
  );
}

/// ------------------ RestaurantApp ------------------
class RestaurantApp extends StatefulWidget {
  const RestaurantApp({super.key});

  @override
  State<RestaurantApp> createState() => _RestaurantAppState();
}

class _RestaurantAppState extends State<RestaurantApp> {
  late final FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _initializeApp();
  }

  void _initializeApp() {
    // Listen to authentication changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      final notificationHelper = Provider.of<OrderNotificationHelper>(context, listen: false);

      _auth.authStateChanges().listen((User? user) async {
        if (!mounted) return;

        if (user != null) {
          final userId = user.uid;
          debugPrint("🔄 Auth State Changed — Current UserId: $userId");

          // Update providers with user ID
          cartProvider.updateUserId(userId);
          walletProvider.updateUserId(userId);

          try {
            await cartProvider.loadCartFromFirestore(userId);
          } catch (e) {
            debugPrint('⚠️ Error loading cart: $e');
          }

          try {
            await walletProvider.fetchWallet();
          } catch (e) {
            debugPrint('⚠️ Error loading wallet: $e');
          }

          try {
            // Save FCM token for notifications
            await notificationHelper.saveFCMToken(userId);
          } catch (e) {
            debugPrint('⚠️ Error saving FCM token: $e');
          }
        } else {
          cartProvider.clearLocalCart();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // ✅ Define custom theme with AppBar styling
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFE0F7FA),
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      scaffoldBackgroundColor: Colors.grey[900],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Management',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.currentTheme,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/admin-dashboard': (context) => const AdminDashboard(),
        '/dashboard': (context) => const DashboardScreen(),
        '/camera': (context) => const CameraScreen(),
        '/cart': (context) => const CartScreen(),
        '/vendors': (context) => const VendorListScreen(),
        '/menu': (context) => const MenuScreen(),
        '/offers': (context) => const OfferScreen(),
        '/favorites': (context) => FavoritesScreen(
          userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        ),
        '/pickup-slots': (context) => const PickupSlotBookingScreen(),
        '/order-tracking': (context) => const OrderTrackingScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
      onGenerateRoute: (settings) {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

        if (settings.name == '/wallet') {
          if (userId.isEmpty) {
            // Redirect to login if no user
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          }

          final args = settings.arguments as Map<String, dynamic>? ?? {};
          final orderId = args['orderId'] ?? const Uuid().v4();
          final amount = args['amount'] ?? 0.0;

          return MaterialPageRoute(
            builder: (context) => WalletScreen(
              userId: userId,
              orderId: orderId,
              amount: amount,
            ),
          );
        }

        if (settings.name == '/order') {
          if (userId.isEmpty) {
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          }
          return MaterialPageRoute(
            builder: (context) => OrderPage(userId: userId),
          );
        }

        if (settings.name == '/otp') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              email: args['email'] ?? '',
              userId: args['userId'] ?? '',
            ),
          );
        }

        // Handle unknown routes
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Page not found')),
          ),
        );
      },
    );
  }
}