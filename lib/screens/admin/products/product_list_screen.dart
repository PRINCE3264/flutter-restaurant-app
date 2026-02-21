import 'package:flutter/material.dart';
import '../../../models/food_item.dart';
import '../../services/firestore_service.dart';
import 'add_edit_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  final FirestoreService firestoreService;

  const ProductListScreen({super.key, required this.firestoreService});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int _tappedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // Open Add Product screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditProductScreen(
                    firestoreService: widget.firestoreService,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<FoodItem>>(
        stream: widget.firestoreService.getFoodItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No products found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final item = products[index];
              final isTapped = index == _tappedIndex;

              return GestureDetector(
                onTapDown: (_) => setState(() => _tappedIndex = index),
                onTapUp: (_) => setState(() => _tappedIndex = -1),
                onTapCancel: () => setState(() => _tappedIndex = -1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  transform: isTapped
                      ? (Matrix4.identity()..scale(1.03))
                      : Matrix4.identity(),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade100, Colors.teal.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: item.image.isNotEmpty
                              ? Image.network(
                            item.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.teal.shade200,
                                  child: const Icon(Icons.fastfood,
                                      color: Colors.white),
                                ),
                          )
                              : Container(
                            width: 80,
                            height: 80,
                            color: Colors.teal.shade200,
                            child: const Icon(Icons.fastfood,
                                color: Colors.white),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.description.isNotEmpty
                                    ? item.description
                                    : "No description",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '₹${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Discount: ${item.discount}%',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(
                                  5,
                                      (starIndex) => Icon(
                                    starIndex < item.rating.round()
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Edit/Delete buttons
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Open Edit Product screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddEditProductScreen(
                                      firestoreService: widget.firestoreService,
                                      foodItem: item, // pass for edit
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon:
                              const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: Text(
                                        'Are you sure you want to delete ${item.name}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm ?? false) {
                                  await widget.firestoreService
                                      .deleteFoodItem(item.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Product deleted')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
