//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
//
// const String RAZORPAY_KEY = 'rzp_test_RGlPdevCgkpRiA';
//
// class OrderPagess extends StatefulWidget {
//   final bool isAdmin;
//   final String currentUserId;
//
//   const OrderPagess({super.key, this.isAdmin = false, required this.currentUserId});
//
//   @override
//   State<OrderPagess> createState() => _OrderPageState();
// }
//
// class _OrderPageState extends State<OrderPagess> with SingleTickerProviderStateMixin {
//   late Razorpay _razorpay;
//   int? _pendingAmountPaise;
//   String? _currentOrderId;
//   final List<Map<String, dynamic>> _cart = [];
//   final double _fuelCharge = 20.0;
//   final List<String> statusSteps = ["Placed", "Accepted", "Preparing", "Ready", "Completed"];
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   double get _cartTotal => _cart.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
//
//   void showToast(String msg, {Color bgColor = Colors.black}) {
//     Fluttertoast.showToast(msg: msg, backgroundColor: bgColor, textColor: Colors.white);
//   }
//
//   // ------------------ ADMIN: Add Food Dialog ------------------
//   void _showAddFoodDialog() {
//     if (!widget.isAdmin) return;
//
//     final formKey = GlobalKey<FormState>();
//     String name = '';
//     String price = '';
//     String image = '';
//     String description = '';
//     bool isLoading = false;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setDialogState) {
//           return AlertDialog(
//             title: const Text('Add New Food Item'),
//             content: SingleChildScrollView(
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g., Veg Burger'),
//                       validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
//                       onSaved: (val) => name = val!,
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Price', hintText: 'e.g., 99.0'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) return 'Please enter a price';
//                         if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Enter a valid price';
//                         return null;
//                       },
//                       onSaved: (val) => price = val!,
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Image URL (optional)'),
//                       keyboardType: TextInputType.url,
//                       onSaved: (val) => image = val ?? '',
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Description', hintText: 'e.g., Delicious burger with cheese'),
//                       maxLines: 2,
//                       onSaved: (val) => description = val ?? '',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
//               ElevatedButton(
//                 onPressed: isLoading
//                     ? null
//                     : () async {
//                   if (formKey.currentState!.validate()) {
//                     formKey.currentState!.save();
//                     setDialogState(() => isLoading = true);
//
//                     try {
//                       final docRef = FirebaseFirestore.instance.collection('food_items').doc();
//                       await docRef.set({
//                         'id': docRef.id,
//                         'name': name,
//                         'price': double.parse(price),
//                         'image': image,
//                         'description': description,
//                         'available': true,
//                         'rating': 0,
//                         'discount': 0,
//                         'vendorId': 'default_vendor',
//                       });
//
//                       showToast('Food item added successfully!', bgColor: Colors.green);
//                       Navigator.pop(ctx);
//                     } catch (e) {
//                       showToast('Error: $e', bgColor: Colors.red);
//                       setDialogState(() => isLoading = false);
//                     }
//                   }
//                 },
//                 child: isLoading
//                     ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                     : const Text('Add'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // ------------------ Payment Functions ------------------
//   void _startPayment(String orderId, double amount) {
//     final int paise = (amount * 100).toInt();
//     _pendingAmountPaise = paise;
//     _currentOrderId = orderId;
//     var options = {
//       'key': RAZORPAY_KEY,
//       'amount': paise,
//       'currency': 'INR',
//       'name': 'Demo App',
//       'description': 'Order Payment'
//     };
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       showToast('Payment Error: $e', bgColor: Colors.red);
//     }
//   }
//
//   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     if (_pendingAmountPaise == null || _currentOrderId == null) return;
//     final orderDoc = FirebaseFirestore.instance.collection('orders').doc(_currentOrderId);
//     try {
//       await orderDoc.update({'status': 'Completed'});
//       showToast('Payment successful!', bgColor: Colors.green);
//     } catch (e) {
//       showToast('Error updating order: $e', bgColor: Colors.red);
//     }
//     _pendingAmountPaise = null;
//     _currentOrderId = null;
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     showToast('Payment failed: ${response.message}', bgColor: Colors.red);
//     _pendingAmountPaise = null;
//     _currentOrderId = null;
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     showToast('External wallet: ${response.walletName}', bgColor: Colors.orange);
//     _pendingAmountPaise = null;
//     _currentOrderId = null;
//   }
//
//   // ------------------ Order Status Helper ------------------
//   Color _getStatusColor(String step, String currentStatus) {
//     int stepIndex = statusSteps.indexOf(step);
//     int currentIndex = statusSteps.indexOf(currentStatus);
//     if (stepIndex <= currentIndex) return Colors.green;
//     if (stepIndex == currentIndex + 1) return Colors.orange;
//     return Colors.grey;
//   }
//
//   Widget _buildStatusStepper(String currentStatus) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: List.generate(statusSteps.length * 2 - 1, (index) {
//           if (index.isEven) {
//             final stepIndex = index ~/ 2;
//             final step = statusSteps[stepIndex];
//             final color = _getStatusColor(step, currentStatus);
//             return Column(
//               children: [
//                 CircleAvatar(radius: 12, backgroundColor: color, child: Icon(Icons.check, color: Colors.white, size: 14)),
//                 const SizedBox(height: 4),
//                 Text(step, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
//               ],
//             );
//           } else {
//             final prevStepIndex = (index - 1) ~/ 2;
//             final prevStep = statusSteps[prevStepIndex];
//             final color = _getStatusColor(prevStep, currentStatus);
//             return Expanded(child: Container(height: 2, color: color, margin: const EdgeInsets.only(bottom: 20)));
//           }
//         }),
//       ),
//     );
//   }
//
//   // ------------------ UI Build ------------------
//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> orderStream = widget.isAdmin
//         ? FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots()
//         : FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: widget.currentUserId).orderBy('createdAt', descending: true).snapshots();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isAdmin ? "Admin Orders" : "My Orders"),
//         actions: widget.isAdmin
//             ? [
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: CircleAvatar(
//               backgroundColor: Colors.deepOrange,
//               child: IconButton(
//                 onPressed: _showAddFoodDialog,
//                 icon: const Icon(Icons.add, color: Colors.white),
//                 tooltip: 'Add Food Item',
//               ),
//             ),
//           )
//         ]
//             : null,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: orderStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
//           if (snapshot.hasError) return const Center(child: Text("An error occurred."));
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("No orders yet."));
//
//           final orders = snapshot.data!.docs;
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               final data = orders[index].data() as Map<String, dynamic>;
//               final orderId = orders[index].id;
//               final items = (data['items'] ?? []) as List;
//
//               return Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 elevation: 4,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child: ExpansionTile(
//                   tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                   title: Text("Order #${orderId.substring(0, 6)}", style: const TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Text("Total: ₹${data['total']} | Status: ${data['status']}"),
//                   children: [
//                     _buildStatusStepper(data['status']),
//                     const Divider(height: 20),
//                     ...items.map((item) {
//                       final map = item as Map<String, dynamic>;
//                       return ListTile(
//                         leading: (map['image'] != null && map['image'] != '')
//                             ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(map['image'], width: 50, height: 50, fit: BoxFit.cover))
//                             : const Icon(Icons.fastfood, size: 40),
//                         title: Text(map['name']),
//                         subtitle: Text("${map['description'] ?? ''}\nQty: ${map['quantity']}"), // ✅ show description
//                         trailing: Text("₹${(map['price'] * map['quantity']).toStringAsFixed(2)}"),
//                         isThreeLine: true,
//                       );
//                     }).toList(),
//                     const SizedBox(height: 8),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: Text(
//                         "Ordered on: ${DateFormat('dd MMM yyyy, hh:mm a').format((data['createdAt'] as Timestamp).toDate())}",
//                         style: const TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: _cart.isNotEmpty
//           ? Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Total: ₹${(_cartTotal + _fuelCharge).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.shopping_cart_checkout),
//               label: const Text('Place Order'),
//               style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//               onPressed: _placeOrder,
//             ),
//           ],
//         ),
//       )
//           : null,
//     );
//   }
//
//   // ------------------ Place Order ------------------
//   Future<void> _placeOrder() async {
//     if (_cart.isEmpty) return;
//     final orderItems = _cart.map((item) => {
//       'name': item['name'],
//       'price': item['price'],
//       'quantity': item['quantity'],
//       'image': item['image'],
//       'description': item['description'] ?? '',
//       'vendorId': item['vendorId'],
//     }).toList();
//
//     final orderTotal = _cartTotal + _fuelCharge;
//     final orderDoc = FirebaseFirestore.instance.collection('orders').doc();
//
//     await orderDoc.set({
//       'items': orderItems,
//       'fuelCharge': _fuelCharge,
//       'total': orderTotal,
//       'status': 'Placed',
//       'createdAt': FieldValue.serverTimestamp(),
//       'userId': widget.currentUserId,
//     });
//
//     showToast('Order placed successfully!', bgColor: Colors.green);
//     setState(() => _cart.clear());
//     if (!widget.isAdmin) _startPayment(orderDoc.id, orderTotal);
//   }
// }
//
//
//

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

