import 'package:flutter/material.dart';
import '../../order/order.dart';


class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final double totalAmount;
  final double fuelCharge;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.fuelCharge,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Placed"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text(
                "Your order has been placed!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text("Order ID: $orderId",
                  style: const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 8),
              Text("Fuel Charge: ₹${fuelCharge.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 8),
              Text("Total Amount: ₹${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Navigate to My Orders page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const OrderPage(
                          userId: "user123", // Replace with current user id
                        )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "View My Orders",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
