
//
// import 'package:flutter/material.dart';
// import '../../services/firestore_service.dart';
//
// class ManageUsersScreen extends StatefulWidget {
//   final FirestoreService firestoreService;
//   const ManageUsersScreen({super.key, required this.firestoreService});
//
//   @override
//   State<ManageUsersScreen> createState() => _ManageUsersScreenState();
// }
//
// class _ManageUsersScreenState extends State<ManageUsersScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _listAnimationController;
//
//   @override
//   void initState() {
//     super.initState();
//     _listAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//     _listAnimationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _listAnimationController.dispose();
//     super.dispose();
//   }
//
//   Color getRoleColor(String role) {
//     return role == 'admin' ? Colors.deepPurple : Colors.blue;
//   }
//
//   Widget _buildUserCard(Map<String, dynamic> user, int index) {
//     final animation = CurvedAnimation(
//       parent: _listAnimationController,
//       curve: Interval(0.1 * index, 1.0, curve: Curves.easeOut),
//     );
//
//     return FadeTransition(
//       opacity: animation,
//       child: SlideTransition(
//         position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
//             .animate(animation),
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4)),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor:
//                   getRoleColor(user['role'] ?? 'user').withOpacity(0.15),
//                   child: Icon(
//                     Icons.person_outline,
//                     color: getRoleColor(user['role'] ?? 'user'),
//                     size: 28,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(user['name'] ?? 'No Name',
//                           style: const TextStyle(
//                               fontSize: 17, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 4),
//                       Text(user['email'] ?? 'No Email',
//                           style: const TextStyle(
//                               color: Colors.black54, fontSize: 14)),
//                       const SizedBox(height: 8),
//                       DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           value: user['role'] ?? 'user',
//                           items: const [
//                             DropdownMenuItem(value: 'user', child: Text('User')),
//                             DropdownMenuItem(value: 'admin', child: Text('Admin')),
//                           ],
//                           onChanged: (newRole) {
//                             if (newRole != null) {
//                               widget.firestoreService.updateUser(
//                                   user['uid'], {'role': newRole});
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.orange),
//                   onPressed: () => _showEditDialog(user['uid'], user['name']),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => _showDeleteConfirmation(user['uid']),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: widget.firestoreService.getAllUsers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final users = snapshot.data ?? [];
//           if (users.isEmpty) return const Center(child: Text("No users found"));
//
//           _listAnimationController.forward(from: 0.0);
//
//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             itemCount: users.length,
//             itemBuilder: (context, index) =>
//                 _buildUserCard(users[index], index),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addUserDialog,
//         backgroundColor: Colors.deepPurple,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
//
//   Future<void> _showEditDialog(String uid, String currentName) async {
//     final controller = TextEditingController(text: currentName);
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Edit User Name"),
//         content: TextField(controller: controller, autofocus: true),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () {
//               final newName = controller.text.trim();
//               if (newName.isNotEmpty) {
//                 widget.firestoreService.updateUser(uid, {'name': newName});
//               }
//               Navigator.pop(context);
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showDeleteConfirmation(String uid) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete User"),
//         content: const Text(
//             "Are you sure you want to delete this user? This action cannot be undone."),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () {
//               widget.firestoreService.deleteUser(uid);
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _addUserDialog() {
//     final nameController = TextEditingController();
//     final emailController = TextEditingController();
//     String role = 'user';
//
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setStateDialog) => AlertDialog(
//           title: const Text("Add New User"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),
//                 const SizedBox(height: 8),
//                 TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email Address")),
//                 const SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: role,
//                   decoration: const InputDecoration(labelText: "Assign Role", border: OutlineInputBorder()),
//                   items: const [
//                     DropdownMenuItem(value: 'user', child: Text('User')),
//                     DropdownMenuItem(value: 'admin', child: Text('Admin')),
//                   ],
//                   onChanged: (newRole) {
//                     if (newRole != null) setStateDialog(() => role = newRole);
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//             ElevatedButton(
//               onPressed: () {
//                 final name = nameController.text.trim();
//                 final email = emailController.text.trim();
//                 if (name.isNotEmpty && email.isNotEmpty) {
//                   widget.firestoreService.addUser({'name': name, 'email': email, 'role': role});
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text("Add User"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsersScreen extends StatefulWidget {
  final FirestoreService firestoreService;
  const ManageUsersScreen({super.key, required this.firestoreService});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen>
    with TickerProviderStateMixin {
  late AnimationController _listAnimationController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterRole = 'all';

  @override
  void initState() {
    super.initState();
    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Safe date parsing function
  DateTime _parseDate(dynamic dateValue) {
    try {
      if (dateValue == null) return DateTime.now();
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) return DateTime.parse(dateValue).toLocal();
      if (dateValue is Timestamp) return dateValue.toDate().toLocal();
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  // Helper method for avatar colors
  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFF1abc9c),
      const Color(0xFF3498db),
      const Color(0xFF9b59b6),
      const Color(0xFFe67e22),
      const Color(0xFFe74c3c),
      const Color(0xFF34495e),
    ];
    final index = name.hashCode % colors.length;
    return colors[index];
  }

  // Helper method for role background colors
  Color _getRoleBackgroundColor(String role) {
    switch (role) {
      case 'admin':
        return const Color(0xFFD4AF37).withOpacity(0.1);
      case 'vendor':
        return Colors.blue.withOpacity(0.1);
      case 'premium':
        return Colors.purple.withOpacity(0.1);
      default:
        return Colors.green.withOpacity(0.1);
    }
  }

  // Helper method for role text colors
  Color _getRoleTextColor(String role) {
    switch (role) {
      case 'admin':
        return const Color(0xFFD4AF37);
      case 'vendor':
        return Colors.blue;
      case 'premium':
        return Colors.purple;
      default:
        return Colors.green;
    }
  }

  // Role update function
  void _updateUserRole(String userId, String newRole) {
    if (userId.isNotEmpty) {
      widget.firestoreService.updateUser(userId, {'role': newRole});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Role updated to $newRole'),
          backgroundColor: const Color(0xFFD4AF37),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Show role selection dialog
  void _showRoleSelectionDialog(Map<String, dynamic> user) {
    final userName = user['name']?.toString() ?? 'Unknown User';
    final currentRole = user['role']?.toString() ?? 'user';
    final userUid = user['uid']?.toString() ?? '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Change Role for $userName",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRoleOption('user', 'User', currentRole, userUid),
            _buildRoleOption('vendor', 'Vendor', currentRole, userUid),
            _buildRoleOption('premium', 'Premium', currentRole, userUid),
            _buildRoleOption('admin', 'Admin', currentRole, userUid),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption(String role, String label, String currentRole, String userUid) {
    final isSelected = currentRole == role;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
            border: Border.all(
              color: isSelected ? const Color(0xFFD4AF37) : Colors.grey,
            ),
          ),
          child: isSelected
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getRoleBackgroundColor(role),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            role.toUpperCase(),
            style: TextStyle(
              color: _getRoleTextColor(role),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          _updateUserRole(userUid, role);
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, int index) {
    final animation = CurvedAnimation(
      parent: _listAnimationController,
      curve: Interval(0.1 * index, 1.0, curve: Curves.easeOut),
    );

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userRole = user['role']?.toString() ?? 'user';

    // Safe date handling
    final joinDate = _parseDate(user['createdAt']);
    final formattedDate = '${joinDate.day}/${joinDate.month}/${joinDate.year}';

    // Safe string handling
    final userName = user['name']?.toString() ?? 'No Name';
    final userEmail = user['email']?.toString() ?? 'No Email';
    final userUid = user['uid']?.toString() ?? '';

    // Get display name abbreviation for avatar
    final nameAbbreviation = userName.length > 2
        ? userName.substring(0, 2).toUpperCase()
        : userName.toUpperCase();

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(animation),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar (Simple circle with initials)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getAvatarColor(userName),
                  ),
                  child: Center(
                    child: Text(
                      nameAbbreviation,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // User Information - Main Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Role
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              userName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? Colors.white : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Role badge with tap to change
                          GestureDetector(
                            onTap: () => _showRoleSelectionDialog(user),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getRoleBackgroundColor(userRole),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _getRoleTextColor(userRole).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    userRole.toUpperCase(),
                                    style: TextStyle(
                                      color: _getRoleTextColor(userRole),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 14,
                                    color: _getRoleTextColor(userRole),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        userEmail,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.grey[700],
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Join Date
                      Text(
                        'Joined $formattedDate',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white60 : Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Status and Actions Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (user['isActive'] ?? true)
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (user['isActive'] ?? true) ? 'Activé' : 'Inactive',
                        style: TextStyle(
                          color: (user['isActive'] ?? true) ? Colors.green : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Role Type Display
                    Text(
                      userRole == 'admin' ? 'Admin' : 'User',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Quick Action Buttons
                    Row(
                      children: [
                        // Edit Button
                        GestureDetector(
                          onTap: () => _showEditDialog(userUid, userName),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Delete Button
                        GestureDetector(
                          onTap: () => _showDeleteConfirmation(user),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _filterUsers(List<Map<String, dynamic>> users) {
    var filtered = users.where((user) {
      final name = user['name']?.toString().toLowerCase() ?? '';
      final email = user['email']?.toString().toLowerCase() ?? '';
      final role = user['role']?.toString() ?? 'user';

      final matchesSearch = name.contains(_searchQuery.toLowerCase()) ||
          email.contains(_searchQuery.toLowerCase());

      final matchesRole = _filterRole == 'all' || role == _filterRole;

      return matchesSearch && matchesRole;
    }).toList();

    // Sort: admins first, then by name
    filtered.sort((a, b) {
      final roleA = a['role']?.toString() ?? 'user';
      final roleB = b['role']?.toString() ?? 'user';
      final nameA = a['name']?.toString() ?? '';
      final nameB = b['name']?.toString() ?? '';

      if (roleA == 'admin' && roleB != 'admin') return -1;
      if (roleA != 'admin' && roleB == 'admin') return 1;
      return nameA.compareTo(nameB);
    });

    return filtered;
  }

  Widget _buildSearchAndFilter() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white60 : Colors.grey[600],
              ),
              prefixIcon: Icon(Icons.search, color: const Color(0xFFD4AF37)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                _buildFilterChip('Users', 'user'),
                _buildFilterChip('Vendors', 'vendor'),
                _buildFilterChip('Admin', 'admin'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterRole == value;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) => setState(() => _filterRole = value),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        selectedColor: const Color(0xFFD4AF37),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: const Color(0xFFD4AF37).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No Users Found' : 'No Matching Users',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Start by adding your first user'
                : 'Try adjusting your search or filters',
            style: TextStyle(
              color: isDarkMode ? Colors.white54 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF8F5F0),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: widget.firestoreService.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: const Color(0xFFD4AF37)),
                        const SizedBox(height: 16),
                        Text(
                          "Loading Users...",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: const Color(0xFFD4AF37),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Error loading users",
                          style: TextStyle(
                            fontSize: 18,
                            color: isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final users = snapshot.data ?? [];
                final filteredUsers = _filterUsers(users);

                if (filteredUsers.isEmpty) {
                  return _buildEmptyState();
                }

                _listAnimationController.forward(from: 0.0);

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) =>
                      _buildUserCard(filteredUsers[index], index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUserDialog,
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.white,
        tooltip: 'Add New User',
        child: const Icon(Icons.person_add, size: 28),
        elevation: 4,
      ),
    );
  }

  Future<void> _showEditDialog(String uid, String currentName) async {
    final controller = TextEditingController(text: currentName);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Edit User Name",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: "Full Name",
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFD4AF37)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && uid.isNotEmpty) {
                widget.firestoreService.updateUser(uid, {'name': newName});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('✅ User name updated'),
                    backgroundColor: const Color(0xFFD4AF37),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> user) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userName = user['name']?.toString() ?? 'Unknown User';
    final userUid = user['uid']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Delete User",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete $userName? This action cannot be undone.",
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (userUid.isNotEmpty) {
                widget.firestoreService.deleteUser(userUid);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🗑️ $userName deleted'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text("Delete User"),
          ),
        ],
      ),
    );
  }

  void _addUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    String role = 'user';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Add New User",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number (Optional)",
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: InputDecoration(
                    labelText: "Assign Role",
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  dropdownColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                  items: const [
                    DropdownMenuItem(value: 'user', child: Text('User')),
                    DropdownMenuItem(value: 'vendor', child: Text('Vendor')),
                    DropdownMenuItem(value: 'premium', child: Text('Premium User')),
                    DropdownMenuItem(value: 'admin', child: Text('Administrator')),
                  ],
                  onChanged: (newRole) {
                    if (newRole != null) {
                      setStateDialog(() => role = newRole);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final phone = phoneController.text.trim();

                if (name.isNotEmpty && email.isNotEmpty) {
                  final userData = {
                    'name': name,
                    'email': email,
                    'role': role,
                    'phone': phone.isNotEmpty ? phone : null,
                    'createdAt': DateTime.now().toIso8601String(),
                    'isActive': true,
                  };

                  widget.firestoreService.addUser(userData);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('✅ User added successfully'),
                      backgroundColor: const Color(0xFFD4AF37),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text("Add User"),
            ),
          ],
        ),
      ),
    );
  }
}