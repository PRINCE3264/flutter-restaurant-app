import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Categories'),
      drawer: const AdminSidebar(),
      body: const Center(child: Text('Categories Management Page')),
    );
  }
}
