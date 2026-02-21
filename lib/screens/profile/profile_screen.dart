//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// // ================= Profile Screen =================
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   String _name = "PRINCE VIDYARTHI";
//   String _email = "vidyarthiprince@gmail.com";
//   String _phone = "9508604799";
//   String _address = "Surat, Gujarat";
//   String _avatarUrl =
//       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6RjNiUXjrkDtYpezg41p0EL3KXNKIq0fBWA&s";
//
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     setState(() => _isLoading = true);
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc =
//         await _firestore.collection('users').doc(user.uid).get();
//
//         if (userDoc.exists && userDoc.data() != null) {
//           final data = userDoc.data() as Map<String, dynamic>;
//           setState(() {
//             _name = data['name'] ?? _name;
//             _email = data['email'] ?? _email;
//             _phone = data['phone'] ?? _phone;
//             _address = data['address'] ?? _address;
//             _avatarUrl = data['avatarUrl'] ?? _avatarUrl;
//           });
//         }
//       }
//     } catch (e) {
//       print("Error loading user data: $e");
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final bool isDarkMode = theme.brightness == Brightness.dark;
//
//     if (_isLoading) {
//       return Scaffold(
//         backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
//         body: Center(
//             child: CircularProgressIndicator(color: theme.colorScheme.primary)),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
//       appBar: AppBar(
//         title: const Text("Profile"),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: isDarkMode
//                   ? [Colors.grey.shade900, Colors.grey.shade800]
//                   : [Color(0xFFE0F7FA), Color(0xFFE0F7FA)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         iconTheme: IconThemeData(
//           color: isDarkMode ? Colors.white : Colors.black87,
//         ),
//         titleTextStyle: TextStyle(
//           fontWeight: FontWeight.bold,
//           color: isDarkMode ? Colors.white : Colors.black87,
//           fontSize: 20,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header with Avatar
//             Container(
//               color: isDarkMode ? Colors.grey[850] : Colors.grey[300],
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(_avatarUrl),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     _name,
//                     style: theme.textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: isDarkMode ? Colors.white : Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Info Cards
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   _buildInfoCard(Icons.person_outline, "Name", _name, isDarkMode, theme),
//                   const SizedBox(height: 15),
//                   _buildInfoCard(Icons.phone_android, "Phone", _phone, isDarkMode, theme),
//                   const SizedBox(height: 15),
//                   _buildInfoCard(Icons.location_on_outlined, "Address", _address, isDarkMode, theme),
//                   const SizedBox(height: 15),
//                   _buildInfoCard(Icons.email_outlined, "Email", _email, isDarkMode, theme),
//                 ],
//               ),
//             ),
//
//             // Edit Button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     final updated = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => EditProfileScreen(
//                           name: _name,
//                           email: _email,
//                           phone: _phone,
//                           address: _address,
//                           avatarUrl: _avatarUrl,
//                         ),
//                       ),
//                     );
//                     if (updated == true) {
//                       _loadUserData();
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: theme.colorScheme.primary,
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text(
//                     "Edit Profile",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoCard(
//       IconData icon, String title, String subtitle, bool isDarkMode, ThemeData theme) {
//     return Card(
//       color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         leading: Icon(icon, color: theme.colorScheme.primary),
//         title: Text(title, style: theme.textTheme.titleMedium?.copyWith(color: isDarkMode ? Colors.white : Colors.black87)),
//         subtitle: Text(subtitle,
//             style: theme.textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.w500,
//                 color: isDarkMode ? Colors.white70 : Colors.black54)),
//         trailing: Icon(Icons.arrow_forward_ios,
//             size: 16, color: isDarkMode ? Colors.white70 : Colors.black54),
//       ),
//     );
//   }
// }
//
// // ================= Edit Profile Screen =================
// class EditProfileScreen extends StatefulWidget {
//   final String name;
//   final String email;
//   final String phone;
//   final String address;
//   final String avatarUrl;
//
//   const EditProfileScreen({
//     super.key,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.address,
//     required this.avatarUrl,
//   });
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneController;
//   late TextEditingController _addressController;
//   late String _avatarUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.name);
//     _emailController = TextEditingController(text: widget.email);
//     _phoneController = TextEditingController(text: widget.phone);
//     _addressController = TextEditingController(text: widget.address);
//     _avatarUrl = widget.avatarUrl;
//   }
//
//   Future<void> _saveProfile() async {
//     if (_formKey.currentState!.validate()) {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         try {
//           if (_emailController.text.trim() != user.email) {
//             await user.updateEmail(_emailController.text.trim());
//           }
//           await _firestore.collection('users').doc(user.uid).set({
//             'name': _nameController.text.trim(),
//             'email': _emailController.text.trim(),
//             'phone': _phoneController.text.trim(),
//             'address': _addressController.text.trim(),
//             'avatarUrl': _avatarUrl,
//           }, SetOptions(merge: true));
//
//           ScaffoldMessenger.of(context)
//               .showSnackBar(const SnackBar(content: Text("Profile Updated!")));
//
//           Navigator.pop(context, true);
//         } on FirebaseAuthException catch (e) {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final bool isDarkMode = theme.brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: isDarkMode
//                   ? [Colors.grey.shade900, Colors.grey.shade800]
//                   : [Color(0xFFE0F7FA), Color(0xFFE0F7FA)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         iconTheme: IconThemeData(
//           color: isDarkMode ? Colors.white : Colors.black87,
//         ),
//         titleTextStyle: TextStyle(
//           fontWeight: FontWeight.bold,
//           color: isDarkMode ? Colors.white : Colors.black87,
//           fontSize: 20,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 CircleAvatar(radius: 60, backgroundImage: NetworkImage(_avatarUrl)),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       // Replace with image picker if needed
//                       _avatarUrl =
//                       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6RjNiUXjrkDtYpezg41p0EL3KXNKIq0fBWA&s";
//                     });
//                   },
//                   child: const CircleAvatar(
//                     radius: 18,
//                     backgroundColor: Colors.blue,
//                     child: Icon(Icons.edit, color: Colors.white, size: 18),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       labelText: "Full Name",
//                       prefixIcon: const Icon(Icons.person),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     validator: (value) =>
//                     value!.isEmpty ? "Name cannot be empty" : null,
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: "Email",
//                       prefixIcon: const Icon(Icons.email),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     validator: (value) =>
//                     value!.isEmpty ? "Email cannot be empty" : null,
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: _phoneController,
//                     decoration: InputDecoration(
//                       labelText: "Phone",
//                       prefixIcon: const Icon(Icons.phone),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: _addressController,
//                     decoration: InputDecoration(
//                       labelText: "Address",
//                       prefixIcon: const Icon(Icons.location_on),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: _saveProfile,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: theme.colorScheme.primary,
//                       padding:
//                       const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: const Text("Save Changes",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ================= Enhanced Profile Screen =================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _name = "PRINCE VIDYARTHI";
  String _email = "vidyarthiprince@gmail.com";
  String _phone = "9508604799";
  String _address = "Surat, Gujarat";
  String _avatarUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6RjNiUXjrkDtYpezg41p0EL3KXNKIq0fBWA&s";

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _name = data['name'] ?? _name;
            _email = data['email'] ?? _email;
            _phone = data['phone'] ?? _phone;
            _address = data['address'] ?? _address;
            _avatarUrl = data['avatarUrl'] ?? _avatarUrl;
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDarkMode ? Color(0xFF0A0A0A) : Color(0xFFF8F5F0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFFD4AF37),
                strokeWidth: 2,
              ),
              SizedBox(height: 20),
              Text(
                "Loading Profile...",
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.brown[700],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF0A0A0A) : Color(0xFFF8F5F0),
      body: CustomScrollView(
        slivers: [
          // Header with decorative elements
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Decorative background with Indian pattern
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [Color(0xFF1A0F0F), Color(0xFF2D1B1B)]
                            : [Color(0xFFD4AF37), Color(0xFFF4E4BC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Traditional pattern overlay
                  Opacity(
                    opacity: 0.1,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/pattern.png'), // Add traditional pattern
                          repeat: ImageRepeat.repeat,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Profile Avatar with decorative border
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFD4AF37),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: Image.network(
                                  _avatarUrl,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.person, size: 40, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            _name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'PlayfairDisplay', // Use elegant font
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Member since 2024",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          // Profile Information Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Stats Cards
                  _buildStatsCard(isDarkMode),
                  SizedBox(height: 25),

                  // Profile Information with elegant cards
                  _buildInfoSection("Personal Information", Icons.person_outline, [
                    _buildInfoItem("Full Name", _name, Icons.person, isDarkMode),
                    _buildInfoItem("Phone Number", _phone, Icons.phone_android, isDarkMode),
                    _buildInfoItem("Email Address", _email, Icons.email, isDarkMode),
                    _buildInfoItem("Location", _address, Icons.location_on, isDarkMode),
                  ], isDarkMode),

                  SizedBox(height: 20),

                  // Additional Sections
                  _buildInfoSection("Preferences", Icons.settings, [
                    _buildPreferenceItem("Language", "English", isDarkMode),
                    _buildPreferenceItem("Theme", isDarkMode ? "Dark" : "Light", isDarkMode),
                    _buildPreferenceItem("Notifications", "Enabled", isDarkMode),
                  ], isDarkMode),

                  SizedBox(height: 30),

                  // Action Buttons
                  _buildActionButtons(isDarkMode, theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Color(0xFF2D1B1B), Color(0xFF3A2323)]
              : [Color(0xFFF4E4BC), Color(0xFFE8D9B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("12", "Orders", isDarkMode),
          _buildStatItem("4.8", "Rating", isDarkMode),
          _buildStatItem("2", "Years", isDarkMode),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, bool isDarkMode) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD4AF37),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.brown[700],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> items, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFFD4AF37), size: 20),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.brown[800],
                fontFamily: 'PlayfairDisplay',
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFD4AF37).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Color(0xFFD4AF37)),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white60 : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(String title, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isDarkMode ? Colors.white60 : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode, ThemeData theme) {
    return Column(
      children: [
        // Edit Profile Button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD4AF37), Color(0xFFB8941F)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFD4AF37).withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EnhancedEditProfileScreen(
                    name: _name,
                    email: _email,
                    phone: _phone,
                    address: _address,
                    avatarUrl: _avatarUrl,
                  ),
                ),
              );
              if (updated == true) {
                _loadUserData();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),

        // Additional Action Buttons
        _buildSecondaryButton("Change Password", Icons.lock, isDarkMode),
        SizedBox(height: 10),
        _buildSecondaryButton("Privacy Settings", Icons.security, isDarkMode),
        SizedBox(height: 10),
        _buildSecondaryButton("Logout", Icons.logout, isDarkMode, isLogout: true),
      ],
    );
  }

  Widget _buildSecondaryButton(String text, IconData icon, bool isDarkMode, {bool isLogout = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLogout ? Colors.red.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: TextButton(
        onPressed: () {
          if (isLogout) {
            _showLogoutDialog();
          }
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red : Color(0xFFD4AF37),
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isLogout ? Colors.red : (isDarkMode ? Colors.white : Colors.black87),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Logout", style: TextStyle(color: Color(0xFFD4AF37))),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // Implement logout logic
              Navigator.pop(context);
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ================= Enhanced Edit Profile Screen =================
class EnhancedEditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatarUrl;

  const EnhancedEditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarUrl,
  });

  @override
  State<EnhancedEditProfileScreen> createState() => _EnhancedEditProfileScreenState();
}

class _EnhancedEditProfileScreenState extends State<EnhancedEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late String _avatarUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController(text: widget.address);
    _avatarUrl = widget.avatarUrl;
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser;
      if (user != null) {
        try {
          if (_emailController.text.trim() != user.email) {
            await user.updateEmail(_emailController.text.trim());
          }
          await _firestore.collection('users').doc(user.uid).set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
            'avatarUrl': _avatarUrl,
          }, SetOptions(merge: true));

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text("Profile Updated Successfully!"),
              backgroundColor: Color(0xFFD4AF37),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );

          Navigator.pop(context, true);
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text("Error: ${e.message}"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF0A0A0A) : Color(0xFFF8F5F0),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Color(0xFF1A0F0F), Color(0xFF2D1B1B)]
                        : [Color(0xFFD4AF37), Color(0xFFF4E4BC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'PlayfairDisplay',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Picture Section
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFFD4AF37),
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(_avatarUrl),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFD4AF37),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Implement image picker
                              setState(() {
                                _avatarUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6RjNiUXjrkDtYpezg41p0EL3KXNKIq0fBWA&s";
                              });
                            },
                            icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Form Fields with enhanced styling
                    _buildEnhancedTextField(
                      controller: _nameController,
                      label: "Full Name",
                      icon: Icons.person_outline,
                      validator: (value) => value!.isEmpty ? "Name cannot be empty" : null,
                    ),
                    SizedBox(height: 20),

                    _buildEnhancedTextField(
                      controller: _emailController,
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      validator: (value) => value!.isEmpty ? "Email cannot be empty" : null,
                    ),
                    SizedBox(height: 20),

                    _buildEnhancedTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_android,
                    ),
                    SizedBox(height: 20),

                    _buildEnhancedTextField(
                      controller: _addressController,
                      label: "Address",
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                    ),
                    SizedBox(height: 40),

                    // Save Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD4AF37), Color(0xFFB8941F)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFD4AF37).withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.grey[600],
        ),
        prefixIcon: Container(
          margin: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Color(0xFFD4AF37).withOpacity(0.3), width: 2),
            ),
          ),
          child: Icon(icon, color: Color(0xFFD4AF37)),
        ),
        filled: true,
        fillColor: isDarkMode ? Color(0xFF1A1A1A) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}