const String RAZORPAY_KEY = 'rzp_test_RGlPdevCgkpRiA';

class OrderPagess extends StatefulWidget {
  final bool isAdmin;
  final String currentUserId;

  const OrderPagess({super.key, this.isAdmin = false, required this.currentUserId});

  @override
  State<OrderPagess> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPagess> with SingleTickerProviderStateMixin {
  late Razorpay _razorpay;
  int? _pendingAmountPaise;
  String? _currentOrderId;
  final List<Map<String, dynamic>> _cart = [];
  final double _fuelCharge = 20.0;
  final List<String> statusSteps = ["Placed", "Accepted", "Preparing", "Ready", "Completed"];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _tabController.dispose();
    super.dispose();
  }

  double get _cartTotal => _cart.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));

  void showToast(String msg, {Color bgColor = Colors.black}) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: bgColor,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  // ------------------ ADMIN: Add Food Dialog ------------------
  void _showAddFoodDialog() {
    if (!widget.isAdmin) return;

    final formKey = GlobalKey<FormState>();
    String name = '';
    String price = '';
    String image = '';
    String description = '';
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2A2A2A)
                : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'Add New Food Item',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'e.g., Veg Burger',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
                      onSaved: (val) => name = val!,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                        hintText: 'e.g., 99.0',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a price';
                        if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Enter a valid price';
                        return null;
                      },
                      onSaved: (val) => price = val!,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL (optional)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.url,
                      onSaved: (val) => image = val ?? '',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'e.g., Delicious burger with cheese',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      maxLines: 2,
                      onSaved: (val) => description = val ?? '',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.white,
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    setDialogState(() => isLoading = true);

                    try {
                      final docRef = FirebaseFirestore.instance.collection('food_items').doc();
                      await docRef.set({
                        'id': docRef.id,
                        'name': name,
                        'price': double.parse(price),
                        'image': image,
                        'description': description,
                        'available': true,
                        'rating': 0,
                        'discount': 0,
                        'vendorId': 'default_vendor',
                        'createdAt': FieldValue.serverTimestamp(),
                      });

                      showToast('Food item added successfully!', bgColor: Colors.green);
                      Navigator.pop(ctx);
                    } catch (e) {
                      showToast('Error: $e', bgColor: Colors.red);
                      setDialogState(() => isLoading = false);
                    }
                  }
                },
                child: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2
                  ),
                )
                    : const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  // ------------------ ADMIN: Update Order Status ------------------
  void _updateOrderStatus(String orderId, String newStatus) {
    FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    }).then((_) {
      showToast('Order status updated to $newStatus', bgColor: Colors.green);
    }).catchError((error) {
      showToast('Error updating status: $error', bgColor: Colors.red);
    });
  }

  // ------------------ Payment Functions ------------------
  void _startPayment(String orderId, double amount) {
    final int paise = (amount * 100).toInt();
    _pendingAmountPaise = paise;
    _currentOrderId = orderId;
    var options = {
      'key': RAZORPAY_KEY,
      'amount': paise,
      'currency': 'INR',
      'name': 'Food Order App',
      'description': 'Order Payment',
      'prefill': {
        'contact': '9999999999',
        'email': 'user@example.com'
      },
      'theme': {'color': '#D4AF37'}
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      showToast('Payment Error: $e', bgColor: Colors.red);
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (_pendingAmountPaise == null || _currentOrderId == null) return;
    final orderDoc = FirebaseFirestore.instance.collection('orders').doc(_currentOrderId);
    try {
      await orderDoc.update({
        'status': 'Completed',
        'paymentId': response.paymentId,
        'paymentStatus': 'success',
        'paidAt': FieldValue.serverTimestamp(),
      });
      showToast('Payment successful! Order confirmed.', bgColor: Colors.green);
    } catch (e) {
      showToast('Error updating order: $e', bgColor: Colors.red);
    }
    _pendingAmountPaise = null;
    _currentOrderId = null;
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showToast('Payment failed: ${response.message}', bgColor: Colors.red);
    _pendingAmountPaise = null;
    _currentOrderId = null;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showToast('External wallet: ${response.walletName}', bgColor: Colors.orange);
    _pendingAmountPaise = null;
    _currentOrderId = null;
  }

  // ------------------ Order Status Helper ------------------
  Color _getStatusColor(String step, String currentStatus) {
    int stepIndex = statusSteps.indexOf(step);
    int currentIndex = statusSteps.indexOf(currentStatus);
    if (stepIndex <= currentIndex) return Colors.green;
    if (stepIndex == currentIndex + 1) return Colors.orange;
    return Colors.grey;
  }

  Widget _buildStatusStepper(String currentStatus) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: List.generate(statusSteps.length * 2 - 1, (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            final step = statusSteps[stepIndex];
            final color = _getStatusColor(step, currentStatus);
            return Column(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color,
                  child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  step,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            );
          } else {
            final prevStepIndex = (index - 1) ~/ 2;
            final prevStep = statusSteps[prevStepIndex];
            final color = _getStatusColor(prevStep, currentStatus);
            return Expanded(
              child: Container(
                height: 2,
                color: color,
                margin: const EdgeInsets.only(bottom: 24),
              ),
            );
          }
        }),
      ),
    );
  }

  // ------------------ Order Card Widget ------------------
  Widget _buildOrderCard(DocumentSnapshot orderDoc, Map<String, dynamic> data) {
    final orderId = orderDoc.id;
    final items = (data['items'] ?? []) as List;
    final totalAmount = data['total'] ?? 0.0;
    final status = data['status'] ?? 'Placed';
    final createdAt = data['createdAt'] as Timestamp?;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          "Order #${orderId.substring(0, 8)}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total: ₹${totalAmount.toStringAsFixed(2)}"),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(status, status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "Status: $status",
                style: TextStyle(
                  color: _getStatusColor(status, status),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        children: [
          _buildStatusStepper(status),

          if (widget.isAdmin) ...[
            const Divider(height: 20),
            Text(
              'Update Status:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: statusSteps.map((newStatus) {
                final isCurrent = status == newStatus;
                final isNext = statusSteps.indexOf(newStatus) == statusSteps.indexOf(status) + 1;
                return FilterChip(
                  label: Text(newStatus),
                  selected: isCurrent,
                  onSelected: isNext ? (selected) {
                    _updateOrderStatus(orderId, newStatus);
                  } : null,
                  backgroundColor: isCurrent ? Colors.green : Colors.grey[300],
                  selectedColor: Colors.green,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isCurrent ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ],

          const Divider(height: 20),
          ...items.map((item) {
            final map = item as Map<String, dynamic>;
            return ListTile(
              leading: (map['image'] != null && map['image'] != '')
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  map['image'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fastfood, color: Colors.grey),
                    );
                  },
                ),
              )
                  : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
              title: Text(
                map['name'] ?? 'Unknown Item',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (map['description'] != null && map['description'] != '')
                    Text(
                      map['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                  Text(
                    "Qty: ${map['quantity']} × ₹${map['price']?.toStringAsFixed(2) ?? '0.00'}",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                ],
              ),
              trailing: Text(
                "₹${((map['price'] ?? 0) * (map['quantity'] ?? 1)).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              isThreeLine: true,
            );
          }).toList(),

          const Divider(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fuel Charge:",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                    Text(
                      "Total Amount:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${_fuelCharge.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                    Text(
                      "₹${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Ordered on: ${createdAt != null ? DateFormat('dd MMM yyyy, hh:mm a').format(createdAt.toDate()) : 'Unknown date'}",
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white54 : Colors.grey[500],
              ),
            ),
          ),

          if (!widget.isAdmin && status == 'Placed') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                label: const Text('Pay Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _startPayment(orderId, totalAmount),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ------------------ UI Build ------------------
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: Text(widget.isAdmin ? "Admin Orders" : "My Orders"),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        elevation: 0,
        actions: widget.isAdmin
            ? [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFD4AF37),
              child: IconButton(
                onPressed: _showAddFoodDialog,
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: 'Add Food Item',
              ),
            ),
          )
        ]
            : null,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.isAdmin
            ? FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots()
            : FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: widget.currentUserId).orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: const Color(0xFFD4AF37)),
                  const SizedBox(height: 16),
                  Text(
                    "Loading Orders...",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
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
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: const Color(0xFFD4AF37),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading orders",
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white60 : Colors.grey[600],
                    ),
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
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: const Color(0xFFD4AF37).withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No orders yet",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isAdmin
                        ? "Orders will appear here when customers place them"
                        : "Your orders will appear here",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              return _buildOrderCard(orders[index], data);
            },
          );
        },
      ),
    );
  }

  // ------------------ Place Order ------------------
  Future<void> _placeOrder() async {
    if (_cart.isEmpty) return;

    final orderItems = _cart.map((item) => {
      'name': item['name'],
      'price': item['price'],
      'quantity': item['quantity'],
      'image': item['image'],
      'description': item['description'] ?? '',
      'vendorId': item['vendorId'],
    }).toList();

    final orderTotal = _cartTotal + _fuelCharge;
    final orderDoc = FirebaseFirestore.instance.collection('orders').doc();

    try {
      await orderDoc.set({
        'items': orderItems,
        'fuelCharge': _fuelCharge,
        'total': orderTotal,
        'status': 'Placed',
        'createdAt': FieldValue.serverTimestamp(),
        'userId': widget.currentUserId,
        'paymentStatus': 'pending',
      });

      showToast('Order placed successfully!', bgColor: Colors.green);
      setState(() => _cart.clear());

      if (!widget.isAdmin) {
        _startPayment(orderDoc.id, orderTotal);
      }
    } catch (e) {
      showToast('Error placing order: $e', bgColor: Colors.red);
    }
  }
}
