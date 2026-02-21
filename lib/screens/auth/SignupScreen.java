//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
//class SignupScreen extends StatefulWidget {
//  const SignupScreen({super.key});
//
//  @override
//  State<SignupScreen> createState() => _SignupScreenState();
//}
//
//class _SignupScreenState extends State<SignupScreen> {
//  final _formKey = GlobalKey<FormState>();
//
//  final TextEditingController _nameController = TextEditingController();
//  final TextEditingController _emailController = TextEditingController();
//  final TextEditingController _phoneController = TextEditingController();
//  final TextEditingController _passwordController = TextEditingController();
//  final TextEditingController _confirmPasswordController =
//      TextEditingController();
//
//  bool _isHovering = false;
//  bool _isLoading = false;
//
//  @override
//  void dispose() {
//    _nameController.dispose();
//    _emailController.dispose();
//    _phoneController.dispose();
//    _passwordController.dispose();
//    _confirmPasswordController.dispose();
//    super.dispose();
//  }
//
//  // --- FIRESTORE SIGNUP FUNCTION ---
//  Future<void> _signupWithFirestore() async {
//    if (!_formKey.currentState!.validate()) return;
//
//    setState(() => _isLoading = true);
//
//    try {
//      // Check if email already exists
//      final check = await FirebaseFirestore.instance
//          .collection('users')
//          .where('email', isEqualTo: _emailController.text.trim())
//          .get();
//
//      if (check.docs.isNotEmpty) {
//        ScaffoldMessenger.of(context).showSnackBar(
//          const SnackBar(content: Text('Email already registered!')),
//        );
//        setState(() => _isLoading = false);
//        return;
//      }
//
//      // Add user to Firestore
//      await FirebaseFirestore.instance.collection('users').add({
//        'name': _nameController.text.trim(),
//        'email': _emailController.text.trim(),
//        'phone': _phoneController.text.trim(),
//        'password': _passwordController.text.trim(),
//        'role': 'user',
//        'createdAt': Timestamp.now(),
//      });
//
//      ScaffoldMessenger.of(context).showSnackBar(
//        const SnackBar(content: Text('Account created successfully!')),
//      );
//
//      if (mounted) {
//        Navigator.pushReplacementNamed(context, '/login');
//      }
//    } catch (e) {
//      ScaffoldMessenger.of(context).showSnackBar(
//        SnackBar(content: Text('Error: $e')),
//      );
//    } finally {
//      if (mounted) {
//        setState(() => _isLoading = false);
//      }
//    }
//  }
//
//  // --- CUSTOM TEXT FIELD WIDGET ---
//  Widget _buildTextField({
//    required TextEditingController controller,
//    required String labelText,
//    required IconData icon,
//    bool obscureText = false,
//    TextInputType keyboardType = TextInputType.text,
//    String? Function(String?)? validator,
//  }) {
//    return TextFormField(
//      controller: controller,
//      obscureText: obscureText,
//      keyboardType: keyboardType,
//      decoration: InputDecoration(
//        labelText: labelText,
//        labelStyle: const TextStyle(color: Colors.blueGrey),
//        prefixIcon: Icon(icon, color: const Color(0xFF1E88E5)),
//        contentPadding:
//            const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
//        enabledBorder: UnderlineInputBorder(
//          borderSide: BorderSide(color: Colors.blueGrey.shade200, width: 1.5),
//        ),
//        focusedBorder: const UnderlineInputBorder(
//          borderSide: BorderSide(color: Color(0xFF1E88E5), width: 2.5),
//        ),
//        errorBorder: const UnderlineInputBorder(
//          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
//        ),
//        focusedErrorBorder: const UnderlineInputBorder(
//          borderSide: BorderSide(color: Colors.redAccent, width: 2.5),
//        ),
//      ),
//      validator: validator,
//    );
//  }
//
//  // --- SOCIAL BUTTON (OPTIONAL) ---
//  Widget _buildSocialButton({
//    required IconData icon,
//    required Color color,
//    required VoidCallback onPressed,
//  }) {
//    return Container(
//      width: 55,
//      height: 55,
//      decoration: BoxDecoration(
//        color: Colors.white,
//        shape: BoxShape.circle,
//        boxShadow: [
//          BoxShadow(
//            color: Colors.grey.withOpacity(0.3),
//            blurRadius: 6,
//            offset: const Offset(0, 4),
//          ),
//        ],
//      ),
//      child: IconButton(
//        onPressed: onPressed,
//        icon: Icon(icon, size: 28, color: color),
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: const Color(0xFFE0F7FA),
//      body: SingleChildScrollView(
//        child: Stack(
//          children: [
//            CustomPaint(
//              size: Size(MediaQuery.of(context).size.width,
//                  MediaQuery.of(context).size.height),
//              painter: BackgroundPainter(),
//            ),
//            SafeArea(
//              child: Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: [
//                    const SizedBox(height: 80),
//                    const Text(
//                      'SIGN UP',
//                      style: TextStyle(
//                        fontSize: 32,
//                        fontWeight: FontWeight.bold,
//                        color: Color(0xFF1E88E5),
//                      ),
//                    ),
//                    const SizedBox(height: 8),
//                    const Text(
//                      'Create your account',
//                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
//                    ),
//                    const SizedBox(height: 40),
//
//                    // --- FORM START ---
//                    Form(
//                      key: _formKey,
//                      child: Column(
//                        children: [
//                          _buildTextField(
//                            controller: _nameController,
//                            labelText: 'Full Name',
//                            icon: Icons.person_outline,
//                            validator: (v) => v!.isEmpty
//                                ? 'Please enter your full name'
//                                : null,
//                          ),
//                          const SizedBox(height: 25),
//                          _buildTextField(
//                            controller: _emailController,
//                            labelText: 'Email',
//                            icon: Icons.email_outlined,
//                            keyboardType: TextInputType.emailAddress,
//                            validator: (v) => v!.isEmpty
//                                ? 'Please enter your email'
//                                : null,
//                          ),
//                          const SizedBox(height: 25),
//                          _buildTextField(
//                            controller: _phoneController,
//                            labelText: 'Phone Number',
//                            icon: Icons.phone_outlined,
//                            keyboardType: TextInputType.phone,
//                            validator: (v) => v!.isEmpty
//                                ? 'Please enter your phone number'
//                                : null,
//                          ),
//                          const SizedBox(height: 25),
//                          _buildTextField(
//                            controller: _passwordController,
//                            labelText: 'Password',
//                            icon: Icons.lock_outline,
//                            obscureText: true,
//                            validator: (v) => v!.length < 6
//                                ? 'Password must be at least 6 characters'
//                                : null,
//                          ),
//                          const SizedBox(height: 25),
//                          _buildTextField(
//                            controller: _confirmPasswordController,
//                            labelText: 'Confirm Password',
//                            icon: Icons.lock_reset_outlined,
//                            obscureText: true,
//                            validator: (v) =>
//                                v != _passwordController.text
//                                    ? 'Passwords do not match'
//                                    : null,
//                          ),
//                          const SizedBox(height: 40),
//
//                          // --- SIGNUP BUTTON ---
//                          MouseRegion(
//                            onEnter: (_) => setState(() => _isHovering = true),
//                            onExit: (_) => setState(() => _isHovering = false),
//                            child: AnimatedContainer(
//                              duration: const Duration(milliseconds: 200),
//                              curve: Curves.easeIn,
//                              width: double.infinity,
//                              decoration: BoxDecoration(
//                                color: _isHovering
//                                    ? const Color(0xFF0D47A1)
//                                    : const Color(0xFF1E88E5),
//                                borderRadius: BorderRadius.circular(50.0),
//                              ),
//                              child: ElevatedButton(
//                                onPressed:
//                                    _isLoading ? null : _signupWithFirestore,
//                                style: ElevatedButton.styleFrom(
//                                  backgroundColor: Colors.transparent,
//                                  shadowColor: Colors.transparent,
//                                  padding:
//                                      const EdgeInsets.symmetric(vertical: 18),
//                                  shape: RoundedRectangleBorder(
//                                    borderRadius: BorderRadius.circular(50),
//                                  ),
//                                ),
//                                child: _isLoading
//                                    ? const CircularProgressIndicator(
//                                        color: Colors.white)
//                                    : const Text(
//                                        'SIGN UP',
//                                        style: TextStyle(
//                                          color: Colors.white,
//                                          fontSize: 18,
//                                          fontWeight: FontWeight.bold,
//                                        ),
//                                      ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                    const SizedBox(height: 20),
//
//                    // --- LOGIN REDIRECT ---
//                    Center(
//                      child: TextButton(
//                        onPressed: () =>
//                            Navigator.pushReplacementNamed(context, '/login'),
//                        child: const Text.rich(
//                          TextSpan(
//                            text: 'Already have an account? ',
//                            style:
//                                TextStyle(color: Colors.black54, fontSize: 16),
//                            children: [
//                              TextSpan(
//                                text: 'Login',
//                                style: TextStyle(
//                                  color: Color(0xFF1A237E),
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//
//                    const SizedBox(height: 15),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        _buildSocialButton(
//                          icon: FontAwesomeIcons.google,
//                          color: const Color(0xFFDB4437),
//                          onPressed: () {},
//                        ),
//                        const SizedBox(width: 15),
//                        _buildSocialButton(
//                          icon: FontAwesomeIcons.facebookF,
//                          color: const Color(0xFF1877F2),
//                          onPressed: () {},
//                        ),
//                        const SizedBox(width: 15),
//                        _buildSocialButton(
//                          icon: FontAwesomeIcons.twitter,
//                          color: const Color(0xFF1DA1F2),
//                          onPressed: () {},
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//// ✅ Same wave background as login screen
//class BackgroundPainter extends CustomPainter {
//  @override
//  void paint(Canvas canvas, Size size) {
//    var paint1 = Paint()..color = const Color(0xFF1A237E);
//    var path1 = Path();
//    path1.moveTo(size.width * 0.3, 0);
//    path1.quadraticBezierTo(
//        size.width * 0.9, size.height * 0.2, size.width, size.height * 0.25);
//    path1.lineTo(size.width, 0);
//    path1.close();
//    canvas.drawPath(path1, paint1);
//
//    var paint2 = Paint()..color = const Color(0xFF64B5F6);
//    var path2 = Path();
//    path2.moveTo(size.width * 0.3, 0);
//    path2.quadraticBezierTo(
//        size.width * 0.5, size.height * 0.20, size.width, size.height * 0.3);
//    path2.lineTo(size.width, 0);
//    path2.close();
//    canvas.drawPath(path2, paint2);
//
//    var paint3 = Paint()..color = const Color(0xFF64B5F6);
//    var path3 = Path();
//    path3.moveTo(0, size.height * 0.7);
//    path3.quadraticBezierTo(
//        size.width * 0.5, size.height * 0.95, size.width, size.height * 0.85);
//    path3.lineTo(size.width, size.height);
//    path3.lineTo(0, size.height);
//    path3.close();
//    canvas.drawPath(path3, paint3);
//  }
//
//  @override
//  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
//}
