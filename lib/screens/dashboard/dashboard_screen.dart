// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// // Screens
// import '../../main.dart';
// import '../../order/pickup_slot_screen.dart';
// import '../SettingsScreen.dart';
// import '../card/cart_screen.dart';
// import '../favorites/favorites_screen.dart';
// import '../profile/profile_screen.dart';
// import '../../order/order.dart';
// import '../screens/menu/menu_screen.dart';
//
//
// import '../wallet/wallet_screen.dart';
// import '../auth/login_screen.dart';
// import '../screens/menu/food_detail_screen.dart';
//
// // Models & Providers
// import '../../models/food_item.dart';
// import '../../providers/cart_provider.dart';
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   int _selectedIndex = 0;
//   final TextEditingController _searchController = TextEditingController();
//   String searchQuery = '';
//   late String currentUserId;
//   String? userProfileImageUrl;
//   String userName = 'PRINCE VIDYARTHI';
//   String userEmail = 'vidyarthiprince@email.com';
//
//   @override
//   void initState() {
//     super.initState();
//     final user = FirebaseAuth.instance.currentUser;
//     currentUserId = user?.uid ?? '';
//     userProfileImageUrl = user?.photoURL;
//     userName = user?.displayName ?? 'PRINCE VIDYARTHI';
//     userEmail = user?.email ?? 'vidyarthiprince@email.com';
//   }
//
//   final List<FoodItem> popularItems = [
//     FoodItem(
//         id: '1',
//         name: 'Chicken Salad',
//         description: 'Healthy & fresh',
//         image:
//         'https://hips.hearstapps.com/hmg-prod/images/crunchy-mandarin-orange-chicken-salad-stills-1-66688b2d79edf.jpg',
//         price: 299.0,
//         vendorId: 'vendor1',
//         rating: 4.5),
//     FoodItem(
//         id: '2',
//         name: 'Vegan Bowl',
//         description: 'Fresh vegetables',
//         image:
//         'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
//         price: 199.0,
//         vendorId: 'vendor2',
//         rating: 4.2),
//     FoodItem(
//         id: '3',
//         name: 'Grilled Salmon',
//         description: 'Healthy & delicious',
//         image:
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3waeoqX1nl7YJ4DIoGkAcMEfdUoQmzDAVtw&s',
//         price: 199.0,
//         vendorId: 'vendor3',
//         rating: 4.7),
//     FoodItem(
//         id: '4',
//         name: 'Fruit Bowl',
//         description: 'Mixed seasonal fruits',
//         image:
//         'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?auto=format&fit=crop&w=800&q=80',
//         price: 150.0,
//         vendorId: 'vendor4',
//         rating: 4.0),
//   ];
//
//   final List<FoodItem> recommendedItems = [
//     FoodItem(
//         id: '5',
//         name: 'Burger',
//         description: 'Juicy & Delicious',
//         image:
//         'https://static01.nyt.com/images/2022/06/27/dining/kc-mushroom-beef-burgers/merlin_209008674_b3fa58fa-9bb1-4cfe-a08a-40b4dda0de78-jumbo.jpg',
//         price: 249.0,
//         vendorId: 'vendor5',
//         rating: 4.6),
//     FoodItem(
//         id: '6',
//         name: 'Margherita Pizza',
//         description: 'A classic Italian pizza',
//         image:
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTknG2ydWpIR4xvXFMdY9ubCFOi2Ja5-whb0Q&s',
//         price: 200.0,
//         vendorId: 'vendor6',
//         rating: 4.8),
//     FoodItem(
//         id: '7',
//         name: 'Tacos',
//         description: 'A Mexican dish',
//         image:
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDcPfKt25AT0Rt-WYzphtiBOb4hGlLa8l-gw&s',
//         price: 149.0,
//         vendorId: 'vendor7',
//         rating: 4.3),
//     FoodItem(
//         id: '8',
//         name: 'Sushi Platter',
//         description: 'A Japanese dish',
//         image:
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNDVR4LIJYQoXHjsY7cB5pk02uj4FTyVCx9A&s',
//         price: 349.0,
//         vendorId: 'vendor8',
//         rating: 4.9),
//   ];
//
//   List<FoodItem> get filteredPopularItems {
//     if (searchQuery.isEmpty) return popularItems;
//     return popularItems
//         .where(
//             (item) => item.name.toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//   }
//
//   List<FoodItem> get filteredRecommendedItems {
//     if (searchQuery.isEmpty) return recommendedItems;
//     return recommendedItems
//         .where(
//             (item) => item.name.toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//   }
//
//   void _onItemSelected(FoodItem item) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => FoodDetailScreen(food: item)),
//     );
//   }
//
//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//     switch (index) {
//       case 1:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => OrderPage(userId: currentUserId)),
//         );
//         break;
//       case 2:
//         Navigator.push(
//             context, MaterialPageRoute(builder: (_) => const CartScreen()));
//         break;
//       case 3:
//         Navigator.push(
//             context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? Color(0xFF0A0A0A) : Color(0xFFF8F5F0),
//       appBar: AppBar(
//         title: Text(
//           '🏠 Home',
//           style: TextStyle(
//             fontSize: 23,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? Colors.white : Colors.black87,
//             fontFamily: 'PlayfairDisplay',
//           ),
//         ),
//         backgroundColor: isDarkMode ? Color(0xFF1A0F0F) : Color(0xFFF4E4BC),
//         elevation: 0,
//         iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: isDarkMode
//                   ? [Color(0xFF1A0F0F), Color(0xFF2D1B1B)]
//                   : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: Icon(Icons.menu, color: Color(0xFFD4AF37)),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             );
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications_none, color: Color(0xFFD4AF37)),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,
//                 color: Color(0xFFD4AF37)),
//             onPressed: themeProvider.toggleTheme,
//           ),
//           IconButton(
//             icon: Icon(Icons.settings, color: Color(0xFFD4AF37)),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const SettingsScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       drawer: CustomDrawer(
//         currentUserId: currentUserId,
//         userProfileImageUrl: userProfileImageUrl,
//         userName: userName,
//         userEmail: userEmail,
//       ),
//       body: _buildBody(isDarkMode),
//       bottomNavigationBar: _buildBottomNavigationBar(isDarkMode),
//     );
//   }
//
//   Widget _buildBottomNavigationBar(bool isDarkMode) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isDarkMode
//               ? [Color(0xFF1A0F0F), Color(0xFF2D1B1B)]
//               : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 10,
//             offset: Offset(0, -2),
//           ),
//         ],
//       ),
//       child: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list_alt),
//             label: 'Orders',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Color(0xFFD4AF37),
//         unselectedItemColor: Colors.grey[600],
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
//         unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
//       ),
//     );
//   }
//
//   Widget _buildBody(bool isDarkMode) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Welcome Section
//           _buildWelcomeSection(isDarkMode),
//           const SizedBox(height: 20),
//
//           // Search Field
//           _buildSearchField(isDarkMode),
//           const SizedBox(height: 20),
//
//           // Banner Carousel
//           _buildBanner(isDarkMode),
//           const SizedBox(height: 20),
//
//           // Popular Near You
//           _buildSectionTitle('🔥 Popular Near You', isDarkMode),
//           const SizedBox(height: 10),
//           filteredPopularItems.isEmpty
//               ? _buildEmptyState("No popular items found", isDarkMode)
//               : _buildHorizontalList(filteredPopularItems, isDarkMode),
//           const SizedBox(height: 20),
//
//           // Recommended
//           _buildSectionTitle('⭐ Recommended', isDarkMode),
//           const SizedBox(height: 10),
//           filteredRecommendedItems.isEmpty
//               ? _buildEmptyState("No recommendations found", isDarkMode)
//               : _buildHorizontalList(filteredRecommendedItems, isDarkMode),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWelcomeSection(bool isDarkMode) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Find Your',
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? Colors.white : Colors.brown[800],
//             fontFamily: 'PlayfairDisplay',
//           ),
//         ),
//         Text(
//           'Favorite Food',
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFFD4AF37),
//             fontFamily: 'PlayfairDisplay',
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           'Discover delicious meals tailored for you',
//           style: TextStyle(
//             fontSize: 14,
//             color: isDarkMode ? Colors.white70 : Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSearchField(bool isDarkMode) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDarkMode ? Color(0xFF2D1B1B) : Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: _searchController,
//         onChanged: (value) => setState(() => searchQuery = value),
//         decoration: InputDecoration(
//           prefixIcon: Icon(Icons.search, color: Color(0xFFD4AF37)),
//           suffixIcon: searchQuery.isNotEmpty
//               ? IconButton(
//             icon: Icon(Icons.clear, color: Color(0xFFD4AF37)),
//             onPressed: () {
//               _searchController.clear();
//               setState(() => searchQuery = '');
//             },
//           )
//               : null,
//           hintText: 'What do you want to order?',
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.all(15),
//           hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey[600]),
//         ),
//         style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title, bool isDarkMode) {
//     return Row(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? Colors.white : Colors.brown[800],
//             fontFamily: 'PlayfairDisplay',
//           ),
//         ),
//         Spacer(),
//         TextButton(
//           onPressed: () {
//             // Navigate to see all
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => MenuScreen()),
//             );
//           },
//           child: Text(
//             'See All',
//             style: TextStyle(
//               color: Color(0xFFD4AF37),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildEmptyState(String message, bool isDarkMode) {
//     return Container(
//       height: 100,
//       margin: EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: isDarkMode ? Color(0xFF2D1B1B) : Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.2)),
//       ),
//       child: Center(
//         child: Text(
//           message,
//           style: TextStyle(
//             color: isDarkMode ? Colors.white60 : Colors.grey[600],
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBanner(bool isDarkMode) {
//     final List<String> bannerImages = [
//       'assets/images/banner1.jpeg',
//       'assets/images/banner2.jpeg',
//       'assets/images/banner3.jpeg',
//       'assets/images/banner4.jpeg',
//       'assets/images/banner5.jpeg',
//     ];
//
//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 170,
//         autoPlay: true,
//         enlargeCenterPage: true,
//         viewportFraction: 0.9,
//         aspectRatio: 16 / 9,
//         autoPlayInterval: const Duration(seconds: 3),
//       ),
//       items: bannerImages.map((imagePath) {
//         return Builder(
//           builder: (BuildContext context) {
//             return Container(
//               margin: const EdgeInsets.symmetric(horizontal: 9.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: LinearGradient(
//                   colors: isDarkMode
//                       ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
//                       : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.asset(
//                       imagePath,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.black.withOpacity(0.4),
//                           Colors.transparent
//                         ],
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     left: 16,
//                     bottom: 16,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Big Discount',
//                           style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontFamily: 'PlayfairDisplay'),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           'up to 30%',
//                           style: TextStyle(fontSize: 16, color: Colors.white70),
//                         ),
//                         SizedBox(height: 8),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 blurRadius: 8,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (_) => const CartScreen()));
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xFFD4AF37),
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: Text('Order Now',
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildHorizontalList(List<FoodItem> items, bool isDarkMode) {
//     return SizedBox(
//       height: 220,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: items.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (_, index) {
//           final item = items[index];
//           return GestureDetector(
//             onTap: () => _onItemSelected(item),
//             child: Container(
//               width: 160,
//               margin: EdgeInsets.only(bottom: 8),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: isDarkMode
//                       ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
//                       : [Colors.white, Color(0xFFF8F5F0)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//                 border: Border.all(
//                   color: Color(0xFFD4AF37).withOpacity(0.2),
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Food Image
//                   Container(
//                     height: 100,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                       ),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                       ),
//                       child: Image.network(
//                         item.image,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           color: Color(0xFFD4AF37).withOpacity(0.1),
//                           child: Icon(
//                             Icons.fastfood,
//                             color: Color(0xFFD4AF37),
//                             size: 40,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // Food Details
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.name,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             color: isDarkMode ? Colors.white : Colors.black,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           item.description,
//                           style: TextStyle(
//                             color: isDarkMode ? Colors.white60 : Colors.grey[600],
//                             fontSize: 11,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "₹${item.price}",
//                               style: TextStyle(
//                                 color: Color(0xFFD4AF37),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFD4AF37).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.star, color: Color(0xFFD4AF37), size: 12),
//                                   SizedBox(width: 2),
//                                   Text(
//                                     item.rating.toString(),
//                                     style: TextStyle(
//                                       color: Color(0xFFD4AF37),
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // ================= Custom Drawer =================
// class CustomDrawer extends StatelessWidget {
//   final String currentUserId;
//   final String? userProfileImageUrl;
//   final String userName;
//   final String userEmail;
//
//   const CustomDrawer({
//     super.key,
//     required this.currentUserId,
//     this.userProfileImageUrl,
//     required this.userName,
//     required this.userEmail,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;
//
//     return Drawer(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isDarkMode
//                 ? [Color(0xFF1A0F0F), Color(0xFF2D1B1B)]
//                 : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             // User Header
//             Container(
//               padding: EdgeInsets.only(top: 60, bottom: 20, left: 16, right: 16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: isDarkMode
//                       ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
//                       : [Color(0xFFD4AF37).withOpacity(0.1), Color(0xFFB8941F).withOpacity(0.1)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Color(0xFFD4AF37), width: 2),
//                     ),
//                     child: ClipOval(
//                       child: userProfileImageUrl != null && userProfileImageUrl!.isNotEmpty
//                           ? Image.network(userProfileImageUrl!, fit: BoxFit.cover)
//                           : Icon(Icons.person, color: Color(0xFFD4AF37), size: 30),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           userName,
//                           style: TextStyle(
//                             color: isDarkMode ? Colors.white : Colors.brown[800],
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'PlayfairDisplay',
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           userEmail,
//                           style: TextStyle(
//                             color: isDarkMode ? Colors.white70 : Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Drawer Items
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   _DrawerItem(icon: Icons.home, title: "🏠 Home", isDarkMode: isDarkMode),
//                   _DrawerItem(
//                     icon: Icons.person,
//                     title: "👤 Profile",
//                     isDarkMode: isDarkMode,
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
//                     },
//                   ),
//                   _DrawerItem(
//                     icon: Icons.list_alt,
//                     title: "📦 Order Tracking",
//                     isDarkMode: isDarkMode,
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => OrderPage(userId: currentUserId)));
//                     },
//                   ),
//                   _DrawerItem(
//                     icon: Icons.favorite,
//                     title: "❤️ Favorites",
//                     isDarkMode: isDarkMode,
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesScreen(userId: currentUserId)));
//                     },
//                   ),
//                   _DrawerItem(
//                     icon: Icons.schedule,
//                     title: "⏰ Pickup Slot",
//                     isDarkMode: isDarkMode,
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => const PickupSlotBookingScreen()));
//                     },
//                   ),
//                   _DrawerItem(
//                     icon: Icons.account_balance_wallet,
//                     title: "💰 Wallet",
//                     isDarkMode: isDarkMode,
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => WalletScreen(userId: currentUserId, amount: 100)));
//                     },
//                   ),
//                   _DrawerItem(
//                     icon: Icons.menu,
//                     title: "📋 Menu",
//                     isDarkMode: isDarkMode,
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen()));
//                     },
//                   ),
//                   _DrawerItem(
//                     icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
//                     title: isDarkMode ? "🌞 Light Mode" : "🌙 Dark Mode",
//                     isDarkMode: isDarkMode,
//                     onTap: themeProvider.toggleTheme,
//                   ),
//                   SizedBox(height: 20),
//                   _DrawerItem(
//                     icon: Icons.logout,
//                     title: "🚪 Log Out",
//                     isDarkMode: isDarkMode,
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(builder: (_) => const LoginScreen()),
//                             (route) => false,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _DrawerItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback? onTap;
//   final bool isDarkMode;
//
//   const _DrawerItem({
//     required this.icon,
//     required this.title,
//     this.onTap,
//     required this.isDarkMode,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Color(0xFFD4AF37).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, color: Color(0xFFD4AF37), size: 20),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: isDarkMode ? Colors.white : Colors.brown[800],
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
// }
//
//
//
//
//
//


