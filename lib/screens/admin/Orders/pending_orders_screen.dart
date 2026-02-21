import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';

class PendingOrdersScreen extends StatelessWidget {
  const PendingOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pending Orders'),
      drawer: const AdminSidebar(),
      body: const Center(child: Text('Pending Orders Page')),
    );
  }
}
