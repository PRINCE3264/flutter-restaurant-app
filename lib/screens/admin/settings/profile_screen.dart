import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      drawer: const AdminSidebar(),
      body: const Center(child: Text('Profile Page')),
    );
  }
}
