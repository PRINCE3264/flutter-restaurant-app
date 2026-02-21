import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wallet_provider.dart';
import '../admin/admin_dashboard.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isHovering = false;
  bool _isLoading = false;

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loginWithFirestore() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .where('password', isEqualTo: _passwordController.text.trim())
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      } else {
        final userDoc = querySnapshot.docs.first;
        final userId = userDoc.id;
        final role = userDoc['role'] ?? 'user';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('role', role);

        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        final walletProvider = Provider.of<WalletProvider>(context, listen: false);
        cartProvider.updateUserId(userId);
        walletProvider.updateUserId(userId);

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
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
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: TextFormField(
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
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: color),
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
                    const Text('LOGIN',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E88E5))),
                    const SizedBox(height: 5),
                    const Text('Welcome back!',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
                    const SizedBox(height: 90),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v!.isEmpty ? 'Enter email' : null),
                          const SizedBox(height: 20),
                          _buildTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (v) =>
                              v!.length < 6 ? 'Min 6 chars' : null),
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
                                onPressed: _isLoading ? null : _loginWithFirestore,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                    color: Colors.white)
                                    : const Text('LOGIN',
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
                            Navigator.pushReplacementNamed(context, '/signup'),
                        child: const Text.rich(
                          TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(color: Colors.black54, fontSize: 16),
                              children: [
                                TextSpan(
                                    text: 'Sign up',
                                    style: TextStyle(
                                        color: Color(0xFF1A237E),
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          icon: FontAwesomeIcons.google,
                          color: const Color(0xFFDB4437),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 12),
                        _buildSocialButton(
                          icon: FontAwesomeIcons.facebookF,
                          color: const Color(0xFF1877F2),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 12),
                        _buildSocialButton(
                          icon: FontAwesomeIcons.twitter,
                          color: const Color(0xFF1DA1F2),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 12),
                        _buildSocialButton(
                          icon: FontAwesomeIcons.github,
                          color: const Color(0xFF000000),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
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

