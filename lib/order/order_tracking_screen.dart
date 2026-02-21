// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class OrderTrackingScreen extends StatelessWidget {
//   const OrderTrackingScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Order Tracking')),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('orders')
//             .where('userId', isEqualTo: userId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const CircularProgressIndicator();
//           final orders = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               final order = orders[index];
//               return ListTile(
//                 title: Text('Order ID: ${order.id}'),
//                 subtitle: Text('Status: ${order['status']}'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  final List<String> statusSteps = const [
    "Placed",
    "Accepted",
    "Preparing",
    "Ready",
    "Completed"
  ];

  Color _getStatusColor(String step, String currentStatus) {
    int stepIndex = statusSteps.indexOf(step);
    int currentIndex = statusSteps.indexOf(currentStatus);
    if (stepIndex < currentIndex) return Colors.green;
    if (stepIndex == currentIndex) return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final status = order['status'] as String;

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID: ${order.id}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildStatusStepper(status),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusStepper(String currentStatus) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: statusSteps.map((step) {
        final color = _getStatusColor(step, currentStatus);
        final isLast = step == statusSteps.last;

        return Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: color,
                child: Icon(
                  color == Colors.grey ? Icons.radio_button_unchecked : Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isLast)
                Container(
                  height: 4,
                  color: color,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
