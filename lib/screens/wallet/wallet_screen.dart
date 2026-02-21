//
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import '../../providers/wallet_provider.dart';
//
// class WalletScreen extends StatefulWidget {
//   final String userId;
//   final double? amount; // optional top-up amount
//   final String? orderId; // optional order payment
//
//   const WalletScreen({
//     super.key,
//     required this.userId,
//     this.amount,
//     this.orderId,
//   });
//
//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }
//
// class _WalletScreenState extends State<WalletScreen> {
//   late Razorpay _razorpay;
//   int _pendingPaise = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternal);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final walletProvider = Provider.of<WalletProvider>(context, listen: false);
//       walletProvider.updateUserId(widget.userId);
//       await walletProvider.fetchWallet();
//
//       if ((widget.amount ?? 0) > 0) _startPayment(widget.amount!);
//     });
//   }
//
//   void _startPayment(double amount) {
//     _pendingPaise = (amount * 100).toInt();
//     final options = {
//       'key': 'rzp_test_RGlPdevCgkpRiA',
//       'amount': _pendingPaise,
//       'name': 'Food App',
//       'description': widget.orderId != null
//           ? 'Order Payment #${widget.orderId}'
//           : 'Wallet Top-up',
//       'prefill': {
//         'contact': '9508604799',
//         'email': 'princekumarvidyarthi4@gmail.com'
//       },
//       'currency': 'INR',
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('⚠️ Razorpay open error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment failed: $e')),
//       );
//     }
//   }
//
//   Future<void> _handleSuccess(PaymentSuccessResponse response) async {
//     final provider = Provider.of<WalletProvider>(context, listen: false);
//     provider.updateUserId(widget.userId);
//     final paidAmount = _pendingPaise / 100.0;
//
//     try {
//       if (widget.orderId != null) {
//         await provider.debit(paidAmount, 'Order Payment #${widget.orderId}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('✅ Order Payment Successful!')),
//         );
//       } else {
//         await provider.topUp(paidAmount,
//             description: 'Wallet Top-up via Razorpay');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('✅ Wallet Top-up Successful!')),
//         );
//       }
//       await provider.fetchWallet();
//     } catch (e) {
//       debugPrint('❌ Payment handler error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Transaction failed: $e')),
//       );
//     }
//   }
//
//   void _handleError(PaymentFailureResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content:
//           Text('❌ Payment Failed: ${response.message ?? "Unknown"}')),
//     );
//   }
//
//   void _handleExternal(ExternalWalletResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content: Text(
//               'External Wallet Selected: ${response.walletName ?? "Unknown"}')),
//     );
//   }
//
//   void _showTopUpDialog() {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Add Money to Wallet'),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(labelText: 'Enter amount'),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               final amt = double.tryParse(controller.text);
//               if (amt != null && amt > 0) {
//                 Navigator.pop(ctx);
//                 _startPayment(amt);
//               }
//             },
//             child: const Text('Top-up'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) =>
//       '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     // Color and text setup based on theme
//     final appBarBgColor =
//     isDarkMode ? Colors.grey[900]! : const Color(0xFFE0F7FA);
//     final appBarTextColor = isDarkMode ? Colors.white : Colors.black;
//
//     return Consumer<WalletProvider>(
//       builder: (context, provider, _) {
//         final balance = provider.balance;
//
//         return Scaffold(
//           backgroundColor: const Color(0xFFF2F3F8),
//           appBar: AppBar(
//             title: Text(
//               'My Wallet',
//               style: TextStyle(
//                 color: appBarTextColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             backgroundColor: appBarBgColor,
//             elevation: 0,
//             iconTheme: IconThemeData(color: appBarTextColor),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.refresh, color: appBarTextColor),
//                 onPressed: provider.fetchWallet,
//               ),
//               IconButton(
//                 icon: Icon(Icons.add, color: appBarTextColor),
//                 onPressed: _showTopUpDialog,
//               ),
//             ],
//           ),
//           body: provider.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Column(
//             children: [
//               Card(
//                 margin: const EdgeInsets.all(16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text('Balance', style: TextStyle(fontSize: 18)),
//                       Text(
//                         '₹${balance.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8),
//                 child: Text('Transactions',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//               Expanded(
//                 child: provider.transactions.isEmpty
//                     ? const Center(child: Text('No transactions yet'))
//                     : ListView.builder(
//                   itemCount: provider.transactions.length,
//                   itemBuilder: (context, index) {
//                     final tx = provider.transactions[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 4),
//                       child: ListTile(
//                         leading: Icon(
//                           tx.type == 'credit'
//                               ? Icons.arrow_downward
//                               : Icons.arrow_upward,
//                           color: tx.type == 'credit'
//                               ? Colors.green
//                               : Colors.red,
//                         ),
//                         title: Text(tx.description),
//                         subtitle: Text(_formatDate(tx.date)),
//                         trailing: Text(
//                           '${tx.type == 'credit' ? '+' : '-'} ₹${tx.amount.toStringAsFixed(2)}',
//                           style: TextStyle(
//                               color: tx.type == 'credit'
//                                   ? Colors.green
//                                   : Colors.red,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
//
//
//




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../providers/wallet_provider.dart';

