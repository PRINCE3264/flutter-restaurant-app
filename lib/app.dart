//
// import 'package:flutter/material.dart';
//
// // Admin Screens
// import 'screens/admin/a_dashboard.dart';
// import 'screens/admin/menu/menu_management_screen.dart';
// import 'screens/admin/users/manage_users_screen.dart';
// import 'screens/admin/products/product_list_screen.dart';
// import 'screens/admin/products/add_product_screen.dart';
// import 'screens/services/firestore_service.dart';
//
//
// class MyApp extends StatelessWidget {
//   final FirestoreService firestoreService = FirestoreService();
//
//   MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Restaurant Management',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         scaffoldBackgroundColor: Colors.grey[100],
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.deepPurple,
//           elevation: 0,
//         ),
//         bottomNavigationBarTheme: BottomNavigationBarThemeData(
//           backgroundColor: Colors.blueGrey.shade900,
//           selectedItemColor: Colors.tealAccent,
//           unselectedItemColor: Colors.white70,
//           type: BottomNavigationBarType.fixed,
//         ),
//       ),
//
//       initialRoute: '/',
//
//       routes: {
//         '/': (context) => DashboardScreenss(firestoreService: firestoreService),
//
//         // --- Users ---
//         '/manage-users': (context) =>
//             ManageUsersScreen(firestoreService: firestoreService),
//
//         // --- Products ---
//         '/product-list': (context) =>
//             ProductListScreen(firestoreService: firestoreService),
//         '/add-product': (context) =>
//             AddProductTab(isAdmin: true, currentUserId: 'admin'),
//
//         // --- Menu Management (NEW ROUTE ADDED) ---
//         '/menu-management': (context) =>
//             MenuManagementScreen(isAdmin: true, currentUserId: 'admin',),
//       },
//     );
//   }
// }
//
//


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Admin Screens
import 'models/delivery_boy.dart';
import 'screens/admin/a_dashboard.dart';
import 'screens/admin/menu/menu_management_screen.dart';
import 'screens/admin/users/manage_users_screen.dart';
import 'screens/admin/products/product_list_screen.dart';
import 'screens/admin/products/add_product_screen.dart';
import 'screens/admin/delivery/delivery_boy_list_screen.dart';
import 'screens/admin/delivery/add_edit_delivery_boy_screen.dart';
import 'screens/admin/delivery/delivery_boy_details_screen.dart';
import 'screens/services/firestore_service.dart';

class MyApp extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<FirestoreService>(
      create: (context) => firestoreService,
      child: MaterialApp(
        title: 'Restaurant Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            elevation: 0,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.blueGrey.shade900,
            selectedItemColor: Colors.tealAccent,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
          ),
        ),

        initialRoute: '/',

        routes: {
          '/': (context) => DashboardScreenss(firestoreService: firestoreService),

          // --- Users ---
          '/manage-users': (context) =>
              ManageUsersScreen(firestoreService: firestoreService),

          // --- Products ---
          '/product-list': (context) =>
              ProductListScreen(firestoreService: firestoreService),
          '/add-product': (context) =>
              AddProductTab(isAdmin: true, currentUserId: 'admin'),

          // --- Menu Management ---
          '/menu-management': (context) =>
              MenuManagementScreen(isAdmin: true, currentUserId: 'admin'),

          // --- Delivery Management ---
          '/delivery-management': (context) => const DeliveryBoyListScreen(),
          '/add-delivery-boy': (context) => const AddEditDeliveryBoyScreen(),
          '/edit-delivery-boy': (context) {
            final deliveryBoy = ModalRoute.of(context)!.settings.arguments as DeliveryBoy?;
            return AddEditDeliveryBoyScreen(deliveryBoy: deliveryBoy);
          },
          '/delivery-boy-details': (context) {
            final deliveryBoy = ModalRoute.of(context)!.settings.arguments as DeliveryBoy;
            return DeliveryBoyDetailsScreen(deliveryBoy: deliveryBoy);
          },
        },

        // Fallback for named routes with arguments
        onGenerateRoute: (settings) {
          // Handle delivery boy edit route
          if (settings.name == '/edit-delivery-boy') {
            final deliveryBoy = settings.arguments as DeliveryBoy?;
            return MaterialPageRoute(
              builder: (context) => AddEditDeliveryBoyScreen(deliveryBoy: deliveryBoy),
            );
          }

          // Handle delivery boy details route
          if (settings.name == '/delivery-boy-details') {
            final deliveryBoy = settings.arguments as DeliveryBoy;
            return MaterialPageRoute(
              builder: (context) => DeliveryBoyDetailsScreen(deliveryBoy: deliveryBoy),
            );
          }

          return null;
        },

        // Fallback for unknown routes
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('Page not found'),
              ),
            ),
          );
        },
      ),
    );
  }
}