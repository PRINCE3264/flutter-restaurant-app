import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MenuManagementScreen extends StatefulWidget {
  final bool isAdmin;
  final String currentUserId;

  const MenuManagementScreen({
    super.key,
    required this.isAdmin,
    required this.currentUserId,
  });

  @override
  State<MenuManagementScreen> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _categories = ['All', 'Food', 'Beverage', 'Dessert', 'Snack', 'Special'];
  String _sortBy = 'newest';
  List<String> _sortOptions = ['newest', 'price_low', 'price_high', 'name'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Get filtered products based on search and category
  Stream<QuerySnapshot> get _filteredProducts {
    Query query = _firestore.collection('food_items');

    // Apply sorting
    switch (_sortBy) {
      case 'price_low':
        query = query.orderBy('price', descending: false);
        break;
      case 'price_high':
        query = query.orderBy('price', descending: true);
        break;
      case 'name':
        query = query.orderBy('name', descending: false);
        break;
      case 'newest':
      default:
        query = query.orderBy('createdAt', descending: true);
        break;
    }

    if (_searchQuery.isNotEmpty) {
      query = query.where('name', isGreaterThanOrEqualTo: _searchQuery)
          .where('name', isLessThan: _searchQuery + 'z');
    }

    if (_selectedCategory != 'All') {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAdmin) {
      return _buildNonAdminView();
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Menu Management'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProductDialog(),
            tooltip: 'Add New Product',
          ),
          if (widget.isAdmin) _buildSortDropdown(),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchFilterSection(),

          // Products List
          Expanded(
            child: _buildProductsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNonAdminView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [_buildSortDropdown()],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchFilterSection(),

          // Products Grid for non-admin
          Expanded(
            child: _buildProductsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Enhanced Search Bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(height: 16),

          // Enhanced Category Filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: const Color(0xFF6C63FF),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButton<String>(
      value: _sortBy,
      icon: const Icon(Icons.sort, color: Colors.black87),
      underline: const SizedBox(),
      onChanged: (String? newValue) {
        setState(() {
          _sortBy = newValue!;
        });
      },
      items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value.replaceAll('_', ' ').toUpperCase(),
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _filteredProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        final products = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final data = product.data() as Map<String, dynamic>;
            return _buildProductCard(product.id, data);
          },
        );
      },
    );
  }

  Widget _buildProductsGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _filteredProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final data = product.data() as Map<String, dynamic>;
            return _buildProductGridItem(product.id, data);
          },
        );
      },
    );
  }

  Widget _buildProductCard(String productId, Map<String, dynamic> data) {
    final price = data['price'] ?? 0.0;
    final discount = data['discount'] ?? 0.0;
    final finalPrice = price - (price * discount / 100);
    final isAvailable = data['available'] ?? true;
    final isSpecial = data['category'] == 'Special';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with SPECIAL badge
              _buildProductImageWithSpecialBadge(data['image'], isSpecial),
              const SizedBox(width: 12),

              // Product Details - Flexible to prevent overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name
                    Text(
                      data['restaurant']?.toUpperCase() ?? 'RESTAURANT NAME',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Product Name
                    Text(
                      data['name'] ?? 'Unknown Product',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      data['description'] ?? 'No description available',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Price Section
                    Row(
                      children: [
                        // Final Price
                        Text(
                          '\$${finalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Original Price with strikethrough
                        if (discount > 0)
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tags Row - Wrap to handle overflow
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        // Discount Badge
                        if (discount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${discount.toInt()}% OFF',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        // Special Tag
                        if (isSpecial)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFA726),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Special',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        // Availability Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isAvailable ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isAvailable ? 'Available' : 'Out of Stock',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Admin Actions
              if (widget.isAdmin) ...[
                const SizedBox(width: 8),
                _buildAdminActions(productId, data, isAvailable),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGridItem(String productId, Map<String, dynamic> data) {
    final price = data['price'] ?? 0.0;
    final discount = data['discount'] ?? 0.0;
    final finalPrice = price - (price * discount / 100);
    final isAvailable = data['available'] ?? true;
    final isSpecial = data['category'] == 'Special';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with SPECIAL badge
                _buildGridProductImage(data['image'], isSpecial),

                // Product Details
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurant Name
                      Text(
                        data['restaurant']?.toUpperCase() ?? 'RESTAURANT',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Product Name
                      Text(
                        data['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Price
                      Row(
                        children: [
                          Text(
                            '\$${finalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          if (discount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '${discount.toInt()}% OFF',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFFFF6B6B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Availability Badge
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isAvailable ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isAvailable ? 'In Stock' : 'Out',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Special Badge for grid
            if (isSpecial)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA726),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'SPECIAL',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Product image with SPECIAL badge
  Widget _buildProductImageWithSpecialBadge(String? imageUrl, bool isSpecial) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: (imageUrl != null && imageUrl.isNotEmpty)
              ? ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.fastfood, color: Colors.grey, size: 40),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          )
              : Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.fastfood, color: Colors.grey, size: 40),
          ),
        ),

        // SPECIAL badge
        if (isSpecial)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA726),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'SPECIAL',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Grid product image
  Widget _buildGridProductImage(String? imageUrl, bool isSpecial) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: (imageUrl != null && imageUrl.isNotEmpty)
              ? ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Icon(Icons.fastfood, color: Colors.grey, size: 40),
                );
              },
            ),
          )
              : Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Icon(Icons.fastfood, color: Colors.grey, size: 40),
          ),
        ),
      ],
    );
  }

  // Improved admin actions
  Widget _buildAdminActions(String productId, Map<String, dynamic> data, bool isAvailable) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.more_vert, size: 18),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          _showEditProductDialog(productId, data);
        } else if (value == 'delete') {
          _showDeleteConfirmation(productId, data['name'] ?? 'Product');
        } else if (value == 'toggle') {
          _toggleProductAvailability(productId, !isAvailable);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16, color: Colors.blue),
              SizedBox(width: 6),
              Text('Edit', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                isAvailable ? Icons.visibility_off : Icons.visibility,
                size: 16,
                color: isAvailable ? Colors.orange : Colors.green,
              ),
              const SizedBox(width: 6),
              Text(
                isAvailable ? 'Make Unavailable' : 'Make Available',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 16),
              SizedBox(width: 6),
              Text('Delete', style: TextStyle(fontSize: 12, color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fastfood_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No Products Yet' : 'No Products Found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Add your first product to get started'
                : 'Try adjusting your search or filters',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.isAdmin && _searchQuery.isEmpty) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showAddProductDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add First Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ========== CRUD OPERATIONS ==========

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => ProductFormDialog(
        onSave: _addProduct,
      ),
    );
  }

  void _showEditProductDialog(String productId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => ProductFormDialog(
        productId: productId,
        initialData: data,
        onSave: (productData) => _updateProduct(productId, productData),
      ),
    );
  }

  void _addProduct(Map<String, dynamic> productData) {
    _firestore.collection('food_items').add({
      ...productData,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'vendorId': widget.currentUserId,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding product: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _updateProduct(String productId, Map<String, dynamic> productData) {
    _firestore.collection('food_items').doc(productId).update({
      ...productData,
      'updatedAt': FieldValue.serverTimestamp(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating product: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _toggleProductAvailability(String productId, bool newStatus) {
    _firestore.collection('food_items').doc(productId).update({
      'available': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product ${newStatus ? 'enabled' : 'disabled'}!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _showDeleteConfirmation(String productId, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteProduct(productId);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(String productId) {
    _firestore.collection('food_items').doc(productId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting product: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}

// ========== PRODUCT FORM DIALOG ==========

class ProductFormDialog extends StatefulWidget {
  final String? productId;
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic> productData) onSave;

  const ProductFormDialog({
    super.key,
    this.productId,
    this.initialData,
    required this.onSave,
  });

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _restaurantController = TextEditingController();

  String _category = 'Food';
  double _discount = 0.0;
  bool _isAvailable = true;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
      _priceController.text = (widget.initialData!['price'] ?? 0.0).toString();
      _imageController.text = widget.initialData!['image'] ?? '';
      _descController.text = widget.initialData!['description'] ?? '';
      _restaurantController.text = widget.initialData!['restaurant'] ?? '';
      _category = widget.initialData!['category'] ?? 'Food';
      _discount = (widget.initialData!['discount'] ?? 0.0).toDouble();
      _isAvailable = widget.initialData!['available'] ?? true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _descController.dispose();
    _restaurantController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final productData = {
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text),
        'image': _imageController.text.trim(),
        'description': _descController.text.trim(),
        'restaurant': _restaurantController.text.trim(),
        'category': _category,
        'discount': _discount,
        'available': _isAvailable,
      };

      widget.onSave(productData);
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _imageController.text = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.productId != null;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Edit Product' : 'Add New Product',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Image Section
              _buildImageSection(),
              const SizedBox(height: 16),

              // Restaurant Field
              TextFormField(
                controller: _restaurantController,
                decoration: const InputDecoration(
                  labelText: 'Restaurant Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter restaurant name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price Field
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (\$)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: const [
                  DropdownMenuItem(value: 'Food', child: Text('Food')),
                  DropdownMenuItem(value: 'Beverage', child: Text('Beverage')),
                  DropdownMenuItem(value: 'Dessert', child: Text('Dessert')),
                  DropdownMenuItem(value: 'Snack', child: Text('Snack')),
                  DropdownMenuItem(value: 'Special', child: Text('Special')),
                ],
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Discount Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discount: ${_discount.toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Slider(
                    value: _discount,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: (value) {
                      setState(() {
                        _discount = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Availability Switch
              SwitchListTile(
                title: const Text('Available for Sale'),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(isEdit ? 'Update' : 'Add Product'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Image',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: _imageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_imageFile!, fit: BoxFit.cover),
            )
                : (_imageController.text.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _imageController.text,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      Text('Invalid Image URL'),
                    ],
                  );
                },
              ),
            )
                : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                Text('Tap to add image'),
              ],
            )),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _imageController,
          decoration: const InputDecoration(
            hintText: 'Or enter image URL',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty) _imageFile = null;
            });
          },
        ),
      ],
    );
  }
}




