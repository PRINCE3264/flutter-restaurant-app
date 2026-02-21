import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  void _navigate(BuildContext context, String route) {
    final current = ModalRoute.of(context)?.settings.name;
    // If already on that route, just close drawer
    if (current == route) {
      Navigator.pop(context);
      return;
    }
    // replace current page
    Navigator.pushReplacementNamed(context, route);
  }

  Widget _menuTile(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () => _navigate(context, route),
    );
  }

  Widget _subMenuTile(BuildContext context, String title, String route) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 60.0, right: 16.0),
      title: Text(title),
      onTap: () => _navigate(context, route),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueAccent),
              accountName: const Text('Admin'),
              accountEmail: const Text('admin@example.com'),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.admin_panel_settings, size: 36, color: Colors.white),
                backgroundColor: Colors.black12,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _menuTile(context, Icons.dashboard, 'Dashboard', '/'),
                  ExpansionTile(
                    leading: const Icon(Icons.shopping_cart, color: Colors.blue),
                    title: const Text('Orders'),
                    children: [
                      _subMenuTile(context, 'View Orders', '/orders/view'),
                      _subMenuTile(context, 'Pending Orders', '/orders/pending'),
                      _subMenuTile(context, 'Completed Orders', '/orders/completed'),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.people, color: Colors.blue),
                    title: const Text('Employees'),
                    children: [
                      _subMenuTile(context, 'Employee List', '/employees/list'),
                      _subMenuTile(context, 'Add Employee', '/employees/add'),
                      _subMenuTile(context, 'Attendance', '/employees/attendance'),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.attach_money, color: Colors.blue),
                    title: const Text('Finance'),
                    children: [
                      _subMenuTile(context, 'Revenue Reports', '/finance/revenue'),
                      _subMenuTile(context, 'Expenses', '/finance/expenses'),
                      _subMenuTile(context, 'Payment Gateway Logs', '/finance/payment_logs'),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.shopping_bag, color: Colors.blue),
                    title: const Text('Products'),
                    children: [
                      _subMenuTile(context, 'Product List', '/products/list'),
                      _subMenuTile(context, 'Add Product', '/products/add'),
                      _subMenuTile(context, 'Categories', '/products/categories'),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.admin_panel_settings, color: Colors.blue),
                    title: const Text('Users & Roles'),
                    children: [
                      _subMenuTile(context, 'Manage Users', '/users/manage'),
                      _subMenuTile(context, 'Roles & Permissions', '/users/roles'),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.settings, color: Colors.blue),
                    title: const Text('Settings'),
                    children: [
                      _subMenuTile(context, 'Profile', '/settings/profile'),
                      _subMenuTile(context, 'Theme', '/settings/theme'),
                      _subMenuTile(context, 'Logout', '/logout'),
                    ],
                  ),
                ],
              ),
            ),
            // optional footer
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('v1.0.0', style: TextStyle(color: Colors.grey[600])),
            )
          ],
        ),
      ),
    );
  }
}
