//
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../models/wallet_transaction.dart';
// import '../../providers/wallet_provider.dart' ;
//
// class TransactionListScreen extends StatelessWidget {
//   const TransactionListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final walletProvider = Provider.of<WalletProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Transaction History"),
//         backgroundColor: Colors.orange,
//       ),
//       body: walletProvider.transactions.isEmpty
//           ? const Center(
//         child: Text(
//           "No transactions yet.",
//           style: TextStyle(fontSize: 18),
//         ),
//       )
//           : ListView.builder(
//         itemCount: walletProvider.transactions.length,
//         itemBuilder: (context, index) {
//           final WalletTransaction tx = walletProvider.transactions[index] as WalletTransaction;
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: tx.type == 'credit' ? Colors.green : Colors.red,
//                 child: Icon(
//                   tx.type == 'credit' ? Icons.arrow_downward : Icons.arrow_upward,
//                   color: Colors.white,
//                 ),
//               ),
//               title: Text(
//                 tx.description,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(
//                 "${tx.date.day.toString().padLeft(2, '0')}/${tx.date.month.toString().padLeft(2, '0')}/${tx.date.year} "
//                     "${tx.date.hour.toString().padLeft(2, '0')}:${tx.date.minute.toString().padLeft(2, '0')}",
//               ),
//               trailing: Text(
//                 "${tx.type == 'credit' ? '+' : '-'} \$${tx.amount.toStringAsFixed(2)}",
//                 style: TextStyle(
//                   color: tx.type == 'credit' ? Colors.green : Colors.red,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/wallet_transaction.dart';
import '../../providers/wallet_provider.dart'  hide WalletTransaction;

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        backgroundColor: Colors.orange,
      ),
      body: walletProvider.transactions.isEmpty
          ? const Center(
        child: Text(
          "No transactions yet.",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: walletProvider.transactions.length,
        itemBuilder: (context, index) {
          final WalletTransaction tx = walletProvider.transactions[index] as WalletTransaction;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: tx.type == 'credit' ? Colors.green : Colors.red,
                child: Icon(
                  tx.type == 'credit' ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
              title: Text(
                tx.description,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${tx.date.day.toString().padLeft(2, '0')}/${tx.date.month.toString().padLeft(2, '0')}/${tx.date.year} "
                    "${tx.date.hour.toString().padLeft(2, '0')}:${tx.date.minute.toString().padLeft(2, '0')}",
              ),
              trailing: Text(
                "${tx.type == 'credit' ? '+' : '-'} \$${tx.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: tx.type == 'credit' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

