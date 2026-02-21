//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../models/food_item.dart';
// import '../../../providers/cart_provider.dart';
//
// class FoodDetailScreen extends StatelessWidget {
//   final FoodItem food;
//
//   const FoodDetailScreen({super.key, required this.food});
//
//   // Helper to build star rating widgets
//   List<Widget> buildStarRating(double rating) {
//     List<Widget> stars = [];
//     int fullStars = rating.floor();
//     bool hasHalfStar = (rating - fullStars) >= 0.5;
//
//     for (int i = 0; i < fullStars; i++) {
//       stars.add(const Icon(Icons.star, color: Colors.amber, size: 22));
//     }
//
//     if (hasHalfStar) {
//       stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 22));
//     }
//
//     while (stars.length < 5) {
//       stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 22));
//     }
//
//     return stars;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Stack(
//         children: [
//           // Header Image
//           SizedBox(
//             height: 320,
//             width: double.infinity,
//             child: Image.network(
//               food.image,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) =>
//               const Icon(Icons.image, size: 100),
//             ),
//           ),
//
//           // Back button
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: CircleAvatar(
//                 backgroundColor: Colors.white.withOpacity(0.8),
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.black87),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ),
//           ),
//
//           // Content section
//           DraggableScrollableSheet(
//             initialChildSize: 0.65,
//             minChildSize: 0.55,
//             maxChildSize: 0.9,
//             builder: (context, scrollController) {
//               return Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10,
//                       offset: Offset(0, -3),
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Food name & price
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               food.name,
//                               style: const TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '₹${food.price.toStringAsFixed(2)}',
//                             style: const TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF1E88E5),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//
//                       // Discount
//                       if (food.discount > 0)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: Colors.redAccent,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             '${food.discount.toStringAsFixed(0)}% OFF',
//                             style: const TextStyle(
//                                 color: Colors.white, fontSize: 14),
//                           ),
//                         ),
//                       const SizedBox(height: 16),
//
//                       // Rating
//                       Row(
//                         children: [
//                           ...buildStarRating(food.rating),
//                           const SizedBox(width: 8),
//                           Text('${food.rating} / 5',
//                               style: const TextStyle(fontSize: 16)),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Description
//                       const Text(
//                         "Description",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         food.description,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.black54,
//                           height: 1.4,
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//
//                       // Add to Cart button
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // ✅ Correctly pass arguments
//                             Provider.of<CartProvider>(context, listen: false)
//                                 .addToCart(food,'1'); // <-- food + quantity
//
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text("${food.name} added to cart!"),
//                                 backgroundColor: Colors.green,
//                                 duration: const Duration(seconds: 2),
//                                 action: SnackBarAction(
//                                   label: "Go to Cart",
//                                   textColor: Colors.white,
//                                   onPressed: () {
//                                     Navigator.pushNamed(context, "/cart");
//                                   },
//                                 ),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.deepOrange,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 14, horizontal: 20),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: const Text(
//                             "Add to Cart",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_management/models/cart_item.dart';
import '../../../models/food_item.dart';
import '../../../providers/cart_provider.dart';

class FoodDetailScreen extends StatelessWidget {
  final FoodItem food;

  const FoodDetailScreen({super.key, required this.food});

  // Helper to build star rating widgets
  List<Widget> buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 22));
    }

    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 22));
    }

    while (stars.length < 5) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 22));
    }

    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Header Image
          SizedBox(
            height: 320,
            width: double.infinity,
            child: Image.network(
              food.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image, size: 100),
            ),
          ),

          // Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // Content section
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.55,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food name & price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              food.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            '₹${food.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E88E5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Discount
                      if (food.discount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${food.discount.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Rating
                      Row(
                        children: [
                          ...buildStarRating(food.rating),
                          const SizedBox(width: 8),
                          Text('${food.rating} / 5',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Description
                      const Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        food.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Add to Cart button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // ✅ Correctly pass arguments
                            Provider.of<CartProvider>(context, listen: false)
                                .addToCart(food as FoodItem,'1'); // <-- food + quantity

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${food.name} added to cart!"),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: "Go to Cart",
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/cart");
                                  },
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Add to Cart",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
