import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';

class CompletedOrdersScreen extends StatelessWidget {
  const CompletedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Completed Orders'),
      drawer: const AdminSidebar(),
      body: const Center(child: Text('Completed Orders Page')),
    );
  }
}
