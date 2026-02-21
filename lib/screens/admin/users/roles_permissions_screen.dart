import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';

class RolesPermissionsScreen extends StatelessWidget {
  const RolesPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Roles & Permissions'),
      drawer: const AdminSidebar(),
      body: const Center(child: Text('Roles & Permissions Page')),
    );
  }
}
