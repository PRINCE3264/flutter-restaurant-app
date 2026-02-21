import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Employee List'),
      drawer: const AdminSidebar(),
      body: const Center(child: Text('Employee List Page')),
    );
  }
}
