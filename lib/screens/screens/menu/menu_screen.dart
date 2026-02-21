//
//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:restaurent_management/models/cart_item.dart';
// import '../../../models/food_item.dart';
// import '../../../providers/cart_provider.dart';
// import '../menu/food_detail_screen.dart';
//
// class MenuScreen extends StatefulWidget {
//   const MenuScreen({super.key});
//
//   @override
//   State<MenuScreen> createState() => _MenuScreenState();
// }
//
// class _MenuScreenState extends State<MenuScreen> {
//   final Set<String> _favoriteFoodIds = {};
//   final CollectionReference _favoritesCollection =
//   FirebaseFirestore.instance.collection('favorites');
//
//   bool _isLoading = true;
//   String? _errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadFavoritesFromFirestore();
//   }
//
//   Future<void> _loadFavoritesFromFirestore() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });
//
//       final snapshot = await _favoritesCollection.get();
//       setState(() {
//         _favoriteFoodIds.clear();
//         for (var doc in snapshot.docs) {
//           _favoriteFoodIds.add(doc.id);
//         }
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load favorites';
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _addToFavorites(FoodItem food) async {
//     try {
//       await _favoritesCollection.doc(food.id).set({
//         'name': food.name,
//         'description': food.description,
//         'price': food.price,
//         'image': food.image,
//         'available': food.available,
//         'discount': food.discount,
//         'rating': food.rating,
//         'vendorId': food.vendorId,
//         'vendorName': food.vendorName,
//         'addedAt': FieldValue.serverTimestamp(),
//       });
//
//       setState(() {
//         _favoriteFoodIds.add(food.id);
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('❤️ ${food.name} added to favorites!'),
//           backgroundColor: const Color(0xFFD4AF37),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Failed to add to favorites'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Future<void> _removeFromFavorites(FoodItem food) async {
//     try {
//       await _favoritesCollection.doc(food.id).delete();
//       setState(() {
//         _favoriteFoodIds.remove(food.id);
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('🗑️ ${food.name} removed from favorites'),
//           backgroundColor: Colors.orange,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Failed to remove from favorites'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   void _toggleFavorite(FoodItem food) {
//     if (_favoriteFoodIds.contains(food.id)) {
//       _removeFromFavorites(food);
//     } else {
//       _addToFavorites(food);
//     }
//   }
//
//   void _addToCart(FoodItem food, CartProvider cartProvider) {
//     try {
//       cartProvider.addToCart(food, '1');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('🛒 ${food.name} added to cart!'),
//           backgroundColor: const Color(0xFFD4AF37),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Failed to add item to cart'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8F5F0),
//       appBar: AppBar(
//         title: Text(
//           '🍽️ Our Menu',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 23,
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
//       body: _isLoading
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(color: const Color(0xFFD4AF37)),
//             const SizedBox(height: 20),
//             Text(
//               "Loading Menu...",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isDarkMode ? Colors.white70 : const Color(0xFF8B7355),
//                 fontFamily: 'PlayfairDisplay',
//               ),
//             ),
//           ],
//         ),
//       )
//           : _errorMessage != null
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               color: const Color(0xFFD4AF37),
//               size: 60,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Something went wrong!",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: isDarkMode ? Colors.white70 : const Color(0xFF8B7355),
//                 fontFamily: 'PlayfairDisplay',
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _errorMessage!,
//               style: TextStyle(
//                 color: isDarkMode ? Colors.white54 : Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _loadFavoritesFromFirestore,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFD4AF37),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: const Text("Retry"),
//             ),
//           ],
//         ),
//       )
//           : StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('food_items')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(color: const Color(0xFFD4AF37)),
//             );
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.error_outline,
//                     color: const Color(0xFFD4AF37),
//                     size: 60,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     "Error loading menu!",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: isDarkMode ? Colors.white70 : const Color(0xFF8B7355),
//                       fontFamily: 'PlayfairDisplay',
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Please check your connection",
//                     style: TextStyle(
//                       color: isDarkMode ? Colors.white54 : Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => setState(() {}),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFD4AF37),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                     child: const Text("Retry"),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.restaurant_menu_rounded,
//                     size: 100,
//                     color: const Color(0xFFD4AF37).withOpacity(0.3),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Menu Coming Soon!',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: isDarkMode ? Colors.white70 : const Color(0xFF8B7355),
//                       fontFamily: 'PlayfairDisplay',
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     'We are preparing delicious dishes for you',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: isDarkMode ? Colors.white54 : Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           final foods = snapshot.data!.docs.map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             return FoodItem(
//               id: doc.id,
//               name: data['name'] ?? 'Unnamed Item',
//               description: data['description'] ?? '',
//               price: (data['price'] as num?)?.toDouble() ?? 0.0,
//               image: data['image'] ?? '',
//               available: data['available'] ?? true,
//               discount: (data['discount'] as num?)?.toDouble() ?? 0.0,
//               rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
//               vendorId: data['vendorId'] ?? '',
//               vendorName: data['vendorName'] ?? 'Restaurant',
//             );
//           }).toList();
//
//           return GridView.builder(
//             padding: const EdgeInsets.all(16),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: 0.70,
//             ),
//             itemCount: foods.length,
//             itemBuilder: (context, index) {
//               final food = foods[index];
//               final isFavorite = _favoriteFoodIds.contains(food.id);
//               final discountedPrice = food.discount > 0
//                   ? food.price - (food.price * food.discount / 100)
//                   : food.price;
//
//               return _buildFoodItemCard(
//                 food: food,
//                 isFavorite: isFavorite,
//                 discountedPrice: discountedPrice,
//                 cartProvider: cartProvider,
//                 isDarkMode: isDarkMode,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildFoodItemCard({
//     required FoodItem food,
//     required bool isFavorite,
//     required double discountedPrice,
//     required CartProvider cartProvider,
//     required bool isDarkMode,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isDarkMode
//               ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
//               : [Colors.white, const Color(0xFFF8F5F0)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(
//           color: const Color(0xFFD4AF37).withOpacity(0.3),
//           width: 1.5,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Food Image with Overlays
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FoodDetailScreen(food: food),
//                 ),
//               );
//             },
//             child: Stack(
//               children: [
//                 Container(
//                   height: 120,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                     child: Image.network(
//                       food.image,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Container(
//                           color: const Color(0xFFD4AF37).withOpacity(0.1),
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               color: const Color(0xFFD4AF37),
//                               strokeWidth: 2,
//                             ),
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) => Container(
//                         color: const Color(0xFFD4AF37).withOpacity(0.1),
//                         child: Icon(
//                           Icons.fastfood_rounded,
//                           color: const Color(0xFFD4AF37),
//                           size: 40,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Favorite Button
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.4),
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       icon: Icon(
//                         isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//                         color: isFavorite ? Colors.red : Colors.white,
//                         size: 18,
//                       ),
//                       onPressed: () => _toggleFavorite(food),
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(),
//                     ),
//                   ),
//                 ),
//
//                 // Discount Badge
//                 if (food.discount > 0)
//                   Positioned(
//                     top: 8,
//                     left: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(6),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.red.withOpacity(0.3),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Text(
//                         '${food.discount.toStringAsFixed(0)}% OFF',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 9,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 // Availability Indicator
//                 Positioned(
//                   top: 8,
//                   right: 48,
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: food.available ? Colors.green : Colors.red,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       food.available ? Icons.check_rounded : Icons.close_rounded,
//                       color: Colors.white,
//                       size: 10,
//                     ),
//                   ),
//                 ),
//
//                 // Sold Out Overlay
//                 if (!food.available)
//                   Container(
//                     height: 120,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.5),
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'SOLD OUT',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//
//           // Food Details
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Name and Description
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         food.name,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                           color: isDarkMode ? Colors.white : Colors.black87,
//                           height: 1.2,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         food.description,
//                         style: TextStyle(
//                           color: isDarkMode ? Colors.white60 : Colors.grey[600],
//                           fontSize: 10,
//                           height: 1.3,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//
//                   // Rating, Vendor and Price
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Rating and Vendor
//                       Row(
//                         children: [
//                           // Star Rating
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFD4AF37).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(
//                                 color: const Color(0xFFD4AF37).withOpacity(0.3),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.star_rounded,
//                                     color: Color(0xFFD4AF37), size: 10),
//                                 const SizedBox(width: 2),
//                                 Text(
//                                   food.rating.toStringAsFixed(1),
//                                   style: const TextStyle(
//                                     color: Color(0xFFD4AF37),
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//
//                           // Vendor Name
//                           Expanded(
//                             child: Text(
//                               food.vendorName ?? 'Restaurant',
//                               style: TextStyle(
//                                 color: isDarkMode ? Colors.white54 : Colors.grey[600],
//                                 fontSize: 8,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//
//                       // Price and Add to Cart Button
//                       Row(
//                         children: [
//                           // Price
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '₹${discountedPrice.toStringAsFixed(2)}',
//                                   style: const TextStyle(
//                                     color: Color(0xFFD4AF37),
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 if (food.discount > 0)
//                                   Text(
//                                     '₹${food.price.toStringAsFixed(2)}',
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 10,
//                                       decoration: TextDecoration.lineThrough,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//
//                           // Add to Cart Button
//                           Container(
//                             height: 32,
//                             width: 80,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               gradient: LinearGradient(
//                                 colors: food.available
//                                     ? [const Color(0xFFD4AF37), const Color(0xFFB8941F)]
//                                     : [Colors.grey, Colors.grey.shade600],
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                               ),
//                               boxShadow: food.available
//                                   ? [
//                                 BoxShadow(
//                                   color: const Color(0xFFD4AF37).withOpacity(0.3),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ]
//                                   : null,
//                             ),
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.transparent,
//                                 foregroundColor: Colors.white,
//                                 shadowColor: Colors.transparent,
//                                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               onPressed: food.available
//                                   ? () => _addToCart(food, cartProvider)
//                                   : null,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     food.available ? Icons.shopping_cart_rounded : Icons.remove_shopping_cart_rounded,
//                                     size: 12,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     food.available ? 'Add' : 'Unavailable',
//                                     style: const TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_management/models/cart_item.dart';
import '../../../models/food_item.dart';
import '../../../providers/cart_provider.dart';
import '../menu/food_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final Set<String> _favoriteFoodIds = {};
  final CollectionReference _favoritesCollection =
  FirebaseFirestore.instance.collection('favorites');

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFavoritesFromFirestore();
  }

  Future<void> _loadFavoritesFromFirestore() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final snapshot = await _favoritesCollection.get();
      setState(() {
        _favoriteFoodIds.clear();
        for (var doc in snapshot.docs) {
          _favoriteFoodIds.add(doc.id);
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load favorites';
        _isLoading = false;
      });
    }
  }

  Future<void> _addToFavorites(FoodItem food) async {
    try {
      await _favoritesCollection.doc(food.id).set({
        'name': food.name,
        'description': food.description,
        'price': food.price,
        'image': food.image,
        'available': food.available,
        'discount': food.discount,
        'rating': food.rating,
        'vendorId': food.vendorId,
        'vendorName': food.vendorName,
        'addedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _favoriteFoodIds.add(food.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❤️ ${food.name} added to favorites!'),
          backgroundColor: const Color(0xFFD4AF37),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to add to favorites'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeFromFavorites(FoodItem food) async {
    try {
      await _favoritesCollection.doc(food.id).delete();
      setState(() {
        _favoriteFoodIds.remove(food.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🗑️ ${food.name} removed from favorites'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to remove from favorites'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleFavorite(FoodItem food) {
    if (_favoriteFoodIds.contains(food.id)) {
      _removeFromFavorites(food);
    } else {
      _addToFavorites(food);
    }
  }

  void _addToCart(FoodItem food, CartProvider cartProvider) {
    try {
      cartProvider.addToCart(food, '1');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🛒 ${food.name} added to cart!'),
          backgroundColor: const Color(0xFFD4AF37),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to add item to cart'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: Text(
          '🍽️ Our Menu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
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
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: const Color(0xFFD4AF37)),
            const SizedBox(height: 20),
            Text(
              "Loading Menu...",
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : const Color(0xFF8B7355),
                fontFamily: 'PlayfairDisplay',
              ),
            ),
          ],
        ),
      )
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: const Color(0xFFD4AF37),
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              "Something went wrong!",
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white70 : const Color(0xFF8B7355),
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadFavoritesFromFirestore,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('food_items')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: const Color(0xFFD4AF37)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: const Color(0xFFD4AF37),
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading menu!",
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.white70 : const Color(0xFF8B7355),
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please check your connection",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu_rounded,
                    size: 100,
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Menu Coming Soon!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white70 : const Color(0xFF8B7355),
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We are preparing delicious dishes for you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          final foods = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return FoodItem(
              id: doc.id,
              name: data['name'] ?? 'Unnamed Item',
              description: data['description'] ?? '',
              price: (data['price'] as num?)?.toDouble() ?? 0.0,
              image: data['image'] ?? '',
              available: data['available'] ?? true,
              discount: (data['discount'] as num?)?.toDouble() ?? 0.0,
              rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
              vendorId: data['vendorId'] ?? '',
              vendorName: data['vendorName'] ?? 'Restaurant',
            );
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(12), // Reduced padding
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12, // Reduced spacing
              mainAxisSpacing: 12, // Reduced spacing
              childAspectRatio: 0.68, // Adjusted aspect ratio
            ),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              final isFavorite = _favoriteFoodIds.contains(food.id);
              final discountedPrice = food.discount > 0
                  ? food.price - (food.price * food.discount / 100)
                  : food.price;

              return _buildFoodItemCard(
                food: food,
                isFavorite: isFavorite,
                discountedPrice: discountedPrice,
                cartProvider: cartProvider,
                isDarkMode: isDarkMode,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFoodItemCard({
    required FoodItem food,
    required bool isFavorite,
    required double discountedPrice,
    required CartProvider cartProvider,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
              : [Colors.white, const Color(0xFFF8F5F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16), // Slightly smaller radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8, // Reduced blur
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image with Overlays
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailScreen(food: food),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 110, // Reduced height
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      food.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFFD4AF37).withOpacity(0.1),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: const Color(0xFFD4AF37),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
                        child: Icon(
                          Icons.fastfood_rounded,
                          color: const Color(0xFFD4AF37),
                          size: 35, // Smaller icon
                        ),
                      ),
                    ),
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 16, // Smaller icon
                      ),
                      onPressed: () => _toggleFavorite(food),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),

                // Discount Badge
                if (food.discount > 0)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2), // Reduced padding
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        '${food.discount.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8, // Smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Availability Indicator
                Positioned(
                  top: 6,
                  right: 40, // Adjusted position
                  child: Container(
                    padding: const EdgeInsets.all(3), // Reduced padding
                    decoration: BoxDecoration(
                      color: food.available ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      food.available ? Icons.check_rounded : Icons.close_rounded,
                      color: Colors.white,
                      size: 8, // Smaller icon
                    ),
                  ),
                ),

                // Sold Out Overlay
                if (!food.available)
                  Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'SOLD OUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10, // Smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Food Details - Using Flexible to prevent overflow
          Flexible( // Changed from Expanded to Flexible
            child: Padding(
              padding: const EdgeInsets.all(10), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Name and Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13, // Smaller font
                          color: isDarkMode ? Colors.white : Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3), // Reduced spacing
                      Text(
                        food.description,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white60 : Colors.grey[600],
                          fontSize: 9, // Smaller font
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // Rating, Vendor and Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating and Vendor
                      Row(
                        children: [
                          // Star Rating
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), // Reduced padding
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0xFFD4AF37).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Color(0xFFD4AF37), size: 9), // Smaller icon
                                const SizedBox(width: 1), // Reduced spacing
                                Text(
                                  food.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Color(0xFFD4AF37),
                                    fontSize: 8, // Smaller font
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4), // Reduced spacing

                          // Vendor Name
                          Expanded(
                            child: Text(
                              food.vendorName ?? 'Restaurant',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white54 : Colors.grey[600],
                                fontSize: 7, // Smaller font
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6), // Reduced spacing

                      // Price and Add to Cart Button
                      Row(
                        children: [
                          // Price
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '₹${discountedPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Color(0xFFD4AF37),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12, // Smaller font
                                  ),
                                ),
                                if (food.discount > 0)
                                  Text(
                                    '₹${food.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 8, // Smaller font
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Add to Cart Button
                          Container(
                            height: 28, // Reduced height
                            width: 70, // Reduced width
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), // Smaller radius
                              gradient: LinearGradient(
                                colors: food.available
                                    ? [const Color(0xFFD4AF37), const Color(0xFFB8941F)]
                                    : [Colors.grey, Colors.grey.shade600],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: food.available
                                  ? [
                                BoxShadow(
                                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                                  : null,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Reduced padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              onPressed: food.available
                                  ? () => _addToCart(food, cartProvider)
                                  : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    food.available ? Icons.shopping_cart_rounded : Icons.remove_shopping_cart_rounded,
                                    size: 10, // Smaller icon
                                  ),
                                  const SizedBox(width: 2), // Reduced spacing
                                  Text(
                                    food.available ? 'Add' : 'Sold',
                                    style: const TextStyle(
                                      fontSize: 9, // Smaller font
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}