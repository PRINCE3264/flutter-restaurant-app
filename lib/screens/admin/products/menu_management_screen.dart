import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MenuManagementPage extends StatefulWidget {
  final bool isAdmin;
  final String currentUserId;

  const MenuManagementPage({
    super.key,
    required this.isAdmin,
    required this.currentUserId,
  });

  @override
  State<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _categories = ['All', 'Food', 'Beverage', 'Dessert', 'Snack', 'Special'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Get filtered products based on search and category
  Stream<QuerySnapshot> get _filteredProducts {
    Query query = _firestore.collection('food_items').orderBy('createdAt', descending: true);

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
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),

          // Category Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: const Color(0xFF6C63FF),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
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
            childAspectRatio: 0.8,
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

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            _buildProductImage(data['image']),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['description'] ?? 'No description',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₹${finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (discount > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '₹${price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${discount.toInt()}% OFF',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          data['category'] ?? 'Uncategorized',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isAvailable ? 'Available' : 'Out of Stock',
                          style: TextStyle(
                            fontSize: 10,
                            color: isAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
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
              const SizedBox(width: 12),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
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
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(isAvailable ? Icons.visibility_off : Icons.visibility, size: 18),
                        const SizedBox(width: 8),
                        Text(isAvailable ? 'Make Unavailable' : 'Make Available'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductGridItem(String productId, Map<String, dynamic> data) {
    final price = data['price'] ?? 0.0;
    final discount = data['discount'] ?? 0.0;
    final finalPrice = price - (price * discount / 100);
    final isAvailable = data['available'] ?? true;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                flex: 2,
                child: _buildProductImage(data['image']),
              ),

              // Product Details
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (discount > 0) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${discount.toInt()}% OFF',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Availability Badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isAvailable ? 'In Stock' : 'Out',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: (imageUrl != null && imageUrl.isNotEmpty)
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.fastfood, color: Colors.grey);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
      )
          : const Icon(Icons.fastfood, color: Colors.grey),
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
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final productData = {
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text),
        'image': _imageController.text.trim(),
        'description': _descController.text.trim(),
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
        _imageController.text = image.path; // For demo, in real app you'd upload this
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

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
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
                  labelText: 'Price (₹)',
                  border: OutlineInputBorder(),
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
                  Text('Discount: ${_discount.toInt()}%'),
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
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: _imageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(_imageFile!, fit: BoxFit.cover),
            )
                : (_imageController.text.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
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