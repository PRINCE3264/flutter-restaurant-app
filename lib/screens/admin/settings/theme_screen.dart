import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Theme'),
      drawer: const AdminSidebar(),
      body: const Center(child: Text('Theme Settings Page')),
    );
  }
}
