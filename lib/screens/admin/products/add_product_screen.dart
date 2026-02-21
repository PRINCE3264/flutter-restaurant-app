// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:image_picker/image_picker.dart';
// // // import 'package:uuid/uuid.dart';
// // // import '../../../models/food_item.dart';
// // // import '../../services/firestore_service.dart';
// // //
// // // class AddProductTab extends StatefulWidget {
// // //   final FirestoreService firestoreService;
// // //
// // //   const AddProductTab({super.key, required this.firestoreService});
// // //
// // //   @override
// // //   State<AddProductTab> createState() => _AddProductTabState();
// // // }
// // //
// // // class _AddProductTabState extends State<AddProductTab> {
// // //   final _formKey = GlobalKey<FormState>();
// // //
// // //   final TextEditingController _nameController = TextEditingController();
// // //   final TextEditingController _descController = TextEditingController();
// // //   final TextEditingController _priceController = TextEditingController();
// // //   final TextEditingController _discountController = TextEditingController();
// // //   final TextEditingController _imageUrlController = TextEditingController();
// // //
// // //   bool _available = true;
// // //   File? _imageFile;
// // //
// // //   final ImagePicker _picker = ImagePicker();
// // //
// // //   @override
// // //   void dispose() {
// // //     _nameController.dispose();
// // //     _descController.dispose();
// // //     _priceController.dispose();
// // //     _discountController.dispose();
// // //     _imageUrlController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   Future<void> _pickImage(ImageSource source) async {
// // //     final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
// // //     if (pickedFile != null) {
// // //       setState(() {
// // //         _imageFile = File(pickedFile.path);
// // //         _imageUrlController.clear();
// // //       });
// // //     }
// // //   }
// // //
// // //   void _saveProduct() async {
// // //     if (_formKey.currentState!.validate()) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('Processing Data...')),
// // //       );
// // //
// // //       String finalImageUrl = _imageUrlController.text.trim();
// // //       if (_imageFile != null) {
// // //         finalImageUrl = await widget.firestoreService.uploadFoodImage(_imageFile!);
// // //       }
// // //
// // //       final foodItem = FoodItem(
// // //         id: const Uuid().v4(),
// // //         name: _nameController.text.trim(),
// // //         description: _descController.text.trim(),
// // //         image: finalImageUrl,
// // //         price: double.tryParse(_priceController.text) ?? 0.0,
// // //         discount: double.tryParse(_discountController.text) ?? 0.0,
// // //         available: _available,
// // //         vendorId: 'default_vendor',
// // //       );
// // //
// // //       await widget.firestoreService.addFoodItem(foodItem);
// // //
// // //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('Product added successfully!'), backgroundColor: Colors.green),
// // //       );
// // //
// // //       _formKey.currentState!.reset();
// // //       setState(() {
// // //         _imageFile = null;
// // //         _available = true;
// // //         _nameController.clear();
// // //         _descController.clear();
// // //         _priceController.clear();
// // //         _discountController.clear();
// // //         _imageUrlController.clear();
// // //       });
// // //     }
// // //   }
// // //
// // //   void _showImageSourceDialog() {
// // //     showDialog(
// // //       context: context,
// // //       builder: (_) => AlertDialog(
// // //         title: const Text('Select Image Source'),
// // //         content: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             ListTile(
// // //               leading: const Icon(Icons.photo_library),
// // //               title: const Text('Gallery'),
// // //               onTap: () {
// // //                 Navigator.pop(context);
// // //                 _pickImage(ImageSource.gallery);
// // //               },
// // //             ),
// // //             ListTile(
// // //               leading: const Icon(Icons.camera_alt),
// // //               title: const Text('Camera'),
// // //               onTap: () {
// // //                 Navigator.pop(context);
// // //                 _pickImage(ImageSource.camera);
// // //               },
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildTextField(TextEditingController controller, String label,
// // //       {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
// // //     return TextFormField(
// // //       controller: controller,
// // //       decoration: InputDecoration(
// // //         labelText: label,
// // //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// // //         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // //       ),
// // //       maxLines: maxLines,
// // //       keyboardType: keyboardType,
// // //       validator: (value) => value == null || value.isEmpty ? 'Please enter the $label' : null,
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SingleChildScrollView(
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Form(
// // //           key: _formKey,
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               // Image preview container
// // //               AnimatedContainer(
// // //                 duration: const Duration(milliseconds: 400),
// // //                 width: double.infinity,
// // //                 height: 180,
// // //                 decoration: BoxDecoration(
// // //                   gradient: const LinearGradient(
// // //                     colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
// // //                   ),
// // //                   borderRadius: BorderRadius.circular(16),
// // //                   border: Border.all(color: Colors.grey.shade400),
// // //                 ),
// // //                 child: _imageFile != null
// // //                     ? ClipRRect(
// // //                   borderRadius: BorderRadius.circular(16),
// // //                   child: Image.file(_imageFile!, fit: BoxFit.cover),
// // //                 )
// // //                     : (_imageUrlController.text.isNotEmpty)
// // //                     ? ClipRRect(
// // //                   borderRadius: BorderRadius.circular(16),
// // //                   child: Image.network(
// // //                     _imageUrlController.text,
// // //                     fit: BoxFit.cover,
// // //                     errorBuilder: (_, __, ___) =>
// // //                     const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.white)),
// // //                   ),
// // //                 )
// // //                     : Center(
// // //                   child: IconButton(
// // //                     icon: const Icon(Icons.add_a_photo, size: 50, color: Colors.white),
// // //                     onPressed: _showImageSourceDialog,
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 12),
// // //               // Optional image URL input
// // //               TextFormField(
// // //                 controller: _imageUrlController,
// // //                 decoration: InputDecoration(
// // //                   labelText: 'Or Enter Image URL',
// // //                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// // //                   contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // //                 ),
// // //                 onChanged: (val) {
// // //                   setState(() {
// // //                     if (val.isNotEmpty) _imageFile = null;
// // //                   });
// // //                 },
// // //               ),
// // //               const SizedBox(height: 20),
// // //               _buildTextField(_nameController, 'Product Name'),
// // //               const SizedBox(height: 12),
// // //               _buildTextField(_descController, 'Description', maxLines: 3),
// // //               const SizedBox(height: 12),
// // //               _buildTextField(_priceController, 'Price', keyboardType: TextInputType.number),
// // //               const SizedBox(height: 12),
// // //               _buildTextField(_discountController, 'Discount (%)', keyboardType: TextInputType.number),
// // //               const SizedBox(height: 12),
// // //               SwitchListTile(
// // //                 value: _available,
// // //                 onChanged: (val) => setState(() => _available = val),
// // //                 title: const Text('Available'),
// // //                 activeColor: Colors.deepPurple,
// // //               ),
// // //               const SizedBox(height: 20),
// // //               SizedBox(
// // //                 width: double.infinity,
// // //                 child: ElevatedButton.icon(
// // //                   onPressed: _saveProduct,
// // //                   icon: const Icon(Icons.add_shopping_cart),
// // //                   label: const Text('Add Product'),
// // //                   style: ElevatedButton.styleFrom(
// // //                     backgroundColor: Colors.deepPurple,
// // //                     foregroundColor: Colors.white,
// // //                     padding: const EdgeInsets.symmetric(vertical: 14),
// // //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //                     textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // //
// // //
// // //
// //
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:intl/intl.dart';
// //
// // const String RAZORPAY_KEY = 'rzp_test_RGlPdevCgkpRiA';
// //
// // class AddProductTab extends StatefulWidget {
// //   final bool isAdmin;
// //   final String currentUserId;
// //
// //   const AddProductTab({super.key, this.isAdmin = false, required this.currentUserId});
// //
// //   @override
// //   State<AddProductTab> createState() => _OrderPageState();
// // }
// //
// // class _OrderPageState extends State<AddProductTab> with SingleTickerProviderStateMixin {
// //   late Razorpay _razorpay;
// //   int? _pendingAmountPaise;
// //   String? _currentOrderId;
// //   final List<Map<String, dynamic>> _cart = [];
// //   final double _fuelCharge = 20.0;
// //   final List<String> statusSteps = ["Placed", "Accepted", "Preparing", "Ready", "Completed"];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _razorpay = Razorpay();
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _razorpay.clear();
// //     super.dispose();
// //   }
// //
// //   double get _cartTotal => _cart.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
// //
// //   void showToast(String msg, {Color bgColor = Colors.black}) {
// //     Fluttertoast.showToast(msg: msg, backgroundColor: bgColor, textColor: Colors.white);
// //   }
// //
// //   // ------------------ ADMIN: Add Food Dialog ------------------
// //   void _showAddFoodDialog() {
// //     if (!widget.isAdmin) return;
// //
// //     final formKey = GlobalKey<FormState>();
// //     String name = '';
// //     String price = '';
// //     String image = '';
// //     String description = '';
// //     bool isLoading = false;
// //
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (ctx) => StatefulBuilder(
// //         builder: (context, setDialogState) {
// //           return AlertDialog(
// //             title: const Text('Add New Food Item'),
// //             content: SingleChildScrollView(
// //               child: Form(
// //                 key: formKey,
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     TextFormField(
// //                       decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g., Veg Burger'),
// //                       validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
// //                       onSaved: (val) => name = val!,
// //                     ),
// //                     TextFormField(
// //                       decoration: const InputDecoration(labelText: 'Price', hintText: 'e.g., 99.0'),
// //                       keyboardType: TextInputType.number,
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) return 'Please enter a price';
// //                         if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Enter a valid price';
// //                         return null;
// //                       },
// //                       onSaved: (val) => price = val!,
// //                     ),
// //                     TextFormField(
// //                       decoration: const InputDecoration(labelText: 'Image URL (optional)'),
// //                       keyboardType: TextInputType.url,
// //                       onSaved: (val) => image = val ?? '',
// //                     ),
// //                     TextFormField(
// //                       decoration: const InputDecoration(labelText: 'Description', hintText: 'e.g., Delicious burger with cheese'),
// //                       maxLines: 2,
// //                       onSaved: (val) => description = val ?? '',
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             actions: [
// //               TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
// //               ElevatedButton(
// //                 onPressed: isLoading
// //                     ? null
// //                     : () async {
// //                   if (formKey.currentState!.validate()) {
// //                     formKey.currentState!.save();
// //                     setDialogState(() => isLoading = true);
// //
// //                     try {
// //                       final docRef = FirebaseFirestore.instance.collection('food_items').doc();
// //                       await docRef.set({
// //                         'id': docRef.id,
// //                         'name': name,
// //                         'price': double.parse(price),
// //                         'image': image,
// //                         'description': description,
// //                         'available': true,
// //                         'rating': 0,
// //                         'discount': 0,
// //                         'vendorId': 'default_vendor',
// //                       });
// //
// //                       showToast('Food item added successfully!', bgColor: Colors.green);
// //                       Navigator.pop(ctx);
// //                     } catch (e) {
// //                       showToast('Error: $e', bgColor: Colors.red);
// //                       setDialogState(() => isLoading = false);
// //                     }
// //                   }
// //                 },
// //                 child: isLoading
// //                     ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
// //                     : const Text('Add'),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   // ------------------ Payment Functions ------------------
// //   void _startPayment(String orderId, double amount) {
// //     final int paise = (amount * 100).toInt();
// //     _pendingAmountPaise = paise;
// //     _currentOrderId = orderId;
// //     var options = {
// //       'key': RAZORPAY_KEY,
// //       'amount': paise,
// //       'currency': 'INR',
// //       'name': 'Demo App',
// //       'description': 'Order Payment'
// //     };
// //     try {
// //       _razorpay.open(options);
// //     } catch (e) {
// //       showToast('Payment Error: $e', bgColor: Colors.red);
// //     }
// //   }
// //
// //   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
// //     if (_pendingAmountPaise == null || _currentOrderId == null) return;
// //     final orderDoc = FirebaseFirestore.instance.collection('orders').doc(_currentOrderId);
// //     try {
// //       await orderDoc.update({'status': 'Completed'});
// //       showToast('Payment successful!', bgColor: Colors.green);
// //     } catch (e) {
// //       showToast('Error updating order: $e', bgColor: Colors.red);
// //     }
// //     _pendingAmountPaise = null;
// //     _currentOrderId = null;
// //   }
// //
// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     showToast('Payment failed: ${response.message}', bgColor: Colors.red);
// //     _pendingAmountPaise = null;
// //     _currentOrderId = null;
// //   }
// //
// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     showToast('External wallet: ${response.walletName}', bgColor: Colors.orange);
// //     _pendingAmountPaise = null;
// //     _currentOrderId = null;
// //   }
// //
// //   // ------------------ Order Status Helper ------------------
// //   Color _getStatusColor(String step, String currentStatus) {
// //     int stepIndex = statusSteps.indexOf(step);
// //     int currentIndex = statusSteps.indexOf(currentStatus);
// //     if (stepIndex <= currentIndex) return Colors.green;
// //     if (stepIndex == currentIndex + 1) return Colors.orange;
// //     return Colors.grey;
// //   }
// //
// //   Widget _buildStatusStepper(String currentStatus) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //       child: Row(
// //         children: List.generate(statusSteps.length * 2 - 1, (index) {
// //           if (index.isEven) {
// //             final stepIndex = index ~/ 2;
// //             final step = statusSteps[stepIndex];
// //             final color = _getStatusColor(step, currentStatus);
// //             return Column(
// //               children: [
// //                 CircleAvatar(radius: 12, backgroundColor: color, child: Icon(Icons.check, color: Colors.white, size: 14)),
// //                 const SizedBox(height: 4),
// //                 Text(step, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
// //               ],
// //             );
// //           } else {
// //             final prevStepIndex = (index - 1) ~/ 2;
// //             final prevStep = statusSteps[prevStepIndex];
// //             final color = _getStatusColor(prevStep, currentStatus);
// //             return Expanded(child: Container(height: 2, color: color, margin: const EdgeInsets.only(bottom: 20)));
// //           }
// //         }),
// //       ),
// //     );
// //   }
// //
// //   // ------------------ UI Build ------------------
// //   @override
// //   Widget build(BuildContext context) {
// //     final Stream<QuerySnapshot> orderStream = widget.isAdmin
// //         ? FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots()
// //         : FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: widget.currentUserId).orderBy('createdAt', descending: true).snapshots();
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.isAdmin ? "Admin Orders" : "My Orders"),
// //         actions: widget.isAdmin
// //             ? [
// //           Padding(
// //             padding: const EdgeInsets.only(right: 12.0),
// //             child: CircleAvatar(
// //               backgroundColor: Colors.deepOrange,
// //               child: IconButton(
// //                 onPressed: _showAddFoodDialog,
// //                 icon: const Icon(Icons.add, color: Colors.white),
// //                 tooltip: 'Add Food Item',
// //               ),
// //             ),
// //           )
// //         ]
// //             : null,
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: orderStream,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
// //           if (snapshot.hasError) return const Center(child: Text("An error occurred."));
// //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("No orders yet."));
// //
// //           final orders = snapshot.data!.docs;
// //
// //           return ListView.builder(
// //             padding: const EdgeInsets.all(8),
// //             itemCount: orders.length,
// //             itemBuilder: (context, index) {
// //               final data = orders[index].data() as Map<String, dynamic>;
// //               final orderId = orders[index].id;
// //               final items = (data['items'] ?? []) as List;
// //
// //               return Card(
// //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //                 elevation: 4,
// //                 margin: const EdgeInsets.symmetric(vertical: 8),
// //                 child: ExpansionTile(
// //                   tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                   childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
// //                   title: Text("Order #${orderId.substring(0, 6)}", style: const TextStyle(fontWeight: FontWeight.bold)),
// //                   subtitle: Text("Total: ₹${data['total']} | Status: ${data['status']}"),
// //                   children: [
// //                     _buildStatusStepper(data['status']),
// //                     const Divider(height: 20),
// //                     ...items.map((item) {
// //                       final map = item as Map<String, dynamic>;
// //                       return ListTile(
// //                         leading: (map['image'] != null && map['image'] != '')
// //                             ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(map['image'], width: 50, height: 50, fit: BoxFit.cover))
// //                             : const Icon(Icons.fastfood, size: 40),
// //                         title: Text(map['name']),
// //                         subtitle: Text("${map['description'] ?? ''}\nQty: ${map['quantity']}"), // ✅ show description
// //                         trailing: Text("₹${(map['price'] * map['quantity']).toStringAsFixed(2)}"),
// //                         isThreeLine: true,
// //                       );
// //                     }).toList(),
// //                     const SizedBox(height: 8),
// //                     Align(
// //                       alignment: Alignment.centerRight,
// //                       child: Text(
// //                         "Ordered on: ${DateFormat('dd MMM yyyy, hh:mm a').format((data['createdAt'] as Timestamp).toDate())}",
// //                         style: const TextStyle(fontSize: 12, color: Colors.grey),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //       bottomNavigationBar: _cart.isNotEmpty
// //           ? Container(
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text('Total: ₹${(_cartTotal + _fuelCharge).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //             ElevatedButton.icon(
// //               icon: const Icon(Icons.shopping_cart_checkout),
// //               label: const Text('Place Order'),
// //               style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
// //               onPressed: _placeOrder,
// //             ),
// //           ],
// //         ),
// //       )
// //           : null,
// //     );
// //   }
// //
// //   // ------------------ Place Order ------------------
// //   Future<void> _placeOrder() async {
// //     if (_cart.isEmpty) return;
// //     final orderItems = _cart.map((item) => {
// //       'name': item['name'],
// //       'price': item['price'],
// //       'quantity': item['quantity'],
// //       'image': item['image'],
// //       'description': item['description'] ?? '',
// //       'vendorId': item['vendorId'],
// //     }).toList();
// //
// //     final orderTotal = _cartTotal + _fuelCharge;
// //     final orderDoc = FirebaseFirestore.instance.collection('orders').doc();
// //
// //     await orderDoc.set({
// //       'items': orderItems,
// //       'fuelCharge': _fuelCharge,
// //       'total': orderTotal,
// //       'status': 'Placed',
// //       'createdAt': FieldValue.serverTimestamp(),
// //       'userId': widget.currentUserId,
// //     });
// //
// //     showToast('Order placed successfully!', bgColor: Colors.green);
// //     setState(() => _cart.clear());
// //     if (!widget.isAdmin) _startPayment(orderDoc.id, orderTotal);
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AddProductTab extends StatefulWidget {
//   final bool isAdmin;
//   final String currentUserId;
//
//   const AddProductTab({super.key, required this.isAdmin, required this.currentUserId});
//
//   @override
//   State<AddProductTab> createState() => _AddProductTabState();
// }
//
// class _AddProductTabState extends State<AddProductTab> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//
//   String name = '';
//   String price = '';
//   String image = '';
//   String description = '';
//
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//       lowerBound: 0.0,
//       upperBound: 0.05,
//     );
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _saveProduct() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     _formKey.currentState!.save();
//     setState(() => isLoading = true);
//
//     try {
//       final docRef = FirebaseFirestore.instance.collection('food_items').doc();
//       await docRef.set({
//         'id': docRef.id,
//         'name': name,
//         'price': double.parse(price),
//         'image': image,
//         'description': description,
//         'available': true,
//         'rating': 0,
//         'discount': 0,
//         'vendorId': widget.currentUserId,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Product added successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//
//       _formKey.currentState!.reset();
//       setState(() => isLoading = false);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       setState(() => isLoading = false);
//     }
//   }
//
//   Widget _animatedButton({required Widget child, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTapDown: (_) => _controller.forward(),
//       onTapUp: (_) => _controller.reverse(),
//       onTapCancel: () => _controller.reverse(),
//       onTap: onTap,
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, childWidget) {
//           return Transform.scale(
//             scale: _scaleAnimation.value,
//             child: childWidget,
//           );
//         },
//         child: child,
//       ),
//     );
//   }
//
//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       filled: true,
//       fillColor: Colors.white,
//       floatingLabelStyle: const TextStyle(color: Colors.deepPurple),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red, width: 2),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!widget.isAdmin) {
//       return const Center(
//         child: Text(
//           "Only admins can add products.",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       );
//     }
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 8,
//         shadowColor: Colors.deepPurple.withOpacity(0.3),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Text(
//                   "Add New Product",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.deepPurple.shade700,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   decoration: _inputDecoration('Name'),
//                   validator: (val) => val == null || val.isEmpty ? 'Enter product name' : null,
//                   onSaved: (val) => name = val!,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   decoration: _inputDecoration('Price'),
//                   keyboardType: TextInputType.number,
//                   validator: (val) {
//                     if (val == null || val.isEmpty) return 'Enter price';
//                     if (double.tryParse(val) == null || double.parse(val) <= 0) return 'Invalid price';
//                     return null;
//                   },
//                   onSaved: (val) => price = val!,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   decoration: _inputDecoration('Image URL (optional)'),
//                   onSaved: (val) => image = val ?? '',
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   decoration: _inputDecoration('Description'),
//                   maxLines: 3,
//                   onSaved: (val) => description = val ?? '',
//                 ),
//                 const SizedBox(height: 24),
//                 _animatedButton(
//                   onTap: isLoading ? () {} : _saveProduct,
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       gradient: const LinearGradient(
//                         colors: [Colors.deepPurple, Colors.purpleAccent],
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.purpleAccent.withOpacity(0.4),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: isLoading
//                           ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 3,
//                         ),
//                       )
//                           : const Text(
//                         "Add Product",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AddProductTab extends StatefulWidget {
  final bool isAdmin;
  final String currentUserId;

  const AddProductTab({super.key, required this.isAdmin, required this.currentUserId});

  @override
  State<AddProductTab> createState() => _AddProductTabState();
}

class _AddProductTabState extends State<AddProductTab> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String name = '';
  String price = '';
  String image = '';
  String description = '';
  String category = 'Food';
  double discount = 0.0;
  bool isAvailable = true;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _buttonColorAnimation;

  final List<String> categories = ['Food', 'Beverage', 'Dessert', 'Snack', 'Special'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _buttonColorAnimation = ColorTween(
      begin: const Color(0xFF6C63FF),
      end: const Color(0xFF4A44B8),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => isLoading = true);

    try {
      final docRef = FirebaseFirestore.instance.collection('food_items').doc();
      await docRef.set({
        'id': docRef.id,
        'name': name,
        'price': double.parse(price),
        'image': image,
        'description': description,
        'category': category,
        'discount': discount,
        'available': isAvailable,
        'rating': 0,
        'vendorId': widget.currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _showSuccessDialog();
      _formKey.currentState!.reset();
      setState(() {
        isLoading = false;
        category = 'Food';
        discount = 0.0;
        isAvailable = true;
      });
    } catch (e) {
      _showErrorDialog(e.toString());
      setState(() => isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 40, color: Colors.green),
              ),
              const SizedBox(height: 16),
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Product added successfully',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _formKey.currentState!.reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add Another Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline, size: 40, color: Colors.red),
              ),
              const SizedBox(height: 16),
              const Text(
                'Error',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Try Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (image.isEmpty) {
      return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 50, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'Image Preview',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 50, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'Invalid Image URL',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey.shade100,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          onSaved: onSaved,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAdmin) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Admin Access Required",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              "Only administrators can add products",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4A44B8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.add_circle_outline, size: 50, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    "Add New Product",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Fill in the details below to add a new product",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Card
            Card(
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Image Preview
                      _buildImagePreview(),
                      const SizedBox(height: 20),

                      // Image URL Field
                      _buildFormField(
                        label: "Image URL",
                        hintText: "https://example.com/image.jpg",
                        validator: (val) => null,
                        onSaved: (val) => image = val ?? '',
                      ),

                      // Product Name
                      _buildFormField(
                        label: "Product Name",
                        hintText: "Enter product name",
                        validator: (val) => val == null || val.isEmpty ? 'Please enter product name' : null,
                        onSaved: (val) => name = val!,
                      ),

                      // Price
                      _buildFormField(
                        label: "Price (₹)",
                        hintText: "99.99",
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Please enter price';
                          if (double.tryParse(val) == null) return 'Please enter valid price';
                          if (double.parse(val) <= 0) return 'Price must be greater than 0';
                          return null;
                        },
                        onSaved: (val) => price = val!,
                      ),

                      // Category Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Category",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: category,
                                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6C63FF)),
                                isExpanded: true,
                                items: categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    category = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),

                      // Description
                      _buildFormField(
                        label: "Description",
                        hintText: "Enter product description",
                        maxLines: 3,
                        validator: (val) => null,
                        onSaved: (val) => description = val ?? '',
                      ),

                      // Discount Slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Discount",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "${discount.toInt()}%",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            value: discount,
                            min: 0,
                            max: 100,
                            divisions: 20,
                            activeColor: const Color(0xFF6C63FF),
                            inactiveColor: Colors.grey.shade300,
                            onChanged: (value) {
                              setState(() {
                                discount = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),

                      // Availability Switch
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SwitchListTile.adaptive(
                          title: const Text(
                            "Available for Sale",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          value: isAvailable,
                          activeColor: const Color(0xFF6C63FF),
                          onChanged: (value) {
                            setState(() {
                              isAvailable = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Material(
                              elevation: 8,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: isLoading
                                        ? [Colors.grey.shade400, Colors.grey.shade500]
                                        : [_buttonColorAnimation.value!, const Color(0xFF4A44B8)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6C63FF).withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTapDown: (_) => _controller.forward(),
                                    onTapUp: (_) => _controller.reverse(),
                                    onTapCancel: () => _controller.reverse(),
                                    onTap: isLoading ? null : _saveProduct,
                                    child: Center(
                                      child: isLoading
                                          ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        ),
                                      )
                                          : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_circle, color: Colors.white),
                                          SizedBox(width: 8),
                                          Text(
                                            "Add Product",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}