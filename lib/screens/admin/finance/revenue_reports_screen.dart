import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';


class RevenueReportsScreen extends StatelessWidget {
  const RevenueReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Revenue Reports'),
      drawer: const AdminSidebar(),
      body: const Center(child: Text('Revenue Reports Page')),
    );
  }
}
