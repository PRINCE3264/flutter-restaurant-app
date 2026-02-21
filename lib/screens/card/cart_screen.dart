// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../providers/cart_provider.dart';
// import '../../providers/wallet_provider.dart';
// import '../orders/order_confirmation_screen.dart';
//
// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});
//
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   late Razorpay _razorpay;
//   static const double fuelCharge = 20.0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         final cartProvider = Provider.of<CartProvider>(context, listen: false);
//         final walletProvider = Provider.of<WalletProvider>(context, listen: false);
//
//         walletProvider.updateUserId(user.uid);
//         cartProvider.updateUserId(user.uid);
//         await cartProvider.loadCartFromFirestore(user.uid);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     final cartProvider = Provider.of<CartProvider>(context, listen: false);
//     final walletProvider = Provider.of<WalletProvider>(context, listen: false);
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     final walletBalance = walletProvider.balance;
//     final finalAmount = cartProvider.totalPrice + fuelCharge;
//
//     final orderId = await cartProvider.placeOrder(
//       userId: user.uid,
//       currentWalletBalance: walletBalance,
//       fuelCharge: fuelCharge,
//     );
//
//     if (orderId.isNotEmpty && mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => OrderConfirmationScreen(
//             orderId: orderId,
//             totalAmount: finalAmount,
//             fuelCharge: fuelCharge,
//           ),
//         ),
//       );
//     }
//
//     _showCustomToast("🎉 Payment successful! Order created.", Color(0xFFD4AF37));
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     _showCustomToast("❌ Payment Failed: ${response.message}", Colors.red);
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     _showCustomToast("📱 External Wallet: ${response.walletName}", Color(0xFFD4AF37));
//   }
//
//   void _showCustomToast(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   void openCheckout(double amount) {
//     if (amount <= 0) return;
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     final options = {
//       'key': 'rzp_test_RGlPdevCgkpRiA',
//       'amount': (amount * 100).toInt(),
//       'currency': 'INR',
//       'name': 'Royal Bites',
//       'description': 'Order Payment',
//       'prefill': {'contact': user.phoneNumber ?? '', 'email': user.email ?? ''},
//       'external': {'wallets': ['paytm']},
//       'theme': {'color': '#D4AF37'}
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('⚠️ Razorpay Error: $e');
//       _showCustomToast('Payment Error: $e', Colors.red);
//     }
//   }
//
//   Future<void> _payFromWalletOrRazorpay() async {
//     final cartProvider = Provider.of<CartProvider>(context, listen: false);
//     final walletProvider = Provider.of<WalletProvider>(context, listen: false);
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     walletProvider.updateUserId(user.uid);
//     final totalAmount = cartProvider.totalPrice + fuelCharge;
//
//     if (walletProvider.balance >= totalAmount) {
//       await walletProvider.debit(totalAmount, "Order Payment");
//       await cartProvider.placeOrder(
//         userId: user.uid,
//         currentWalletBalance: walletProvider.balance,
//         fuelCharge: fuelCharge,
//       );
//       _showCustomToast("💰 Order Paid from Wallet", Color(0xFFD4AF37));
//     } else if (walletProvider.balance > 0) {
//       final partial = walletProvider.balance;
//       await walletProvider.debit(partial, "Partial Wallet Payment");
//       final remaining = totalAmount - partial;
//       openCheckout(remaining);
//     } else {
//       openCheckout(totalAmount);
//     }
//   }
//
//   Widget _buildEmptyCartState(bool isDarkMode) {
//     return Expanded(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.shopping_cart_outlined,
//             size: 100,
//             color: Color(0xFFD4AF37).withOpacity(0.5),
//           ),
//           SizedBox(height: 20),
//           Text(
//             "Your Cart is Empty",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: isDarkMode ? Colors.white70 : Colors.brown[700],
//               fontFamily: 'PlayfairDisplay',
//             ),
//           ),
//           SizedBox(height: 12),
//           Text(
//             "Add some delicious items to get started",
//             style: TextStyle(
//               fontSize: 16,
//               color: isDarkMode ? Colors.white54 : Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 30),
//           ElevatedButton.icon(
//             onPressed: () => Navigator.pop(context),
//             icon: Icon(Icons.restaurant_menu),
//             label: Text("Explore Menu"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFFD4AF37),
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCartItem(dynamic item, bool isDarkMode, CartProvider cartProvider) {
//     final itemTotal = ((item.price ?? 0) - (item.discount ?? 0)) * (item.quantity ?? 0);
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isDarkMode
//               ? [Color(0xFF1E3A5F), Color(0xFF2D5A8A)]
//               : [Colors.white, Color(0xFFE0F7FA)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//         border: Border.all(
//           color: Color(0xFFD4AF37).withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(16),
//         leading: Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               item.image ?? '',
//               width: 60,
//               height: 60,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => Container(
//                 decoration: BoxDecoration(
//                   color: Color(0xFFD4AF37).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.fastfood,
//                   color: Color(0xFFD4AF37),
//                   size: 30,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         title: Text(
//           item.name ?? '',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//             color: isDarkMode ? Colors.white : Colors.black,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 4),
//             Text(
//               "₹${itemTotal.toStringAsFixed(2)}",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFFD4AF37),
//                 fontSize: 14,
//               ),
//             ),
//             if (item.discount != null && item.discount! > 0)
//               Text(
//                 "Save ₹${(item.discount! * (item.quantity ?? 1)).toStringAsFixed(2)}",
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: Colors.green,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Quantity Controls
//             Container(
//               decoration: BoxDecoration(
//                 color: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[100],
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.remove, size: 18),
//                     color: isDarkMode ? Colors.white70 : Colors.black54,
//                     onPressed: () => cartProvider.decreaseQuantity(item),
//                     padding: EdgeInsets.zero,
//                     constraints: BoxConstraints(minWidth: 36),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8),
//                     child: Text(
//                       "${item.quantity}",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: isDarkMode ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.add, size: 18),
//                     color: isDarkMode ? Colors.white70 : Colors.black54,
//                     onPressed: () => cartProvider.addToCart(item),
//                     padding: EdgeInsets.zero,
//                     constraints: BoxConstraints(minWidth: 36),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 8),
//             // Delete Button
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.red.withOpacity(0.3)),
//               ),
//               child: IconButton(
//                 icon: Icon(Icons.delete_outline, size: 20),
//                 color: Colors.red,
//                 onPressed: () => _showDeleteConfirmation(item, cartProvider),
//                 padding: EdgeInsets.all(6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showDeleteConfirmation(dynamic item, CartProvider cartProvider) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Theme.of(context).brightness == Brightness.dark
//             ? Color(0xFF2A2A2A)
//             : Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(
//           "Remove Item",
//           style: TextStyle(color: Color(0xFFD4AF37)),
//         ),
//         content: Text("Are you sure you want to remove ${item.name} from cart?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel", style: TextStyle(color: Colors.grey)),
//           ),
//           TextButton(
//             onPressed: () {
//               cartProvider.removeItem(item);
//               Navigator.pop(context);
//               _showCustomToast("🗑️ Item removed from cart", Colors.orange);
//             },
//             child: Text("Remove", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomPaymentSection(double finalAmount, bool isDarkMode) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF1E3A5F), Color(0xFF2D5A8A)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 15,
//             offset: Offset(0, -5),
//           ),
//         ],
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//       ),
//       child: SafeArea(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Total Amount",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.white.withOpacity(0.8),
//                   ),
//                 ),
//                 Text(
//                   "₹${finalAmount.toStringAsFixed(2)}",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     fontFamily: 'PlayfairDisplay',
//                   ),
//                 ),
//                 Text(
//                   "Includes ₹$fuelCharge fuel charge",
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: Colors.white.withOpacity(0.7),
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 8,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton.icon(
//                 onPressed: _payFromWalletOrRazorpay,
//                 icon: Icon(Icons.shopping_cart_checkout, size: 20),
//                 label: Text(
//                   "Pay Now",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFD4AF37),
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSummaryItem(String title, String value, bool isDarkMode) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 12,
//             color: isDarkMode ? Colors.white60 : Colors.blueGrey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? Colors.white : Color(0xFF1E3A5F),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showClearCartConfirmation(CartProvider cartProvider) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Theme.of(context).brightness == Brightness.dark
//             ? Color(0xFF2A2A2A)
//             : Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(
//           "Clear Cart",
//           style: TextStyle(color: Color(0xFFD4AF37)),
//         ),
//         content: Text("Are you sure you want to remove all items from your cart?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel", style: TextStyle(color: Colors.grey)),
//           ),
//           TextButton(
//             onPressed: () {
//               final user = FirebaseAuth.instance.currentUser;
//               if (user != null) {
//                 cartProvider.clearCart(user.uid);
//               }
//               Navigator.pop(context);
//               _showCustomToast("🗑️ Cart cleared", Colors.orange);
//             },
//             child: Text("Clear All", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     final cartProvider = Provider.of<CartProvider>(context);
//     final total = cartProvider.totalPrice;
//     final finalAmount = total + fuelCharge;
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? Color(0xFF0A0A0A) : Color(0xFFE0F7FA),
//       appBar: AppBar(
//         title: Text(
//           "🛒 My Cart",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 23,
//             color: isDarkMode ? Colors.white : Colors.black87,
//             fontFamily: 'PlayfairDisplay',
//           ),
//         ),
//         elevation: 0,
//         iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
//         backgroundColor: isDarkMode ? Color(0xFF1E3A5F) : Color(0xFFB3E5FC),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: isDarkMode
//                   ? [Color(0xFF1E3A5F), Color(0xFF2D5A8A)]
//                   : [Color(0xFFB3E5FC), Color(0xFF81D4FA)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         actions: [
//           if (cartProvider.cartItems.isNotEmpty)
//             IconButton(
//               icon: Icon(Icons.delete_sweep, color: Color(0xFFD4AF37)),
//               onPressed: () => _showClearCartConfirmation(cartProvider),
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Cart Summary
//           if (cartProvider.cartItems.isNotEmpty)
//             Container(
//               margin: EdgeInsets.all(16),
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: isDarkMode
//                       ? [Color(0xFF1E3A5F), Color(0xFF2D5A8A)]
//                       : [Color(0xFFB3E5FC), Color(0xFF81D4FA)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildSummaryItem("Items", "${cartProvider.cartItems.length}", isDarkMode),
//                   _buildSummaryItem("Subtotal", "₹${total.toStringAsFixed(2)}", isDarkMode),
//                   _buildSummaryItem("Fuel Charge", "₹$fuelCharge", isDarkMode),
//                 ],
//               ),
//             ),
//
//           // Cart Items or Empty State
//           if (cartProvider.cartItems.isEmpty)
//             _buildEmptyCartState(isDarkMode)
//           else
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.symmetric(vertical: 8),
//                 itemCount: cartProvider.cartItems.length,
//                 itemBuilder: (context, index) {
//                   final item = cartProvider.cartItems[index];
//                   return _buildCartItem(item, isDarkMode, cartProvider);
//                 },
//               ),
//             ),
//
//           // Bottom Payment Section
//           if (cartProvider.cartItems.isNotEmpty)
//             _buildBottomPaymentSection(finalAmount, isDarkMode),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wallet_provider.dart';
import '../orders/order_confirmation_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Razorpay _razorpay;
  static const double fuelCharge = 20.0;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        final walletProvider = Provider.of<WalletProvider>(context, listen: false);

        walletProvider.updateUserId(user.uid);
        cartProvider.updateUserId(user.uid);
        await cartProvider.loadCartFromFirestore(user.uid);
      }
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final walletBalance = walletProvider.balance;
    final finalAmount = cartProvider.totalPrice + fuelCharge;

    final orderId = await cartProvider.placeOrder(
      userId: user.uid,
      currentWalletBalance: walletBalance,
      fuelCharge: fuelCharge,
    );

    if (orderId.isNotEmpty && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(
            orderId: orderId,
            totalAmount: finalAmount,
            fuelCharge: fuelCharge,
          ),
        ),
      );
    }

    _showCustomToast("🎉 Payment successful! Order created.", Color(0xFFD4AF37));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showCustomToast("❌ Payment Failed: ${response.message}", Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showCustomToast("📱 External Wallet: ${response.walletName}", Color(0xFFD4AF37));
  }

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

  void openCheckout(double amount) {
    if (amount <= 0) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final options = {
      'key': 'rzp_test_RGlPdevCgkpRiA',
      'amount': (amount * 100).toInt(),
      'currency': 'INR',
      'name': 'Royal Bites',
      'description': 'Order Payment',
      'prefill': {'contact': user.phoneNumber ?? '', 'email': user.email ?? ''},
      'external': {'wallets': ['paytm']},
      'theme': {'color': '#D4AF37'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('⚠️ Razorpay Error: $e');
      _showCustomToast('Payment Error: $e', Colors.red);
    }
  }

  Future<void> _payFromWalletOrRazorpay() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    walletProvider.updateUserId(user.uid);
    final totalAmount = cartProvider.totalPrice + fuelCharge;

    if (walletProvider.balance >= totalAmount) {
      await walletProvider.debit(totalAmount, "Order Payment");
      await cartProvider.placeOrder(
        userId: user.uid,
        currentWalletBalance: walletProvider.balance,
        fuelCharge: fuelCharge,
      );
      _showCustomToast("💰 Order Paid from Wallet", Color(0xFFD4AF37));
    } else if (walletProvider.balance > 0) {
      final partial = walletProvider.balance;
      await walletProvider.debit(partial, "Partial Wallet Payment");
      final remaining = totalAmount - partial;
      openCheckout(remaining);
    } else {
      openCheckout(totalAmount);
    }
  }

  Widget _buildEmptyCartState(bool isDarkMode) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Color(0xFFD4AF37).withOpacity(0.5),
          ),
          SizedBox(height: 20),
          Text(
            "Your Cart is Empty",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white70 : Colors.brown[700],
              fontFamily: 'PlayfairDisplay',
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Add some delicious items to get started",
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white54 : Colors.grey[600],
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.restaurant_menu),
            label: Text("Explore Menu"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD4AF37),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(dynamic item, bool isDarkMode, CartProvider cartProvider) {
    final itemTotal = ((item.price ?? 0) - (item.discount ?? 0)) * (item.quantity ?? 0);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
              : [Colors.white, Color(0xFFF8F5F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Color(0xFFD4AF37).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.image ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.fastfood,
                  color: Color(0xFFD4AF37),
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          item.name ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              "₹${itemTotal.toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFFD4AF37),
                fontSize: 14,
              ),
            ),
            if (item.discount != null && item.discount! > 0)
              Text(
                "Save ₹${(item.discount! * (item.quantity ?? 1)).toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quantity Controls
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 18),
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    onPressed: () => cartProvider.decreaseQuantity(item),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 36),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "${item.quantity}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 18),
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    onPressed: () => cartProvider.addToCart(item),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 36),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            // Delete Button
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: IconButton(
                icon: Icon(Icons.delete_outline, size: 20),
                color: Colors.red,
                onPressed: () => _showDeleteConfirmation(item, cartProvider),
                padding: EdgeInsets.all(6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(dynamic item, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF2A2A2A)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Remove Item",
          style: TextStyle(color: Color(0xFFD4AF37)),
        ),
        content: Text("Are you sure you want to remove ${item.name} from cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              cartProvider.removeItem(item);
              Navigator.pop(context);
              _showCustomToast("🗑️ Item removed from cart", Colors.orange);
            },
            child: Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPaymentSection(double finalAmount, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFB8941F)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
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
                  "₹${finalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'PlayfairDisplay',
                  ),
                ),
                Text(
                  "Includes ₹$fuelCharge fuel charge",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _payFromWalletOrRazorpay,
                icon: Icon(Icons.shopping_cart_checkout, size: 20),
                label: Text(
                  "Pay Now",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFFD4AF37),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, bool isDarkMode) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.white60 : Colors.brown[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Color(0xFFD4AF37),
          ),
        ),
      ],
    );
  }

  void _showClearCartConfirmation(CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF2A2A2A)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Clear Cart",
          style: TextStyle(color: Color(0xFFD4AF37)),
        ),
        content: Text("Are you sure you want to remove all items from your cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                cartProvider.clearCart(user.uid);
              }
              Navigator.pop(context);
              _showCustomToast("🗑️ Cart cleared", Colors.orange);
            },
            child: Text("Clear All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final cartProvider = Provider.of<CartProvider>(context);
    final total = cartProvider.totalPrice;
    final finalAmount = total + fuelCharge;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF0A0A0A) : Color(0xFFF8F5F0),
      appBar: AppBar(
        title: Text(
          "🛒 My Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
        backgroundColor: isDarkMode ? Color(0xFF1A0F0F) : Color(0xFFF4E4BC),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Color(0xFF1A0F0F), Color(0xFF2D1B1B)]
                  : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          if (cartProvider.cartItems.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep, color: Color(0xFFD4AF37)),
              onPressed: () => _showClearCartConfirmation(cartProvider),
            ),
        ],
      ),
      body: Column(
        children: [
          // Cart Summary
          if (cartProvider.cartItems.isNotEmpty)
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
                      : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem("Items", "${cartProvider.cartItems.length}", isDarkMode),
                  _buildSummaryItem("Subtotal", "₹${total.toStringAsFixed(2)}", isDarkMode),
                  _buildSummaryItem("Fuel Charge", "₹$fuelCharge", isDarkMode),
                ],
              ),
            ),

          // Cart Items or Empty State
          if (cartProvider.cartItems.isEmpty)
            _buildEmptyCartState(isDarkMode)
          else
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartProvider.cartItems[index];
                  return _buildCartItem(item, isDarkMode, cartProvider);
                },
              ),
            ),

          // Bottom Payment Section
          if (cartProvider.cartItems.isNotEmpty)
            _buildBottomPaymentSection(finalAmount, isDarkMode),
        ],
      ),
    );
  }
}