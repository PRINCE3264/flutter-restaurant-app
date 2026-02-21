// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../models/food_item.dart';
// import '../../services/firestore_service.dart';
// import 'package:uuid/uuid.dart';
//
// class AddEditProductScreen extends StatefulWidget {
//   final FirestoreService firestoreService;
//   final FoodItem? foodItem;
//
//   const AddEditProductScreen({
//     super.key,
//     required this.firestoreService,
//     this.foodItem,
//   });
//
//   @override
//   State<AddEditProductScreen> createState() => _AddEditProductScreenState();
// }
//
// class _AddEditProductScreenState extends State<AddEditProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _picker = ImagePicker();
//   File? _pickedImage;
//
//   late TextEditingController _nameController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _priceController;
//   late TextEditingController _discountController;
//   double _rating = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController =
//         TextEditingController(text: widget.foodItem?.name ?? '');
//     _descriptionController =
//         TextEditingController(text: widget.foodItem?.description ?? '');
//     _priceController =
//         TextEditingController(text: widget.foodItem?.price.toString() ?? '');
//     _discountController =
//         TextEditingController(text: widget.foodItem?.discount.toString() ?? '');
//     _rating = widget.foodItem?.rating ?? 0;
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile =
//     await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
//     if (pickedFile != null) {
//       setState(() {
//         _pickedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> _saveProduct() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     // Generate new ID if adding a new product
//     String id = widget.foodItem?.id ?? const Uuid().v4();
//     String imageUrl = widget.foodItem?.image ?? '';
//
//     // Upload new image if selected
//     if (_pickedImage != null) {
//       imageUrl = await widget.firestoreService.uploadFoodImage(_pickedImage!);
//     }
//
//     // Create FoodItem object
//     final foodItem = FoodItem(
//       id: id,
//       name: _nameController.text.trim(),
//       description: _descriptionController.text.trim(),
//       price: double.tryParse(_priceController.text.trim()) ?? 0,
//       discount: double.tryParse(_discountController.text.trim()) ?? 0,
//       rating: _rating,
//       image: imageUrl,
//       quantity: widget.foodItem?.quantity ?? 1,
//       available: true,
//       vendorId: 'vendor_001',
//       vendorName: 'Vendor',
//     );
//
//     // Call FirestoreService methods correctly
//     if (widget.foodItem == null) {
//       await widget.firestoreService.addFoodItem(foodItem);
//     } else {
//       await widget.firestoreService
//           .updateFoodItem(foodItem.id, foodItem.toMap());
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Product saved successfully')),
//     );
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.foodItem == null ? 'Add Product' : 'Edit Product'),
//         backgroundColor: Colors.teal,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: _pickedImage != null
//                     ? Image.file(_pickedImage!, width: 120, height: 120, fit: BoxFit.cover)
//                     : widget.foodItem != null && widget.foodItem!.image.isNotEmpty
//                     ? Image.network(widget.foodItem!.image,
//                     width: 120, height: 120, fit: BoxFit.cover)
//                     : Container(
//                   width: 120,
//                   height: 120,
//                   color: Colors.teal.shade100,
//                   child: const Icon(Icons.add_a_photo, color: Colors.white, size: 40),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Product Name',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                 value == null || value.isEmpty ? 'Enter product name' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _descriptionController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _priceController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Price',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                 value == null || value.isEmpty ? 'Enter price' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _discountController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Discount (%)',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   const Text('Rating:'),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Slider(
//                       value: _rating,
//                       min: 0,
//                       max: 5,
//                       divisions: 5,
//                       label: _rating.toString(),
//                       onChanged: (value) {
//                         setState(() {
//                           _rating = value;
//                         });
//                       },
//                     ),
//                   ),
//                   Text(_rating.toString()),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _saveProduct,
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.teal, padding: const EdgeInsets.all(14)),
//                   child: const Text(
//                     'Save Product',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/food_item.dart';
import '../../services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class AddEditProductScreen extends StatefulWidget {
  final FirestoreService firestoreService;
  final FoodItem? foodItem;

  const AddEditProductScreen({
    super.key,
    required this.firestoreService,
    this.foodItem,
  });

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _pickedImage;

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.foodItem?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.foodItem?.description ?? '');
    _priceController =
        TextEditingController(text: widget.foodItem?.price.toString() ?? '');
    _discountController =
        TextEditingController(text: widget.foodItem?.discount.toString() ?? '');
    _rating = widget.foodItem?.rating ?? 0;
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    String id = widget.foodItem?.id ?? const Uuid().v4();
    String imageUrl = widget.foodItem?.image ?? '';

    if (_pickedImage != null) {
      imageUrl = await widget.firestoreService.uploadFoodImage(_pickedImage!);
    }

    final foodItem = FoodItem(
      id: id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      discount: double.tryParse(_discountController.text.trim()) ?? 0,
      rating: _rating,
      image: imageUrl,
      quantity: widget.foodItem?.quantity ?? 1,
      available: true,
      vendorId: 'vendor_001',
      vendorName: 'Vendor',
    );

    if (widget.foodItem == null) {
      await widget.firestoreService.addFoodItem(foodItem);
    } else {
      await widget.firestoreService
          .updateFoodItem(foodItem.id, foodItem.toMap());
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product saved successfully')),
    );
    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.teal.shade50,
      floatingLabelStyle: const TextStyle(color: Colors.teal),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text(widget.foodItem == null ? 'Add Product' : 'Edit Product'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadowColor: Colors.teal.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _pickedImage != null
                          ? Image.file(_pickedImage!,
                          width: 150, height: 150, fit: BoxFit.cover)
                          : widget.foodItem != null &&
                          widget.foodItem!.image.isNotEmpty
                          ? Image.network(widget.foodItem!.image,
                          width: 150, height: 150, fit: BoxFit.cover)
                          : Container(
                        width: 150,
                        height: 150,
                        color: Colors.teal.shade200,
                        child: const Icon(Icons.add_a_photo,
                            color: Colors.white, size: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Product Name'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Enter product name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: _inputDecoration('Description'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Price'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Enter price' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _discountController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Discount (%)'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Rating:'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Slider(
                          value: _rating,
                          min: 0,
                          max: 5,
                          divisions: 5,
                          label: _rating.toString(),
                          activeColor: Colors.teal,
                          onChanged: (value) {
                            setState(() {
                              _rating = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        _rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Product',
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