import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens
import '../../main.dart';
import '../../order/notifications_screen.dart';
import '../../order/pickup_slot_screen.dart';
import '../SettingsScreen.dart';
import '../card/cart_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import '../../order/order.dart';
import '../screens/menu/menu_screen.dart';
import '../wallet/wallet_screen.dart';
import '../auth/login_screen.dart';
import '../screens/menu/food_detail_screen.dart';

// Notification Screen
//import '../../features/notifications/presentation/screens/notifications_screen.dart';

// Models & Providers
import '../../models/food_item.dart';
import '../../providers/cart_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  late String currentUserId;
  String? userProfileImageUrl;
  String userName = 'PRINCE VIDYARTHI';
  String userEmail = 'vidyarthiprince@email.com';

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    currentUserId = user?.uid ?? '';
    userProfileImageUrl = user?.photoURL;
    userName = user?.displayName ?? 'PRINCE VIDYARTHI';
    userEmail = user?.email ?? 'vidyarthiprince@email.com';
  }

  final List<FoodItem> popularItems = [
    FoodItem(
        id: '1',
        name: 'Chicken Salad',
        description: 'Healthy & fresh',
        image:
        'https://hips.hearstapps.com/hmg-prod/images/crunchy-mandarin-orange-chicken-salad-stills-1-66688b2d79edf.jpg',
        price: 299.0,
        vendorId: 'vendor1',
        rating: 4.5),
    FoodItem(
        id: '2',
        name: 'Vegan Bowl',
        description: 'Fresh vegetables',
        image:
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
        price: 199.0,
        vendorId: 'vendor2',
        rating: 4.2),
    FoodItem(
        id: '3',
        name: 'Grilled Salmon',
        description: 'Healthy & delicious',
        image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3waeoqX1nl7YJ4DIoGkAcMEfdUoQmzDAVtw&s',
        price: 199.0,
        vendorId: 'vendor3',
        rating: 4.7),
    FoodItem(
        id: '4',
        name: 'Fruit Bowl',
        description: 'Mixed seasonal fruits',
        image:
        'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?auto=format&fit=crop&w=800&q=80',
        price: 150.0,
        vendorId: 'vendor4',
        rating: 4.0),
  ];

  final List<FoodItem> recommendedItems = [
    FoodItem(
        id: '5',
        name: 'Burger',
        description: 'Juicy & Delicious',
        image:
        'https://static01.nyt.com/images/2022/06/27/dining/kc-mushroom-beef-burgers/merlin_209008674_b3fa58fa-9bb1-4cfe-a08a-40b4dda0de78-jumbo.jpg',
        price: 249.0,
        vendorId: 'vendor5',
        rating: 4.6),
    FoodItem(
        id: '6',
        name: 'Margherita Pizza',
        description: 'A classic Italian pizza',
        image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTknG2ydWpIR4xvXFMdY9ubCFOi2Ja5-whb0Q&s',
        price: 200.0,
        vendorId: 'vendor6',
        rating: 4.8),
    FoodItem(
        id: '7',
        name: 'Tacos',
        description: 'A Mexican dish',
        image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDcPfKt25AT0Rt-WYzphtiBOb4hGlLa8l-gw&s',
        price: 149.0,
        vendorId: 'vendor7',
        rating: 4.3),
    FoodItem(
        id: '8',
        name: 'Sushi Platter',
        description: 'A Japanese dish',
        image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNDVR4LIJYQoXHjsY7cB5pk02uj4FTyVCx9A&s',
        price: 349.0,
        vendorId: 'vendor8',
        rating: 4.9),
  ];

  List<FoodItem> get filteredPopularItems {
    if (searchQuery.isEmpty) return popularItems;
    return popularItems
        .where(
            (item) => item.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  List<FoodItem> get filteredRecommendedItems {
    if (searchQuery.isEmpty) return recommendedItems;
    return recommendedItems
        .where(
            (item) => item.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void _onItemSelected(FoodItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FoodDetailScreen(food: item)),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderPage(userId: currentUserId)),
        );
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const CartScreen()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF0A0A0A) : Color(0xFFF8F5F0),
      appBar: AppBar(
        title: Text(
          '🏠 Home',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        backgroundColor: isDarkMode ? Color(0xFF1A0F0F) : Color(0xFFF4E4BC),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Color(0xFF1A0F0F), Color(0xFF2D1B1B)]
                  : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Color(0xFFD4AF37)),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          // Notifications Icon with Badge
          StreamBuilder<int>(
            stream: _getUnreadNotificationsCount(),
            builder: (context, snapshot) {
              final unreadCount = snapshot.data ?? 0;
              return Badge(
                label: unreadCount > 0 ? Text('$unreadCount') : null,
                child: IconButton(
                  icon: Icon(Icons.notifications_none, color: Color(0xFFD4AF37)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                    );
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Color(0xFFD4AF37)),
            onPressed: themeProvider.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Color(0xFFD4AF37)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        currentUserId: currentUserId,
        userProfileImageUrl: userProfileImageUrl,
        userName: userName,
        userEmail: userEmail,
      ),
      body: _buildBody(isDarkMode),
      bottomNavigationBar: _buildBottomNavigationBar(isDarkMode),
    );
  }

  // Stream to get unread notifications count
  Stream<int> _getUnreadNotificationsCount() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(0);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Widget _buildBottomNavigationBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Color(0xFF1A0F0F), Color(0xFF2D1B1B)]
              : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.transparent,
        elevation: 0,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget _buildBody(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(isDarkMode),
          const SizedBox(height: 20),

          // Search Field
          _buildSearchField(isDarkMode),
          const SizedBox(height: 20),

          // Banner Carousel
          _buildBanner(isDarkMode),
          const SizedBox(height: 20),

          // Popular Near You
          _buildSectionTitle('🔥 Popular Near You', isDarkMode),
          const SizedBox(height: 10),
          filteredPopularItems.isEmpty
              ? _buildEmptyState("No popular items found", isDarkMode)
              : _buildHorizontalList(filteredPopularItems, isDarkMode),
          const SizedBox(height: 20),

          // Recommended
          _buildSectionTitle('⭐ Recommended', isDarkMode),
          const SizedBox(height: 10),
          filteredRecommendedItems.isEmpty
              ? _buildEmptyState("No recommendations found", isDarkMode)
              : _buildHorizontalList(filteredRecommendedItems, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find Your',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.brown[800],
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        Text(
          'Favorite Food',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD4AF37),
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Discover delicious meals tailored for you',
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white70 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2D1B1B) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Color(0xFFD4AF37)),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: Color(0xFFD4AF37)),
            onPressed: () {
              _searchController.clear();
              setState(() => searchQuery = '');
            },
          )
              : null,
          hintText: 'What do you want to order?',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey[600]),
        ),
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.brown[800],
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            // Navigate to see all
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MenuScreen()),
            );
          },
          child: Text(
            'See All',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message, bool isDarkMode) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2D1B1B) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: isDarkMode ? Colors.white60 : Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(bool isDarkMode) {
    final List<String> bannerImages = [
      'assets/images/banner1.jpeg',
      'assets/images/banner2.jpeg',
      'assets/images/banner3.jpeg',
      'assets/images/banner4.jpeg',
      'assets/images/banner5.jpeg',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 170,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 3),
      ),
      items: bannerImages.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 9.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
                      : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Big Discount',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'PlayfairDisplay'),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'up to 30%',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const CartScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD4AF37),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Order Now',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildHorizontalList(List<FoodItem> items, bool isDarkMode) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => _onItemSelected(item),
            child: Container(
              width: 160,
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
                      : [Colors.white, Color(0xFFF8F5F0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Color(0xFFD4AF37).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food Image
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Color(0xFFD4AF37).withOpacity(0.1),
                          child: Icon(
                            Icons.fastfood,
                            color: Color(0xFFD4AF37),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Food Details
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          item.description,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.grey[600],
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹${item.price}",
                              style: TextStyle(
                                color: Color(0xFFD4AF37),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFFD4AF37).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: Color(0xFFD4AF37), size: 12),
                                  SizedBox(width: 2),
                                  Text(
                                    item.rating.toString(),
                                    style: TextStyle(
                                      color: Color(0xFFD4AF37),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================= Custom Drawer =================
class CustomDrawer extends StatelessWidget {
  final String currentUserId;
  final String? userProfileImageUrl;
  final String userName;
  final String userEmail;

  const CustomDrawer({
    super.key,
    required this.currentUserId,
    this.userProfileImageUrl,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xFF1A0F0F), Color(0xFF2D1B1B)]
                : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // User Header
            Container(
              padding: EdgeInsets.only(top: 60, bottom: 20, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
                      : [Color(0xFFD4AF37).withOpacity(0.1), Color(0xFFB8941F).withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFD4AF37), width: 2),
                    ),
                    child: ClipOval(
                      child: userProfileImageUrl != null && userProfileImageUrl!.isNotEmpty
                          ? Image.network(userProfileImageUrl!, fit: BoxFit.cover)
                          : Icon(Icons.person, color: Color(0xFFD4AF37), size: 30),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.brown[800],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(icon: Icons.home, title: "🏠 Home", isDarkMode: isDarkMode),
                  _DrawerItem(
                    icon: Icons.person,
                    title: "👤 Profile",
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.list_alt,
                    title: "📦 Order Tracking",
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => OrderPage(userId: currentUserId)));
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.favorite,
                    title: "❤️ Favorites",
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesScreen(userId: currentUserId)));
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.schedule,
                    title: "⏰ Pickup Slot",
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PickupSlotBookingScreen()));
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.account_balance_wallet,
                    title: "💰 Wallet",
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => WalletScreen(userId: currentUserId, amount: 100)));
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.menu,
                    title: "📋 Menu",
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen()));
                    },
                  ),
                  // 🔔 NEW: Notifications Drawer Item
                  _DrawerItem(
                    icon: Icons.notifications,
                    title: "🔔 Notifications",
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                    },
                  ),
                  _DrawerItem(
                    icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    title: isDarkMode ? "🌞 Light Mode" : "🌙 Dark Mode",
                    isDarkMode: isDarkMode,
                    onTap: themeProvider.toggleTheme,
                  ),
                  SizedBox(height: 20),
                  _DrawerItem(
                    icon: Icons.logout,
                    title: "🚪 Log Out",
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isDarkMode;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFD4AF37).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Color(0xFFD4AF37), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.brown[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}