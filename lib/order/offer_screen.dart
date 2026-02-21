import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});
  final String vendorId = 'vendor_123';
  final double totalOrderAmount = 350; // Example amount

  Future<double> calculateDiscount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('offers')
        .where('vendorId', isEqualTo: vendorId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final offer = snapshot.docs.first;
      final minAmount = offer['minOrderAmount'];
      final discount = offer['discountPercentage'];
      if (totalOrderAmount >= minAmount) {
        return totalOrderAmount * discount / 100;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offers & Discounts')),
      body: FutureBuilder<double>(
        future: calculateDiscount(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final discount = snapshot.data!;
          return Center(
            child: Text(
              'Order Total: $totalOrderAmount\nDiscount: $discount\nFinal Amount: ${totalOrderAmount - discount}',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
