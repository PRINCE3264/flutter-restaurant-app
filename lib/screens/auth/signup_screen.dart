import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../services/mailer_service.dart';
import 'otp_verification_screen.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wallet_provider.dart';



class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isHovering = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();

      // Check if email already exists
      final existing = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existing.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already registered!')));
        setState(() => _isLoading = false);
        return;
      }

      // Generate 6-digit OTP
      final otp = (100000 + Random().nextInt(899999)).toString();

      // Auto-generate userId (Firestore doc ID)
      final userRef = FirebaseFirestore.instance.collection('users').doc();
      final userId = userRef.id; // ✅ userId

      // Add user to Firestore
      await userRef.set({
        'name': _nameController.text.trim(),
        'email': email,
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text.trim(),
        'role': 'user',
        'isVerified': false,
        'otp': otp,
        'createdAt': Timestamp.now(),
      });

      // Send OTP email
      await MailerService.sendOtpEmail(email, otp);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent to your email!')));

      if (!mounted) return;

      // ✅ Initialize providers with userId
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);

      cartProvider.updateUserId(userId);
      walletProvider.updateUserId(userId);

      // Navigate to OTP verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(
            email: email,
            userId: userId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: BackgroundPainter(),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text('REGISTER',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E88E5))),
                    const SizedBox(height: 5),
                    const Text('Create your account',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
                    const SizedBox(height: 60),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                              controller: _nameController,
                              labelText: 'Full Name',
                              icon: Icons.person_outline,
                              validator: (v) => v!.isEmpty ? 'Enter name' : null),
                          const SizedBox(height: 20),
                          _buildTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v!.isEmpty ? 'Enter email' : null),
                          const SizedBox(height: 20),
                          _buildTextField(
                              controller: _phoneController,
                              labelText: 'Phone Number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) => v!.isEmpty ? 'Enter phone' : null),
                          const SizedBox(height: 20),
                          _buildTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (v) => v!.length < 6 ? 'Min 6 chars' : null),
                          const SizedBox(height: 40),
                          MouseRegion(
                            onEnter: (_) => setState(() => _isHovering = true),
                            onExit: (_) => setState(() => _isHovering = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: _isHovering
                                    ? LinearGradient(colors: [
                                  Colors.blue.shade900,
                                  Colors.blue.shade700
                                ])
                                    : LinearGradient(colors: [
                                  Colors.blue.shade700,
                                  Colors.blue.shade500
                                ]),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3))
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                    color: Colors.white)
                                    : const Text('SIGN UP',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text.rich(
                          TextSpan(
                              text: 'Already have an account? ',
                              style:
                              TextStyle(color: Colors.black54, fontSize: 16),
                              children: [
                                TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                        color: Color(0xFF1A237E),
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Wave Background ----------------
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()..color = const Color(0xFF1A237E);
    var path1 = Path();
    path1.moveTo(size.width * 0.3, 0);
    path1.quadraticBezierTo(
        size.width * 0.9, size.height * 0.2, size.width, size.height * 0.25);
    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, paint1);

    var paint2 = Paint()..color = const Color(0xFF64B5F6);
    var path2 = Path();
    path2.moveTo(size.width * 0.3, 0);
    path2.quadraticBezierTo(
        size.width * 0.5, size.height * 0.2, size.width, size.height * 0.3);
    path2.lineTo(size.width, 0);
    path2.close();
    canvas.drawPath(path2, paint2);

    var paint3 = Paint()..color = const Color(0xFF64B5F6);
    var path3 = Path();
    path3.moveTo(0, size.height * 0.7);
    path3.quadraticBezierTo(
        size.width * 0.5, size.height * 0.95, size.width, size.height * 0.85);
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}






