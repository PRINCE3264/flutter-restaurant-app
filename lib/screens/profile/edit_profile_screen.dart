import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatarUrl;

  const EditProfileScreen({
    super.key,
    required this.user,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late String _avatarUrl;
  bool _saving = false;

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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await _firestore.collection('users').doc(widget.user.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'avatarUrl': _avatarUrl,
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile updated!")));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed: $e")));
    } finally {
      if (!mounted) return;
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(radius: 60, backgroundImage: NetworkImage(_avatarUrl)),
              const SizedBox(height: 20),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name")),
              const SizedBox(height: 10),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
              const SizedBox(height: 10),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone")),
              const SizedBox(height: 10),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: "Address")),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _saveProfile,
                  child: _saving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save Changes",style:  TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}