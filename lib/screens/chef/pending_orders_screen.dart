import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ChefPendingOrdersScreen extends StatelessWidget {
  const ChefPendingOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chef Pending Orders")),
      body: const Center(
        child: Text(
          "Pending orders list (UI only)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
      ),
    );
  }
}
