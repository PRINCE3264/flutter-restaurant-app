import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuScreen extends StatelessWidget {
  final String vendorId;
  const MenuScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    final menuRef = FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('menuItems');

    return Scaffold(
      appBar: AppBar(title: const Text("Menu")),
      body: StreamBuilder<QuerySnapshot>(
        stream: menuRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No menu items found"));
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final data = item.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(data['name'] ?? ''),
                  subtitle: Text("${data['description'] ?? ''}"),
                  trailing: Text("₹${data['price'] ?? 0}"),
                  onTap: () {
                    // Optional: Add to cart
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
