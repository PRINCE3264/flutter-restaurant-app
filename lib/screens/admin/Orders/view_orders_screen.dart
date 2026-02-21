import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';

class ViewOrdersScreen extends StatelessWidget {
  const ViewOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'View Orders'),
      drawer: const AdminSidebar(),
      body: const Center(child: Text('View Orders Page')),
    );
  }
}
