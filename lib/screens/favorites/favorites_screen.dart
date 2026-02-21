//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:restaurent_management/models/cart_item.dart';
// import '../../models/food_item.dart';
// import '../../providers/cart_provider.dart';
// //import '../menu/food_detail_screen.dart';
// import '../screens/menu/food_detail_screen.dart';
//
// class FavoritesScreen extends StatefulWidget {
//   final String userId; // Pass userId to addToCart
//
//   const FavoritesScreen({super.key, required this.userId});
//
//   @override
//   State<FavoritesScreen> createState() => _FavoritesScreenState();
// }
//
// class _FavoritesScreenState extends State<FavoritesScreen> {
//   final CollectionReference favoritesCollection =
//   FirebaseFirestore.instance.collection('favorites');
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final bool isDarkMode = theme.brightness == Brightness.dark;
//     final cartProvider = Provider.of<CartProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Favorites',
//           style: theme.textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? Colors.white : Colors.black87,
//           ),
//         ),
//         backgroundColor:
//         isDarkMode ? Colors.grey[900] : Colors.grey[200], // 👈 adaptive background
//         elevation: 0,
//         iconTheme: theme.iconTheme.copyWith(
//           color: isDarkMode ? Colors.white : const Color(0xFF1A237E),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: favoritesCollection.snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final favList = snapshot.data!.docs;
//
//           if (favList.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.favorite_border,
//                       size: 80, color: Colors.redAccent),
//                   const SizedBox(height: 10),
//                   const Text('No favorites yet!',
//                       style: TextStyle(fontSize: 18, color: Colors.black54)),
//                   const SizedBox(height: 12),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1E88E5),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Browse Food'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return GridView.builder(
//             padding: const EdgeInsets.all(16),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 0.68,
//             ),
//             itemCount: favList.length,
//             itemBuilder: (context, index) {
//               final fav = favList[index];
//               final data = fav.data() as Map<String, dynamic>;
//
//               final foodItem = FoodItem(
//                 id: fav.id,
//                 name: data['name'] ?? '',
//                 description: data['description'] ?? '',
//                 image: data['image'] ?? '',
//                 price: (data['price'] ?? 0).toDouble(),
//                 available: data['available'] ?? true,
//                 discount: (data['discount'] ?? 0).toDouble(),
//                 rating: (data['rating'] ?? 0).toDouble(),
//                 vendorId: data['vendorId'] ?? '',
//                 quantity: 1,
//               );
//
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FoodDetailScreen(food: foodItem),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   elevation: 4,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight: Radius.circular(20),
//                         ),
//                         child: Image.network(
//                           foodItem.image,
//                           height: 85,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) =>
//                           const Icon(Icons.image, size: 60),
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(foodItem.name,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16),
//                                   overflow: TextOverflow.ellipsis),
//                               const SizedBox(height: 4),
//                               Text(
//                                 foodItem.description,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                     fontSize: 12, color: Colors.grey),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 '₹${foodItem.price.toStringAsFixed(2)}',
//                                 style: const TextStyle(
//                                     color: Color(0xFF1E88E5),
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16),
//                               ),
//                               const Spacer(),
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.delete,
//                                         color: Colors.red),
//                                     onPressed: () {
//                                       favoritesCollection.doc(fav.id).delete();
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         const SnackBar(
//                                           content:
//                                           Text('Removed from favorites'),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   Flexible(
//                                     child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           backgroundColor:
//                                           const Color(0xFF1E88E5)),
//                                       onPressed: foodItem.available
//                                           ? () {
//                                         cartProvider.addToCart(
//                                             foodItem as FoodItem, widget.userId);
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                             content:
//                                             Text('Added to cart!'),
//                                           ),
//                                         );
//                                       }
//                                           : null,
//                                       child: const Text('Add',
//                                           style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.white)),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../models/food_item.dart';
import '../../providers/cart_provider.dart';
import '../screens/menu/food_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final String userId;

  const FavoritesScreen({super.key, required this.userId});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final CollectionReference favoritesCollection =
  FirebaseFirestore.instance.collection('favorites');

  void _showCustomToast(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showRemoveConfirmation(String itemId, String itemName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Remove Favorite",
          style: TextStyle(color: const Color(0xFFD4AF37)),
        ),
        content: Text("Are you sure you want to remove $itemName from favorites?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              favoritesCollection.doc(itemId).delete();
              Navigator.pop(context);
              _showCustomToast("🗑️ Removed from favorites", Colors.orange);
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: Text(
          '❤️ Favorites',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: favoritesCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: const Color(0xFFD4AF37)),
                  const SizedBox(height: 16),
                  Text(
                    "Loading Favorites...",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.brown[700],
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading favorites",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          final favList = snapshot.data!.docs;

          if (favList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: const Color(0xFFD4AF37).withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Favorites Yet!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white70 : Colors.brown[700],
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Start adding your favorite items',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text("Explore Menu"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: favList.length,
            itemBuilder: (context, index) {
              final fav = favList[index];
              final data = fav.data() as Map<String, dynamic>;

              final foodItem = FoodItem(
                id: fav.id,
                name: data['name'] ?? '',
                description: data['description'] ?? '',
                image: data['image'] ?? '',
                price: (data['price'] ?? 0).toDouble(),
                available: data['available'] ?? true,
                discount: (data['discount'] ?? 0).toDouble(),
                rating: (data['rating'] ?? 0).toDouble(),
                vendorId: data['vendorId'] ?? '',
                vendorName: data['vendorName'] ?? '',
                quantity: 1,
              );

              return _buildFavoriteItem(foodItem, fav.id, isDarkMode, cartProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildFavoriteItem(FoodItem foodItem, String docId, bool isDarkMode, CartProvider cartProvider) {
    final discountedPrice = foodItem.discount > 0
        ? foodItem.price - (foodItem.price * foodItem.discount / 100)
        : foodItem.price;

    return Container(
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
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailScreen(food: foodItem),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 90,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      foodItem.image,
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
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),

                // Favorite Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

                // Discount Badge
                if (foodItem.discount > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${foodItem.discount.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Availability Indicator
                Positioned(
                  top: 8,
                  right: 48,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: foodItem.available ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      foodItem.available ? Icons.check_rounded : Icons.close_rounded,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),

                // Sold Out Overlay
                if (!foodItem.available)
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'SOLD OUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Food Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Name and Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodItem.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        foodItem.description,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white60 : Colors.grey[600],
                          fontSize: 10,
                          height: 1.3,
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
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFD4AF37).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Color(0xFFD4AF37), size: 10),
                                const SizedBox(width: 2),
                                Text(
                                  foodItem.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Color(0xFFD4AF37),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Vendor Name
                          Expanded(
                            child: Text(
                              foodItem.vendorName ?? 'Restaurant',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white54 : Colors.grey[600],
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

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
                                    fontSize: 14,
                                  ),
                                ),
                                if (foodItem.discount > 0)
                                  Text(
                                    '₹${foodItem.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Add to Cart Button
                          Container(
                            height: 32,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: foodItem.available
                                    ? [const Color(0xFFD4AF37), const Color(0xFFB8941F)]
                                    : [Colors.grey, Colors.grey.shade600],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: foodItem.available
                                  ? [
                                BoxShadow(
                                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                                  : null,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              onPressed: foodItem.available
                                  ? () {
                                cartProvider.addToCart(foodItem, widget.userId);
                                _showCustomToast("🛒 Added to cart!", const Color(0xFFD4AF37));
                              }
                                  : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    foodItem.available ? Icons.shopping_cart_rounded : Icons.remove_shopping_cart_rounded,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    foodItem.available ? 'Add' : 'Unavailable',
                                    style: const TextStyle(
                                      fontSize: 10,
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


