// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:restaurent_management/order/order.dart';
// //
// // // Services
// // import '../../services/firestore_service.dart';
// //
// // // Screens
// // import '../services/firestore_service.dart';
// // import 'a_dashboard.dart';
// // import 'menu/menu_management_screen.dart';
// // import 'order/view_orders_screen.dart';
// // import 'orders/orders_list_screen.dart';
// // import 'products/add_product_screen.dart';
// // import 'products/product_list_screen.dart';
// // import 'users/manage_users_screen.dart';
// // import '../auth/login_screen.dart';
// //
// // class AdminDashboard extends StatefulWidget {
// //   const AdminDashboard({super.key});
// //
// //   @override
// //   State<AdminDashboard> createState() => _AdminDashboardState();
// // }
// //
// // class _AdminDashboardState extends State<AdminDashboard>
// //     with SingleTickerProviderStateMixin {
// //   final FirestoreService _firestoreService = FirestoreService();
// //
// //   int _selectedIndex = 0;
// //   late AnimationController _controller;
// //   late Animation<double> _fadeAnimation;
// //   late Animation<double> _scaleAnimation;
// //
// //   final List<Map<String, dynamic>> _drawerItems = [
// //     {'icon': Icons.dashboard, 'title': 'Dashboard', 'index': 0},
// //     {'icon': Icons.group, 'title': 'Manage Users', 'index': 1},
// //     {'icon': Icons.shopping_cart, 'title': 'View Orders', 'index': 2},
// //     {'icon': Icons.list, 'title': 'Product List', 'index': 3},
// //     {'icon': Icons.add_box, 'title': 'Add Product', 'index': 4},
// //     {'icon': Icons.restaurant_menu, 'title': 'Menu Management', 'index': 5},
// //     {'icon': Icons.person, 'title': 'Profile', 'index': 6},
// //     {'icon': Icons.logout, 'title': 'Logout', 'index': 7, 'color': Colors.red},
// //   ];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 600),
// //     );
// //     _fadeAnimation = CurvedAnimation(
// //       parent: _controller,
// //       curve: Curves.easeInOut,
// //     );
// //     _scaleAnimation = CurvedAnimation(
// //       parent: _controller,
// //       curve: Curves.elasticOut,
// //     );
// //     _controller.forward();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _logout() async {
// //     await FirebaseAuth.instance.signOut();
// //     if (!mounted) return;
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (context) => const LoginScreen()),
// //     );
// //   }
// //
// //   void _onDrawerItemTapped(int index) {
// //     Navigator.pop(context);
// //     if (index == 7) {
// //       _logout();
// //     } else {
// //       _controller.forward(from: 0.0);
// //       setState(() => _selectedIndex = index);
// //     }
// //   }
// //
// //   void _onBottomNavTapped(int index) {
// //     setState(() {
// //       if (index == 0) _selectedIndex = 0;
// //       if (index == 1) _selectedIndex = 2;
// //       if (index == 2) _selectedIndex = 3;
// //       if (index == 3) _selectedIndex = 6;
// //     });
// //   }
// //
// //   Widget _getScreen(int index) {
// //     switch (index) {
// //       case 0:
// //         return DashboardScreenss(firestoreService: _firestoreService);
// //       case 1:
// //         return ManageUsersScreen(firestoreService: _firestoreService);
// //       case 2:
// //         return OrderPagess(isAdmin: true, currentUserId: 'admin');
// //       case 3:
// //         return ProductListScreen(firestoreService: _firestoreService);
// //       case 4:
// //         return AddProductTab(isAdmin: true, currentUserId: 'admin');
// //       case 5:
// //         return Container(); // Placeholder for Menu Management
// //       case 6:
// //         return _buildProfileScreen();
// //       default:
// //         return _buildUnderDevelopment();
// //     }
// //   }
// //
// //   Widget _buildProfileScreen() {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //
// //     return Center(
// //       child: Container(
// //         padding: const EdgeInsets.all(24),
// //         margin: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: isDarkMode
// //                 ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
// //                 : [Colors.white, const Color(0xFFF8F5F0)],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.1),
// //               blurRadius: 10,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //           border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Container(
// //               width: 100,
// //               height: 100,
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 gradient: LinearGradient(
// //                   colors: [const Color(0xFFD4AF37), const Color(0xFFB8941F)],
// //                   begin: Alignment.topLeft,
// //                   end: Alignment.bottomRight,
// //                 ),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: const Color(0xFFD4AF37).withOpacity(0.3),
// //                     blurRadius: 10,
// //                     offset: const Offset(0, 3),
// //                   ),
// //                 ],
// //               ),
// //               child: const Icon(
// //                 Icons.person,
// //                 color: Colors.white,
// //                 size: 40,
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               "Admin Profile",
// //               style: TextStyle(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.bold,
// //                 color: isDarkMode ? Colors.white : Colors.black87,
// //                 fontFamily: 'PlayfairDisplay',
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               "Administrator Account",
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 color: isDarkMode ? Colors.white70 : Colors.grey[700],
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             _buildProfileInfo("Email", "admin@restaurant.com", isDarkMode),
// //             _buildProfileInfo("Role", "Super Administrator", isDarkMode),
// //             _buildProfileInfo("Joined", "January 2024", isDarkMode),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildProfileInfo(String title, String value, bool isDarkMode) {
// //     return Container(
// //       width: double.infinity,
// //       margin: const EdgeInsets.only(bottom: 12),
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey[50],
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.1)),
// //       ),
// //       child: Row(
// //         children: [
// //           Text(
// //             "$title: ",
// //             style: TextStyle(
// //               fontWeight: FontWeight.bold,
// //               color: isDarkMode ? Colors.white70 : Colors.grey[700],
// //             ),
// //           ),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               color: isDarkMode ? Colors.white : Colors.black87,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildUnderDevelopment() {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //
// //     return Center(
// //       child: Container(
// //         padding: const EdgeInsets.all(32),
// //         margin: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: isDarkMode
// //                 ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
// //                 : [Colors.white, const Color(0xFFF8F5F0)],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.1),
// //               blurRadius: 10,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Icon(
// //               Icons.construction,
// //               size: 80,
// //               color: const Color(0xFFD4AF37).withOpacity(0.7),
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               "Under Development",
// //               style: TextStyle(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.bold,
// //                 color: isDarkMode ? Colors.white : Colors.black87,
// //                 fontFamily: 'PlayfairDisplay',
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             Text(
// //               "This feature is currently being developed\nand will be available soon!",
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 color: isDarkMode ? Colors.white70 : Colors.grey[700],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _animatedWrapper(Widget child) {
// //     return AnimatedBuilder(
// //       animation: _controller,
// //       builder: (context, child) {
// //         return Opacity(
// //           opacity: _fadeAnimation.value,
// //           child: Transform.scale(
// //             scale: _scaleAnimation.value,
// //             child: child,
// //           ),
// //         );
// //       },
// //       child: child,
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //     final currentTitle = _drawerItems
// //         .firstWhere((item) => item['index'] == _selectedIndex)['title'];
// //
// //     return Scaffold(
// //       backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8F5F0),
// //       appBar: AppBar(
// //         title: Text(
// //           currentTitle,
// //           style: TextStyle(
// //             fontWeight: FontWeight.bold,
// //             fontSize: 20,
// //             color: isDarkMode ? Colors.white : Colors.black87,
// //             fontFamily: 'PlayfairDisplay',
// //           ),
// //         ),
// //         backgroundColor: isDarkMode ? const Color(0xFF1A0F0F) : const Color(0xFFF4E4BC),
// //         elevation: 0,
// //         iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
// //         flexibleSpace: Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: isDarkMode
// //                   ? [const Color(0xFF1A0F0F), const Color(0xFF2D1B1B)]
// //                   : [const Color(0xFFF4E4BC), const Color(0xFFE8D9B0)],
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //             ),
// //           ),
// //         ),
// //       ),
// //       drawer: Drawer(
// //         child: Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: isDarkMode
// //                   ? [const Color(0xFF1A0F0F), const Color(0xFF2D1B1B)]
// //                   : [const Color(0xFFF4E4BC), const Color(0xFFE8D9B0)],
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //             ),
// //           ),
// //           child: ListView(
// //             children: [
// //               UserAccountsDrawerHeader(
// //                 accountName: const Text(
// //                   "Admin User",
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 18,
// //                   ),
// //                 ),
// //                 accountEmail: const Text(
// //                   "admin@restaurant.com",
// //                   style: TextStyle(fontSize: 14),
// //                 ),
// //                 currentAccountPicture: Container(
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     gradient: LinearGradient(
// //                       colors: [const Color(0xFFD4AF37), const Color(0xFFB8941F)],
// //                       begin: Alignment.topLeft,
// //                       end: Alignment.bottomRight,
// //                     ),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: const Color(0xFFD4AF37).withOpacity(0.3),
// //                         blurRadius: 8,
// //                         offset: const Offset(0, 2),
// //                       ),
// //                     ],
// //                   ),
// //                   child: const CircleAvatar(
// //                     backgroundColor: Colors.transparent,
// //                     child: Icon(
// //                       Icons.person,
// //                       color: Colors.white,
// //                       size: 30,
// //                     ),
// //                   ),
// //                 ),
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: isDarkMode
// //                         ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
// //                         : [const Color(0xFFD4AF37), const Color(0xFFB8941F)],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ),
// //                 ),
// //               ),
// //               ..._drawerItems.map((item) => Container(
// //                 margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(12),
// //                   color: _selectedIndex == item['index']
// //                       ? const Color(0xFFD4AF37).withOpacity(0.2)
// //                       : Colors.transparent,
// //                 ),
// //                 child: ListTile(
// //                   leading: Icon(
// //                     item['icon'],
// //                     color: item['color'] ?? const Color(0xFFD4AF37),
// //                   ),
// //                   title: Text(
// //                     item['title'],
// //                     style: TextStyle(
// //                       color: item['color'] ??
// //                           (isDarkMode ? Colors.white : Colors.black87),
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                   onTap: () => _onDrawerItemTapped(item['index']),
// //                 ),
// //               )),
// //             ],
// //           ),
// //         ),
// //       ),
// //       body: _animatedWrapper(_getScreen(_selectedIndex)),
// //       bottomNavigationBar: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: isDarkMode
// //                 ? [const Color(0xFF1A0F0F), const Color(0xFF2D1B1B)]
// //                 : [const Color(0xFFF4E4BC), const Color(0xFFE8D9B0)],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.2),
// //               blurRadius: 10,
// //               offset: const Offset(0, -2),
// //             ),
// //           ],
// //         ),
// //         child: BottomNavigationBar(
// //           currentIndex: [0, 2, 3, 6].indexOf(_selectedIndex).clamp(0, 3),
// //           onTap: _onBottomNavTapped,
// //           selectedItemColor: const Color(0xFFD4AF37),
// //           unselectedItemColor: isDarkMode ? Colors.white60 : Colors.grey[600],
// //           backgroundColor: Colors.transparent,
// //           type: BottomNavigationBarType.fixed,
// //           elevation: 0,
// //           selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
// //           items: const [
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.dashboard),
// //               label: 'Dashboard',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.shopping_cart),
// //               label: 'Orders',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.inventory),
// //               label: 'Products',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.person),
// //               label: 'Profile',
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:restaurent_management/order/order.dart';
//
// // Services
// import '../../services/firestore_service.dart';
//
// // Screens
// import '../services/firestore_service.dart';
// import 'a_dashboard.dart';
// import 'menu/menu_management_screen.dart';
// import 'order/view_orders_screen.dart';
// import 'orders/orders_list_screen.dart';
// import 'products/add_product_screen.dart';
// import 'products/product_list_screen.dart';
// import 'users/manage_users_screen.dart';
// import '../auth/login_screen.dart';
//
// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});
//
//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }
//
// class _AdminDashboardState extends State<AdminDashboard>
//     with SingleTickerProviderStateMixin {
//   final FirestoreService _firestoreService = FirestoreService();
//   final User? _currentUser = FirebaseAuth.instance.currentUser;
//
//   int _selectedIndex = 0;
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//
//   final List<Map<String, dynamic>> _drawerItems = [
//     {'icon': Icons.dashboard, 'title': 'Dashboard', 'index': 0},
//     {'icon': Icons.group, 'title': 'Manage Users', 'index': 1},
//     {'icon': Icons.shopping_cart, 'title': 'View Orders', 'index': 2},
//     {'icon': Icons.list, 'title': 'Product List', 'index': 3},
//     {'icon': Icons.add_box, 'title': 'Add Product', 'index': 4},
//     {'icon': Icons.restaurant_menu, 'title': 'Menu Management', 'index': 5},
//     {'icon': Icons.person, 'title': 'Profile', 'index': 6},
//     {'icon': Icons.logout, 'title': 'Logout', 'index': 7, 'color': Colors.red},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     );
//     _scaleAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.elasticOut,
//     );
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Future<void> _logout() async {
//     await FirebaseAuth.instance.signOut();
//     if (!mounted) return;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }
//
//   void _onDrawerItemTapped(int index) {
//     Navigator.pop(context);
//     if (index == 7) {
//       _logout();
//     } else {
//       _controller.forward(from: 0.0);
//       setState(() => _selectedIndex = index);
//     }
//   }
//
//   void _onBottomNavTapped(int index) {
//     setState(() {
//       if (index == 0) _selectedIndex = 0;
//       if (index == 1) _selectedIndex = 2;
//       if (index == 2) _selectedIndex = 3;
//       if (index == 3) _selectedIndex = 6;
//     });
//   }
//
//   Widget _getScreen(int index) {
//     final currentUserId = _currentUser?.uid ?? 'admin';
//
//     switch (index) {
//       case 0:
//         return DashboardScreenss(firestoreService: _firestoreService);
//       case 1:
//         return ManageUsersScreen(firestoreService: _firestoreService);
//       case 2:
//         return OrderPagess(isAdmin: true, currentUserId: currentUserId);
//       case 3:
//         return ProductListScreen(firestoreService: _firestoreService);
//       case 4:
//         return AddProductTab(isAdmin: true, currentUserId: currentUserId);
//       case 5:
//         return MenuManagementScreen(
//           isAdmin: true,
//           currentUserId: currentUserId,
//         );
//       case 6:
//         return _buildProfileScreen();
//       default:
//         return _buildUnderDevelopment();
//     }
//   }
//
//   Widget _buildProfileScreen() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final userEmail = _currentUser?.email ?? 'admin@restaurant.com';
//     final userName = _currentUser?.displayName ?? 'Admin User';
//
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isDarkMode
//                 ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
//                 : [Colors.white, const Color(0xFFF8F5F0)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//           border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [const Color(0xFFD4AF37), const Color(0xFFB8941F)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFFD4AF37).withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.person,
//                 color: Colors.white,
//                 size: 40,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "Admin Profile",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: isDarkMode ? Colors.white : Colors.black87,
//                 fontFamily: 'PlayfairDisplay',
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Administrator Account",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isDarkMode ? Colors.white70 : Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildProfileInfo("Name", userName, isDarkMode),
//             _buildProfileInfo("Email", userEmail, isDarkMode),
//             _buildProfileInfo("Role", "Super Administrator", isDarkMode),
//             _buildProfileInfo("User ID", _currentUser?.uid ?? 'N/A', isDarkMode),
//             _buildProfileInfo("Joined", "January 2024", isDarkMode),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileInfo(String title, String value, bool isDarkMode) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.1)),
//       ),
//       child: Row(
//         children: [
//           Text(
//             "$title: ",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: isDarkMode ? Colors.white70 : Colors.grey[700],
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: isDarkMode ? Colors.white : Colors.black87,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildUnderDevelopment() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(32),
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isDarkMode
//                 ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
//                 : [Colors.white, const Color(0xFFF8F5F0)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.construction,
//               size: 80,
//               color: const Color(0xFFD4AF37).withOpacity(0.7),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "Under Development",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: isDarkMode ? Colors.white : Colors.black87,
//                 fontFamily: 'PlayfairDisplay',
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               "This feature is currently being developed\nand will be available soon!",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isDarkMode ? Colors.white70 : Colors.grey[700],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _animatedWrapper(Widget child) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Opacity(
//           opacity: _fadeAnimation.value,
//           child: Transform.scale(
//             scale: _scaleAnimation.value,
//             child: child,
//           ),
//         );
//       },
//       child: child,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final currentTitle = _drawerItems
//         .firstWhere((item) => item['index'] == _selectedIndex)['title'];
//     final userEmail = _currentUser?.email ?? 'admin@restaurant.com';
//     final userName = _currentUser?.displayName ?? 'Admin User';
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8F5F0),
//       appBar: AppBar(
//         title: Text(
//           currentTitle,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: isDarkMode ? Colors.white : Colors.black87,
//             fontFamily: 'PlayfairDisplay',
//           ),
//         ),
//         backgroundColor: isDarkMode ? const Color(0xFF1A0F0F) : const Color(0xFFF4E4BC),
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: isDarkMode
//                   ? [const Color(0xFF1A0F0F), const Color(0xFF2D1B1B)]
//                   : [const Color(0xFFF4E4BC), const Color(0xFFE8D9B0)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: isDarkMode
//                   ? [const Color(0xFF1A0F0F), const Color(0xFF2D1B1B)]
//                   : [const Color(0xFFF4E4BC), const Color(0xFFE8D9B0)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: ListView(
//             children: [
//               UserAccountsDrawerHeader(
//                 accountName: Text(
//                   userName,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 accountEmail: Text(
//                   userEmail,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//                 currentAccountPicture: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [const Color(0xFFD4AF37), const Color(0xFFB8941F)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFFD4AF37).withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: const CircleAvatar(
//                     backgroundColor: Colors.transparent,
//                     child: Icon(
//                       Icons.person,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: isDarkMode
//                         ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
//                         : [const Color(0xFFD4AF37), const Color(0xFFB8941F)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               ),
//               ..._drawerItems.map((item) => Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: _selectedIndex == item['index']
//                       ? const Color(0xFFD4AF37).withOpacity(0.2)
//                       : Colors.transparent,
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     item['icon'],
//                     color: item['color'] ?? const Color(0xFFD4AF37),
//                   ),
//                   title: Text(
//                     item['title'],
//                     style: TextStyle(
//                       color: item['color'] ??
//                           (isDarkMode ? Colors.white : Colors.black87),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   onTap: () => _onDrawerItemTapped(item['index']),
//                 ),
//               )),
//             ],
//           ),
//         ),
//       ),
//       body: _animatedWrapper(_getScreen(_selectedIndex)),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isDarkMode
//                 ? [const Color(0xFF1A0F0F), const Color(0xFF2D1B1B)]
//                 : [const Color(0xFFF4E4BC), const Color(0xFFE8D9B0)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 10,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           currentIndex: [0, 2, 3, 6].indexOf(_selectedIndex).clamp(0, 3),
//           onTap: _onBottomNavTapped,
//           selectedItemColor: const Color(0xFFD4AF37),
//           unselectedItemColor: isDarkMode ? Colors.white60 : Colors.grey[600],
//           backgroundColor: Colors.transparent,
//           type: BottomNavigationBarType.fixed,
//           elevation: 0,
//           selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.dashboard),
//               label: 'Dashboard',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart),
//               label: 'Orders',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.inventory),
//               label: 'Products',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurent_management/order/order.dart';

// Services
import '../../services/firestore_service.dart';

// Screens
import '../services/firestore_service.dart';
import 'a_dashboard.dart';
import 'menu/menu_management_screen.dart';
import 'order/view_orders_screen.dart';
import 'orders/orders_list_screen.dart';
import 'products/add_product_screen.dart';
import 'products/product_list_screen.dart';
import 'users/manage_users_screen.dart';
import 'delivery/delivery_boy_list_screen.dart'; // Add this import
import '../auth/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> _drawerItems = [
    {'icon': Icons.dashboard, 'title': 'Dashboard', 'index': 0},
    {'icon': Icons.group, 'title': 'Manage Users', 'index': 1},
    {'icon': Icons.shopping_cart, 'title': 'View Orders', 'index': 2},
    {'icon': Icons.list, 'title': 'Product List', 'index': 3},
    {'icon': Icons.add_box, 'title': 'Add Product', 'index': 4},
    {'icon': Icons.restaurant_menu, 'title': 'Menu Management', 'index': 5},
    {'icon': Icons.delivery_dining, 'title': 'Delivery Management', 'index': 6}, // Added delivery
    {'icon': Icons.person, 'title': 'Profile', 'index': 7},
    {'icon': Icons.logout, 'title': 'Logout', 'index': 8, 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _onDrawerItemTapped(int index) {
    Navigator.pop(context);
    if (index == 8) { // Updated index for logout
      _logout();
    } else {
      _controller.forward(from: 0.0);
      setState(() => _selectedIndex = index);
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      if (index == 0) _selectedIndex = 0;
      if (index == 1) _selectedIndex = 2;
      if (index == 2) _selectedIndex = 3;
      if (index == 3) _selectedIndex = 7; // Updated for profile
    });
  }

  Widget _getScreen(int index) {
    final currentUserId = _currentUser?.uid ?? 'admin';

    switch (index) {
      case 0:
        return DashboardScreenss(firestoreService: _firestoreService);
      case 1:
        return ManageUsersScreen(firestoreService: _firestoreService);
      case 2:
        return OrderPagess(isAdmin: true, currentUserId: currentUserId);
      case 3:
        return ProductListScreen(firestoreService: _firestoreService);
      case 4:
        return AddProductTab(isAdmin: true, currentUserId: currentUserId);
      case 5:
        return MenuManagementScreen(
          isAdmin: true,
          currentUserId: currentUserId,
        );
      case 6: // Delivery Management
        return const DeliveryBoyListScreen();
      case 7: // Profile
        return _buildProfileScreen();
      default:
        return _buildUnderDevelopment();
    }
  }

  Widget _buildProfileScreen() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userEmail = _currentUser?.email ?? 'admin@restaurant.com';
    final userName = _currentUser?.displayName ?? 'Admin User';

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
                : [Colors.white, const Color(0xFFF8F5F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [const Color(0xFFD4AF37), const Color(0xFFB8941F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Admin Profile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Administrator Account",
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileInfo("Name", userName, isDarkMode),
            _buildProfileInfo("Email", userEmail, isDarkMode),
            _buildProfileInfo("Role", "Super Administrator", isDarkMode),
            _buildProfileInfo("User ID", _currentUser?.uid ?? 'N/A', isDarkMode),
            _buildProfileInfo("Joined", "January 2024", isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String title, String value, bool isDarkMode) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnderDevelopment() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
                : [Colors.white, const Color(0xFFF8F5F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: const Color(0xFFD4AF37).withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              "Under Development",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "This feature is currently being developed\nand will be available soon!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedWrapper(Widget child) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final currentTitle = _drawerItems
        .firstWhere((item) => item['index'] == _selectedIndex)['title'];
    final userEmail = _currentUser?.email ?? 'admin@restaurant.com';
    final userName = _currentUser?.displayName ?? 'Admin User';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: Text(
          currentTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1A0F0F) : const Color(0xFFF4E4BC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [const Color(0xFF1A0F0F), const Color(0xFF2D1B1B)]
                  : [const Color(0xFFF4E4BC), const Color(0xFFE8D9B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [const Color(0xFF1A0F0F), const Color(0xFF2D1B1B)]
                  : [const Color(0xFFF4E4BC), const Color(0xFFE8D9B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  userEmail,
                  style: const TextStyle(fontSize: 14),
                ),
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [const Color(0xFFD4AF37), const Color(0xFFB8941F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD4AF37).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
                        : [const Color(0xFFD4AF37), const Color(0xFFB8941F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              ..._drawerItems.map((item) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _selectedIndex == item['index']
                      ? const Color(0xFFD4AF37).withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: ListTile(
                  leading: Icon(
                    item['icon'],
                    color: item['color'] ?? const Color(0xFFD4AF37),
                  ),
                  title: Text(
                    item['title'],
                    style: TextStyle(
                      color: item['color'] ??
                          (isDarkMode ? Colors.white : Colors.black87),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => _onDrawerItemTapped(item['index']),
                ),
              )),
            ],
          ),
        ),
      ),
      body: _animatedWrapper(_getScreen(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF1A0F0F), const Color(0xFF2D1B1B)]
                : [const Color(0xFFF4E4BC), const Color(0xFFE8D9B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: [0, 2, 3, 7].indexOf(_selectedIndex).clamp(0, 3), // Updated for profile index
          onTap: _onBottomNavTapped,
          selectedItemColor: const Color(0xFFD4AF37),
          unselectedItemColor: isDarkMode ? Colors.white60 : Colors.grey[600],
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}