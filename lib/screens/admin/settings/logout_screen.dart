import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  void _confirmLogout(BuildContext context) {
    // TODO: perform actual sign out, clear storage, then navigate to login
    Navigator.pushReplacementNamed(context, '/'); // currently goes to Dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Logout'),
      drawer: const AdminSidebar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _confirmLogout(context),
          child: const Text('Confirm Logout (demo)'),
        ),
      ),
    );
  }
}
