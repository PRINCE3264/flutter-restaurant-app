

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../providers/cart_provider.dart';
import '../providers/wallet_provider.dart';

const String RAZORPAY_KEY = 'rzp_test_RGlPdevCgkpRiA';

class OrderPage extends StatefulWidget {
  final String? userId;
  final bool isAdmin;

  const OrderPage({super.key, this.userId, this.isAdmin = false});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Razorpay _razorpay;
  int? _pendingAmountPaise;
  String? _currentOrderId;
  static const double _fuelCharge = 20.0;
  final List<String> statusSteps = ["Placed", "Accepted", "Preparing", "Ready", "Completed"];
  final Map<String, Timer> _activeTimers = {};
  Timer? _autoRefreshTimer;
  Timer? _autoStatusUpdateTimer;

  // ✅ SIMPLE NOTIFICATION PLUGIN
  late FlutterLocalNotificationsPlugin notifications;

  // Color scheme
  final Color _primaryColor = Color(0xFFD4AF37);
  final Color _darkBackgroundColor = Color(0xFF1A0F0F);
  final Color _lightBackgroundColor = Color(0xFFF8F5F0);
  final Color _cardDarkColor = Color(0xFF2D1B1B);
  final Color _cardLightColor = Color(0xFFFFFFFF);
  final Color _textDarkColor = Colors.white;
  final Color _textLightColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // ✅ INITIALIZE NOTIFICATIONS FIRST
    _initNotifications();

