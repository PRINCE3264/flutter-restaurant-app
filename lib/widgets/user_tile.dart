import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String email;
  final String role;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserTile({super.key, required this.email, required this.role, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person, color: role == 'admin' ? Colors.deepPurple : Colors.grey),
      title: Text(email),
      subtitle: Text("Role: $role"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
        ],
      ),
    );
  }
}
