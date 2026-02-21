// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../models/order_model.dart';
// import '../../services/firestore_service.dart';
//
// class OrderDetailScreen extends StatefulWidget {
//   final OrderModel order;
//   final FirestoreService firestoreService;
//
//   const OrderDetailScreen({
//     super.key,
//     required this.order,
//     required this.firestoreService,
//   });
//
//   @override
//   State<OrderDetailScreen> createState() => _OrderDetailScreenState();
// }
//
// class _OrderDetailScreenState extends State<OrderDetailScreen> {
//   late String _currentStatus;
//   final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
//
//   String? get formattedDate => null;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentStatus = widget.order.status;
//   }
//
//   void _updateStatus(String newStatus) async {
//     try {
//       await widget.firestoreService
//           .updateOrderStatus(widget.order.id, newStatus);
//       setState(() {
//         _currentStatus = newStatus;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Order status updated to $newStatus')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating status: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final formattedDate = DateFormat.yMMMd()
//         .add_jm()
//         .format(widget.order.createdAt.toDate());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order #${widget.order.id.substring(0, 6)}...'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildInfoCard(),
//             const SizedBox(height: 20),
//             _buildItemsList(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildStatusUpdater(),
//     );
//   }
//
//   Widget _buildInfoCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildInfoRow('Order ID:', widget.order.id),
//             _buildInfoRow('User ID:', widget.order.userId),
//             _buildInfoRow('Date:', formattedDate!),
//             _buildInfoRow('Total:', currencyFormat.format(widget.order.total)),
//             _buildInfoRow('Status:', _currentStatus.toUpperCase(), isStatus: true),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//           if (isStatus)
//             Chip(
//               label: Text(value, style: const TextStyle(color: Colors.white)),
//               backgroundColor: _currentStatus == 'pending'
//                   ? Colors.orangeAccent
//                   : Colors.green,
//             )
//           else
//             Text(value, style: const TextStyle(fontSize: 15)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildItemsList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Items in Order',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
//         ),
//         const SizedBox(height: 10),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: widget.order.items.length,
//           itemBuilder: (context, index) {
//             final item = widget.order.items[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               child: ListTile(
//                 leading: Image.network(
//                   item.image,
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                   errorBuilder: (ctx, err, st) =>
//                   const Icon(Icons.fastfood, size: 50),
//                 ),
//                 title: Text(item.name),
//                 subtitle: Text('Qty: ${item.quantity}'),
//                 trailing: Text(currencyFormat.format(item.price * item.quantity)),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusUpdater() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, -5))
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//             onPressed: _currentStatus == 'pending'
//                 ? () => _updateStatus('completed')
//                 : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               disabledBackgroundColor: Colors.grey,
//             ),
//             child: const Text('Mark as Completed'),
//           ),
//           ElevatedButton(
//             onPressed: _currentStatus == 'completed'
//                 ? () => _updateStatus('pending')
//                 : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orangeAccent,
//               disabledBackgroundColor: Colors.grey,
//             ),
//             child: const Text('Mark as Pending'),
//           ),
//         ],
//       ),
//     );
//   }
// }
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

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  double get _cartTotal => _cart.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));

  void showToast(String msg, {Color bgColor = Colors.black}) {
    Fluttertoast.showToast(msg: msg, backgroundColor: bgColor, textColor: Colors.white);
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
            title: const Text('Add New Food Item'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g., Veg Burger'),
                      validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
                      onSaved: (val) => name = val!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Price', hintText: 'e.g., 99.0'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a price';
                        if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Enter a valid price';
                        return null;
                      },
                      onSaved: (val) => price = val!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Image URL (optional)'),
                      keyboardType: TextInputType.url,
                      onSaved: (val) => image = val ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Description', hintText: 'e.g., Delicious burger with cheese'),
                      maxLines: 2,
                      onSaved: (val) => description = val ?? '',
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
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
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
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
      'name': 'Demo App',
      'description': 'Order Payment'
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
      await orderDoc.update({'status': 'Completed'});
      showToast('Payment successful!', bgColor: Colors.green);
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: List.generate(statusSteps.length * 2 - 1, (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            final step = statusSteps[stepIndex];
            final color = _getStatusColor(step, currentStatus);
            return Column(
              children: [
                CircleAvatar(radius: 12, backgroundColor: color, child: Icon(Icons.check, color: Colors.white, size: 14)),
                const SizedBox(height: 4),
                Text(step, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            );
          } else {
            final prevStepIndex = (index - 1) ~/ 2;
            final prevStep = statusSteps[prevStepIndex];
            final color = _getStatusColor(prevStep, currentStatus);
            return Expanded(child: Container(height: 2, color: color, margin: const EdgeInsets.only(bottom: 20)));
          }
        }),
      ),
    );
  }

  // ------------------ UI Build ------------------
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> orderStream = widget.isAdmin
        ? FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots()
        : FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: widget.currentUserId).orderBy('createdAt', descending: true).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdmin ? "Admin Orders" : "My Orders"),
        actions: widget.isAdmin
            ? [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.deepOrange,
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
        stream: orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text("An error occurred."));
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("No orders yet."));

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;
              final items = (data['items'] ?? []) as List;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  title: Text("Order #${orderId.substring(0, 6)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Total: ₹${data['total']} | Status: ${data['status']}"),
                  children: [
                    _buildStatusStepper(data['status']),
                    const Divider(height: 20),
                    ...items.map((item) {
                      final map = item as Map<String, dynamic>;
                      return ListTile(
                        leading: (map['image'] != null && map['image'] != '')
                            ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(map['image'], width: 50, height: 50, fit: BoxFit.cover))
                            : const Icon(Icons.fastfood, size: 40),
                        title: Text(map['name']),
                        subtitle: Text("${map['description'] ?? ''}\nQty: ${map['quantity']}"), // ✅ show description
                        trailing: Text("₹${(map['price'] * map['quantity']).toStringAsFixed(2)}"),
                        isThreeLine: true,
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Ordered on: ${DateFormat('dd MMM yyyy, hh:mm a').format((data['createdAt'] as Timestamp).toDate())}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _cart.isNotEmpty
          ? Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: ₹${(_cartTotal + _fuelCharge).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('Place Order'),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _placeOrder,
            ),
          ],
        ),
      )
          : null,
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

    await orderDoc.set({
      'items': orderItems,
      'fuelCharge': _fuelCharge,
      'total': orderTotal,
      'status': 'Placed',
      'createdAt': FieldValue.serverTimestamp(),
      'userId': widget.currentUserId,
    });

    showToast('Order placed successfully!', bgColor: Colors.green);
    setState(() => _cart.clear());
    if (!widget.isAdmin) _startPayment(orderDoc.id, orderTotal);
  }
}