    _startAutoRefresh();
    _startAutoStatusUpdate();
  }

  // ✅ SIMPLE NOTIFICATION INITIALIZATION THAT WORKS
  void _initNotifications() async {
    notifications = FlutterLocalNotificationsPlugin();

    // Android settings
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notifications.initialize(initSettings);

    // Create Android channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'order_channel', // Channel ID
      'Order Notifications', // Channel name
      description: 'Notifications for order updates',
      importance: Importance.high,
    );

    await notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print('✅ Notifications ready!');
  }

  // ✅ SIMPLE NOTIFICATION METHOD THAT WORKS
  Future<void> _showNotification(String title, String body) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'order_channel', // Must match channel ID
        'Order Notifications',
        channelDescription: 'Order updates',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await notifications.show(
        0, // Notification ID
        title,
        body,
        details,
      );

      print('🎯 NOTIFICATION SHOWN: $title');
    } catch (e) {
      print('❌ Notification error: $e');
      // Show toast as fallback
      showToast(title, bgColor: _primaryColor);
    }
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      setState(() {});
    });
  }

  void _startAutoStatusUpdate() {
    _autoStatusUpdateTimer = Timer.periodic(const Duration(minutes: 20), (timer) {
      _updateAllOrderStatuses();
    });
  }

  Future<void> _updateAllOrderStatuses() async {
    try {
      final QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('status', whereIn: ['Placed', 'Accepted', 'Preparing', 'Ready'])
          .get();

      for (final doc in ordersSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final orderId = doc.id;
        final currentStatus = data['status'] ?? 'Placed';
        await _advanceOrderStatus(orderId, currentStatus);
      }
    } catch (e) {
      debugPrint('OrderPage: Error in auto status update: $e');
    }
  }

  Future<void> _advanceOrderStatus(String orderId, String currentStatus) async {
    try {
      final int currentIndex = statusSteps.indexOf(currentStatus);
      if (currentIndex == -1 || currentIndex >= statusSteps.length - 1) return;

      final nextStatus = statusSteps[currentIndex + 1];

      final orderDoc = await FirebaseFirestore.instance.collection('orders').doc(orderId).get();
      final orderData = orderDoc.data() as Map<String, dynamic>;
      final Timestamp? lastUpdate = orderData['lastStatusUpdatedAt'] as Timestamp?;

      if (lastUpdate != null) {
        final timeSinceLastUpdate = DateTime.now().difference(lastUpdate.toDate());
        if (timeSinceLastUpdate.inMinutes < 20) return;
      }

      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': nextStatus,
        'lastStatusUpdatedAt': FieldValue.serverTimestamp(),
        'statusHistory': FieldValue.arrayUnion([
          {
            'status': nextStatus,
            'updatedAtMs': DateTime.now().toUtc().millisecondsSinceEpoch,
            'note': 'Auto-updated after 20 minutes'
          }
        ])
      });

      if (nextStatus != 'Completed') {
        _scheduleNextStatusUpdate(orderId, nextStatus);
      }

    } catch (e) {
      debugPrint('OrderPage: Error updating order $orderId: $e');
    }
  }

  void _scheduleNextStatusUpdate(String orderId, String currentStatus) {
    _activeTimers[orderId]?.cancel();
    _activeTimers[orderId] = Timer(const Duration(minutes: 20), () {
      _advanceOrderStatus(orderId, currentStatus);
    });
  }

  void _startOrderAutoUpdate(String orderId, String currentStatus) {
    if (_activeTimers.containsKey(orderId)) return;
    _scheduleNextStatusUpdate(orderId, currentStatus);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _autoRefreshTimer?.cancel();
    _autoStatusUpdateTimer?.cancel();
    _activeTimers.forEach((orderId, timer) {
      timer.cancel();
    });
    _activeTimers.clear();
    super.dispose();
  }

  void showToast(String msg, {Color bgColor = Colors.black}) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: bgColor,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
    );
  }

  Future<String> _getUserId() async {
    if (widget.userId != null) return widget.userId!;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) return user.uid;
    throw Exception('User not logged in');
  }

  void _startPayment(String orderId, double amount) {
    _pendingAmountPaise = (amount * 100).toInt();
    _currentOrderId = orderId;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showToast('User not logged in', bgColor: Colors.red);
      return;
    }

    var options = {
      'key': RAZORPAY_KEY,
      'amount': _pendingAmountPaise,
      'currency': 'INR',
      'name': 'Royal Bites',
      'description': 'Order Payment',
      'prefill': {
        'contact': user.phoneNumber ?? '',
        'email': user.email ?? ''
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

    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    try {
      await FirebaseFirestore.instance.collection('orders').doc(_currentOrderId).update({
        'paymentStatus': 'Success',
        'paymentId': response.paymentId,
        'lastStatusUpdatedAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('orders').doc(_currentOrderId).update({
        'statusHistory': FieldValue.arrayUnion([
          {
            'status': 'PaymentSuccess',
            'paymentId': response.paymentId,
            'updatedAtMs': DateTime.now().toUtc().millisecondsSinceEpoch,
            'note': 'Paid via Razorpay'
          }
        ])
      });

      // ✅ SHOW PAYMENT SUCCESS NOTIFICATION
      await _showNotification(
          'Payment Successful! 💰',
          'Payment completed for order #${_currentOrderId!.substring(0, 6)}'
      );

      showToast('💰 Payment Successful!', bgColor: Colors.green);
    } catch (e) {
      showToast('Error updating order: $e', bgColor: Colors.red);
    }
    _pendingAmountPaise = null;
    _currentOrderId = null;
    await walletProvider.fetchWallet();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showToast('❌ Payment failed: ${response.message}', bgColor: Colors.red);
    _pendingAmountPaise = null;
    _currentOrderId = null;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showToast('📱 External wallet: ${response.walletName}', bgColor: Colors.orange);
    _pendingAmountPaise = null;
    _currentOrderId = null;
  }

  Future<void> _placeOrder() async {
    try {
      final uid = await _getUserId();
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      walletProvider.updateUserId(uid);
      await walletProvider.fetchWallet();

      if (cartProvider.cartItems.isEmpty) {
        showToast('🛒 Cart is empty!', bgColor: Colors.orange);
        return;
      }

      final orderItems = cartProvider.cartItems.map((item) => {
        'id': item.id, 'name': item.name, 'price': item.price, 'quantity': item.quantity,
        'image': item.image, 'description': item.description ?? '', 'vendorId': item.vendorId,
        'vendorName': item.vendorName, 'discount': item.discount,
      }).toList();

      final double cartTotal = cartProvider.totalPrice;
      final double finalAmount = cartTotal + _fuelCharge;

      double walletUsed = walletProvider.balance >= finalAmount ? finalAmount : walletProvider.balance;
      if (walletUsed > 0) {
        await walletProvider.debit(walletUsed, "Order Payment");
      }

      final orderDoc = FirebaseFirestore.instance.collection('orders').doc();
      await orderDoc.set({
        'items': orderItems, 'fuelCharge': _fuelCharge, 'total': finalAmount, 'walletUsed': walletUsed,
        'status': 'Placed', 'paymentStatus': walletUsed >= finalAmount ? 'Success' : 'Pending',
        'createdAt': FieldValue.serverTimestamp(), 'clientCreatedAtMs': DateTime.now().toUtc().millisecondsSinceEpoch,
        'userId': uid, 'statusHistory': [{
          'status': 'Placed', 'updatedAtMs': DateTime.now().toUtc().millisecondsSinceEpoch, 'note': 'Order created'
        }], 'lastStatusUpdatedAt': FieldValue.serverTimestamp(),
      });

      await cartProvider.clearCart(uid);

      // ✅ SHOW ORDER SUCCESS NOTIFICATION
      await _showNotification(
          '🎉 Order Placed Successfully!',
          'Order #${orderDoc.id.substring(0, 6)} • Total: ₹${finalAmount.toStringAsFixed(2)}'
      );

      showToast('🎉 Order placed successfully!', bgColor: Colors.green);

      final remainingAmount = finalAmount - walletUsed;
      if (!widget.isAdmin && remainingAmount > 0) _startPayment(orderDoc.id, remainingAmount);

      _startOrderAutoUpdate(orderDoc.id, 'Placed');
    } catch (e) {
      showToast('❌ Error placing order: $e', bgColor: Colors.red);
    }
  }

  // ... (Keep all your existing UI methods exactly the same)
  Widget _buildStatusStepper(String status) {
    int currentIndex = statusSteps.indexOf(status);
    if (currentIndex == -1) currentIndex = 0;

    List<Widget> stepper = [];
    for (int i = 0; i < statusSteps.length; i++) {
      Color color = i < currentIndex ? _primaryColor : i == currentIndex ? Colors.orange : Colors.grey.shade400;
      IconData icon = i < currentIndex ? Icons.check : i == currentIndex ? Icons.circle : Icons.more_horiz;

      stepper.add(Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.transparent,
              child: Icon(icon, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(height: 4),
          Text(statusSteps[i], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ));

      if (i < statusSteps.length - 1) {
        stepper.add(Expanded(child: Container(height: 2, color: i < currentIndex ? _primaryColor : Colors.grey.shade300, margin: const EdgeInsets.only(bottom: 22))));
      }
    }

    return Padding(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: stepper));
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Placed': return _primaryColor;
      case 'Accepted': return Colors.blue;
      case 'Preparing': return Colors.orange;
      case 'Ready': return Colors.purple;
      case 'Completed': return Colors.green;
      default: return Colors.grey;
    }
  }

  Widget _buildOrderCard(Map<String, dynamic> data, String orderId, bool isDarkMode) {
    final items = (data['items'] ?? []) as List;
    final status = data['status'] ?? "Placed";
    final total = (data['total'] ?? 0.0).toDouble();
    final walletUsed = (data['walletUsed'] ?? 0.0).toDouble();
    final paymentStatus = data['paymentStatus'] ?? 'Pending';
    final fuelCharge = (data['fuelCharge'] ?? 0.0).toDouble();

    final Timestamp? serverTs = data['createdAt'] as Timestamp?;
    final int? clientMs = data['clientCreatedAtMs'] as int?;
    final DateTime timestamp = serverTs != null
        ? serverTs.toDate().toLocal()
        : (clientMs != null
        ? DateTime.fromMillisecondsSinceEpoch(clientMs).toLocal()
        : DateTime.now().toLocal());

    if (!widget.isAdmin && status != "Completed") {
      _startOrderAutoUpdate(orderId, status);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [_cardDarkColor, Color(0xFF3A2323)]
              : [_cardLightColor, Color(0xFFF8F5F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: _getStatusColor(status)),
          ),
          child: Icon(
            Icons.shopping_bag,
            color: _getStatusColor(status),
            size: 20,
          ),
        ),
        title: Text(
          "Order #${orderId.substring(0, 6).toUpperCase()}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? _textDarkColor : _textLightColor,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "₹${total.toStringAsFixed(2)} • ${status.toUpperCase()}",
              style: TextStyle(
                color: _getStatusColor(status),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 2),
            Text(
              DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: paymentStatus == 'Success'
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: paymentStatus == 'Success' ? Colors.green : Colors.orange,
            ),
          ),
          child: Text(
            paymentStatus,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: paymentStatus == 'Success' ? Colors.green : Colors.orange,
            ),
          ),
        ),
        children: [
          _buildStatusStepper(status),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF1A1A1A) : Color(0xFFF4E4BC).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem("Fuel Charge", "₹${fuelCharge.toStringAsFixed(2)}", isDarkMode),
                _buildSummaryItem("Wallet Used", "₹${walletUsed.toStringAsFixed(2)}", isDarkMode),
                _buildSummaryItem("Total", "₹${total.toStringAsFixed(2)}", isDarkMode),
              ],
            ),
          ),
          SizedBox(height: 12),
          ...items.map((item) {
            final map = item as Map<String, dynamic>;
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    ),
                    child: (map['image'] != null && map['image'] != '')
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        map['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.fastfood, color: _primaryColor),
                      ),
                    )
                        : Icon(Icons.fastfood, color: _primaryColor),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          map['name'] ?? 'No Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? _textDarkColor : _textLightColor,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Qty: ${map['quantity'] ?? 1}",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "₹${((map['price'] ?? 0) * (map['quantity'] ?? 1)).toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, bool isDarkMode) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: isDarkMode ? Colors.white60 : Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? _textDarkColor : _textLightColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Stream<QuerySnapshot> orderStream = widget.isAdmin
        ? FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots()
        : FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: widget.userId ?? FirebaseAuth.instance.currentUser?.uid ?? '')
        .orderBy('createdAt', descending: true)
        .snapshots();

    final double cartTotal = cartProvider.totalPrice;

    return Scaffold(
      backgroundColor: isDarkMode ? _darkBackgroundColor : _lightBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.isAdmin ? "👑 All Orders" : "📦 My Orders",
          style: TextStyle(
            color: isDarkMode ? _textDarkColor : _textLightColor,
            fontWeight: FontWeight.bold,
            fontSize: 23,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        backgroundColor: isDarkMode ? _darkBackgroundColor : Color(0xFFF4E4BC),
        elevation: 0,
        iconTheme: IconThemeData(color: _primaryColor),
        actions: [
          // ✅ TEST NOTIFICATION BUTTON
          IconButton(
            icon: Icon(Icons.notification_add, color: _primaryColor),
            onPressed: () {
              _showNotification('Test Notification', 'This is a test notification!');
              showToast('Test notification sent!', bgColor: _primaryColor);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: _primaryColor),
            onPressed: () {
              setState(() {});
              showToast('Orders refreshed!', bgColor: _primaryColor);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: _primaryColor),
                  SizedBox(height: 16),
                  Text(
                    "Loading Orders...",
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
                  Icon(Icons.error_outline, color: Colors.red, size: 50),
                  SizedBox(height: 16),
                  Text(
                    "Error loading orders",
                    style: TextStyle(
                      color: isDarkMode ? _textDarkColor : _textLightColor,
                      fontSize: 16,
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
                  Icon(Icons.shopping_bag_outlined, color: _primaryColor, size: 80),
                  SizedBox(height: 16),
                  Text(
                    widget.isAdmin ? "No orders found" : "No orders yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white70 : Colors.brown[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.isAdmin ? "Orders will appear here" : "Start shopping to see your orders",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;
              return _buildOrderCard(data, orderId, isDarkMode);
            },
          );
        },
      ),
      bottomNavigationBar: cartProvider.cartItems.isNotEmpty
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryColor, Color(0xFFB8941F)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, -5)
            )
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25)
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    "₹${(cartTotal + _fuelCharge).toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _placeOrder,
                icon: Icon(Icons.shopping_cart_checkout, size: 20),
                label: Text(
                  "Place Order",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }
}


