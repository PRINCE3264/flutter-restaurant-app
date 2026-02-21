import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String customerName;
  final List<String> items;
  final String status;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.items,
    required this.status,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order #$orderId",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("Customer: $customerName"),
            const SizedBox(height: 6),
            Text("Items: ${items.join(", ")}"),
            const SizedBox(height: 6),
            Text("Status: $status",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: status == "Pending"
                        ? Colors.orange
                        : status == "Accepted"
                        ? Colors.green
                        : Colors.red)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                    onPressed: onAccept,
                    child: const Text("Accept"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: onReject,
                    child: const Text("Reject"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