class WalletScreen extends StatefulWidget {
  final String userId;
  final double? amount; // optional top-up amount
  final String? orderId; // optional order payment

  const WalletScreen({
    super.key,
    required this.userId,
    this.amount,
    this.orderId,
  });

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Razorpay _razorpay;
  int _pendingPaise = 0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternal);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      walletProvider.updateUserId(widget.userId);
      await walletProvider.fetchWallet();

      if ((widget.amount ?? 0) > 0) _startPayment(widget.amount!);
    });
  }

  void _startPayment(double amount) {
    _pendingPaise = (amount * 100).toInt();
    final options = {
      'key': 'rzp_test_RGlPdevCgkpRiA',
      'amount': _pendingPaise,
      'name': 'Food App',
      'description': widget.orderId != null
          ? 'Order Payment #${widget.orderId}'
          : 'Wallet Top-up',
      'prefill': {
        'contact': '9508604799',
        'email': 'princekumarvidyarthi4@gmail.com'
      },
      'currency': 'INR',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('⚠️ Razorpay open error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleSuccess(PaymentSuccessResponse response) async {
    final provider = Provider.of<WalletProvider>(context, listen: false);
    provider.updateUserId(widget.userId);
    final paidAmount = _pendingPaise / 100.0;

    try {
      if (widget.orderId != null) {
        await provider.debit(paidAmount, 'Order Payment #${widget.orderId}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Order Payment Successful!'),
            backgroundColor: const Color(0xFFD4AF37),
          ),
        );
      } else {
        await provider.topUp(paidAmount,
            description: 'Wallet Top-up via Razorpay');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Wallet Top-up Successful!'),
            backgroundColor: const Color(0xFFD4AF37),
          ),
        );
      }
      await provider.fetchWallet();
    } catch (e) {
      debugPrint('❌ Payment handler error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Payment Failed: ${response.message ?? "Unknown"}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternal(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'External Wallet Selected: ${response.walletName ?? "Unknown"}'),
        backgroundColor: const Color(0xFFD4AF37),
      ),
    );
  }

  void _showTopUpDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add Money to Wallet',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter amount',
            labelStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFD4AF37)),
              borderRadius: BorderRadius.circular(12),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final amt = double.tryParse(controller.text);
              if (amt != null && amt > 0) {
                Navigator.pop(ctx);
                _startPayment(amt);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid amount'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Top-up'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final balance = provider.balance;

        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8F5F0),
          appBar: AppBar(
            title: Text(
              '💰 My Wallet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: isDarkMode ? Colors.white : Colors.black87,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            backgroundColor: isDarkMode ? const Color(0xFF1A0F0F) : const Color(0xFFF4E4BC),
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [const Color(0xFF1A0F0F), const Color(0xFF2D1B1B)]
                      : [const Color(0xFFF4E4BC), const Color(0xFFE8D9B0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFFD4AF37)),
                onPressed: provider.fetchWallet,
                tooltip: 'Refresh',
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFFD4AF37)),
                onPressed: _showTopUpDialog,
                tooltip: 'Add Money',
              ),
            ],
          ),
          body: provider.isLoading
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: const Color(0xFFD4AF37)),
                const SizedBox(height: 16),
                Text(
                  "Loading Wallet...",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.brown[700],
                  ),
                ),
              ],
            ),
          )
              : Column(
            children: [
              // Balance Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
                        : [const Color(0xFFD4AF37), const Color(0xFFB8941F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white70 : Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _showTopUpDialog,
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: const Text('Add Money'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFD4AF37),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),

              // Transactions Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    const Icon(Icons.history, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 8),
                    Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontFamily: 'PlayfairDisplay',
                      ),
                    ),
                  ],
                ),
              ),

              // Transactions List
              Expanded(
                child: provider.transactions.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 80,
                        color: const Color(0xFFD4AF37).withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Transactions Yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your transactions will appear here',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white54 : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: provider.transactions.length,
                  itemBuilder: (context, index) {
                    final tx = provider.transactions[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDarkMode
                              ? [const Color(0xFF2D1B1B), const Color(0xFF3A2323)]
                              : [Colors.white, const Color(0xFFF8F5F0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: tx.type == 'credit'
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            tx.type == 'credit'
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: tx.type == 'credit' ? Colors.green : Colors.red,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          tx.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          _formatDate(tx.date),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                        trailing: Text(
                          '${tx.type == 'credit' ? '+' : '-'} ₹${tx.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: tx.type == 'credit' ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

