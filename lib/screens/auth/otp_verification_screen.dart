// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class OTPVerificationScreen extends StatefulWidget {
//   final String email;
//   const OTPVerificationScreen({super.key, required this.email});
//
//   @override
//   State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
// }
//
// class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final List<TextEditingController> _otpControllers =
//   List.generate(6, (index) => TextEditingController());
//
//   bool _isHovering = false;
//
//   @override
//   void dispose() {
//     for (var controller in _otpControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   // Verify OTP with Firestore
//   void _verifyOTP() async {
//     if (_formKey.currentState!.validate()) {
//       String enteredOtp = _otpControllers.map((c) => c.text).join();
//
//       try {
//         final userDoc = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(widget.email)
//             .get();
//
//         if (userDoc.exists) {
//           String correctOtp = userDoc['otp'];
//           if (enteredOtp == correctOtp) {
//             // Mark user as verified
//             await FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(widget.email)
//                 .update({'isVerified': true, 'otp': ''});
//
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('OTP Verified Successfully!')),
//             );
//
//             // Navigate to login or dashboard
//             Navigator.pushNamed(context, '/login');
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Incorrect OTP, try again!')),
//             );
//           }
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE0F7FA),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             CustomPaint(
//               size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
//               painter: BackgroundPainter(),
//             ),
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 120),
//                     const Text(
//                       'OTP VERIFICATION',
//                       style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1E88E5)),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Enter the 6-digit code sent to ${widget.email}',
//                       style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
//                     ),
//                     const SizedBox(height: 40),
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: List.generate(6, (index) {
//                               return SizedBox(
//                                 width: 50,
//                                 child: _buildOtpTextField(
//                                     controller: _otpControllers[index],
//                                     isLast: index == 5),
//                               );
//                             }),
//                           ),
//                           const SizedBox(height: 50),
//                           MouseRegion(
//                             onEnter: (_) => setState(() => _isHovering = true),
//                             onExit: (_) => setState(() => _isHovering = false),
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 200),
//                               curve: Curves.easeIn,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: _isHovering
//                                     ? const Color(0xFF0D47A1)
//                                     : const Color(0xFF1E88E5),
//                                 borderRadius: BorderRadius.circular(50.0),
//                               ),
//                               child: ElevatedButton(
//                                 onPressed: _verifyOTP,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.transparent,
//                                   shadowColor: Colors.transparent,
//                                   padding: const EdgeInsets.symmetric(vertical: 18),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   'VERIFY',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Center(
//                       child: TextButton(
//                         onPressed: () {
//                           // TODO: Implement resend OTP
//                         },
//                         child: const Text.rich(
//                           TextSpan(
//                             text: 'Didn\'t receive the code? ',
//                             style: TextStyle(color: Colors.black54, fontSize: 16),
//                             children: [
//                               TextSpan(
//                                   text: 'Resend',
//                                   style: TextStyle(
//                                       color: Color(0xFF1A237E),
//                                       fontWeight: FontWeight.bold)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOtpTextField(
//       {required TextEditingController controller, required bool isLast}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 1,
//         style: const TextStyle(
//             fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
//         decoration: const InputDecoration(
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           border: InputBorder.none,
//           counterText: '',
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty) {
//             if (!isLast) {
//               FocusScope.of(context).nextFocus();
//             } else {
//               FocusScope.of(context).unfocus();
//             }
//           }
//         },
//         validator: (value) => value == null || value.isEmpty ? '' : null,
//       ),
//     );
//   }
// }
//
// // Background painter (same as before)
// class BackgroundPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint1 = Paint()..color = const Color(0xFF1A237E);
//     var path1 = Path();
//     path1.moveTo(size.width * 0.4, 0);
//     path1.quadraticBezierTo(
//         size.width * 0.9, size.height * 0.2, size.width, size.height * 0.35);
//     path1.lineTo(size.width, 0);
//     path1.close();
//     canvas.drawPath(path1, paint1);
//
//     var paint2 = Paint()..color = const Color(0xFF64B5F6);
//     var path2 = Path();
//     path2.moveTo(size.width * 0.3, 0);
//     path2.quadraticBezierTo(
//         size.width * 0.8, size.height * 0.15, size.width, size.height * 0.3);
//     path2.lineTo(size.width, 0);
//     path2.close();
//     canvas.drawPath(path2, paint2);
//
//     var paint3 = Paint()..color = const Color(0xFF1A237E);
//     var path3 = Path();
//     path3.moveTo(0, size.height * 0.7);
//     path3.quadraticBezierTo(
//         size.width * 0.3, size.height * 0.95, size.width * 0.7, size.height * 0.85);
//     path3.quadraticBezierTo(
//         size.width * 0.9, size.height * 0.8, size.width, size.height * 0.9);
//     path3.lineTo(size.width, size.height);
//     path3.lineTo(0, size.height);
//     path3.close();
//     canvas.drawPath(path3, paint3);
//
//     var paint4 = Paint()..color = const Color(0xFF64B5F6);
//     var path4 = Path();
//     path4.moveTo(0, size.height * 0.65);
//     path4.quadraticBezierTo(
//         size.width * 0.25, size.height * 0.9, size.width * 0.6, size.height * 0.8);
//     path4.quadraticBezierTo(
//         size.width * 0.8, size.height * 0.75, size.width, size.height * 0.8);
//     path4.lineTo(size.width, size.height);
//     path4.lineTo(0, size.height);
//     path4.close();
//     canvas.drawPath(path4, paint4);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
//
//


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String userId; // ✅ Add userId here
  const OTPVerificationScreen({super.key, required this.email, required this.userId});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers =
  List.generate(6, (index) => TextEditingController());

  bool _isHovering = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Verify OTP with Firestore using userId
  void _verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      String enteredOtp = _otpControllers.map((c) => c.text).join();

      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId) // ✅ use userId
            .get();

        if (userDoc.exists) {
          String correctOtp = userDoc['otp'];
          if (enteredOtp == correctOtp) {
            // Mark user as verified
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .update({'isVerified': true, 'otp': ''});

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP Verified Successfully!')),
            );

            // Navigate to login or dashboard
            Navigator.pushNamed(context, '/login');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Incorrect OTP, try again!')),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120),
                    const Text(
                      'OTP VERIFICATION',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E88E5)),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Enter the 6-digit code sent to ${widget.email}',
                      style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: 50,
                                child: _buildOtpTextField(
                                    controller: _otpControllers[index],
                                    isLast: index == 5),
                              );
                            }),
                          ),
                          const SizedBox(height: 50),
                          MouseRegion(
                            onEnter: (_) => setState(() => _isHovering = true),
                            onExit: (_) => setState(() => _isHovering = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: _isHovering
                                    ? const Color(0xFF0D47A1)
                                    : const Color(0xFF1E88E5),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: ElevatedButton(
                                onPressed: _verifyOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: const Text(
                                  'VERIFY',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement resend OTP
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: 'Didn\'t receive the code? ',
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                            children: [
                              TextSpan(
                                  text: 'Resend',
                                  style: TextStyle(
                                      color: Color(0xFF1A237E),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
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

  Widget _buildOtpTextField(
      {required TextEditingController controller, required bool isLast}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          counterText: '',
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (!isLast) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          }
        },
        validator: (value) => value == null || value.isEmpty ? '' : null,
      ),
    );
  }
}

// Background painter (same as before)
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()..color = const Color(0xFF1A237E);
    var path1 = Path();
    path1.moveTo(size.width * 0.4, 0);
    path1.quadraticBezierTo(
        size.width * 0.9, size.height * 0.2, size.width, size.height * 0.35);
    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, paint1);

    var paint2 = Paint()..color = const Color(0xFF64B5F6);
    var path2 = Path();
    path2.moveTo(size.width * 0.3, 0);
    path2.quadraticBezierTo(
        size.width * 0.8, size.height * 0.15, size.width, size.height * 0.3);
    path2.lineTo(size.width, 0);
    path2.close();
    canvas.drawPath(path2, paint2);

    var paint3 = Paint()..color = const Color(0xFF1A237E);
    var path3 = Path();
    path3.moveTo(0, size.height * 0.7);
    path3.quadraticBezierTo(
        size.width * 0.3, size.height * 0.95, size.width * 0.7, size.height * 0.85);
    path3.quadraticBezierTo(
        size.width * 0.9, size.height * 0.8, size.width, size.height * 0.9);
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();
    canvas.drawPath(path3, paint3);

    var paint4 = Paint()..color = const Color(0xFF64B5F6);
    var path4 = Path();
    path4.moveTo(0, size.height * 0.65);
    path4.quadraticBezierTo(
        size.width * 0.25, size.height * 0.9, size.width * 0.6, size.height * 0.8);
    path4.quadraticBezierTo(
        size.width * 0.8, size.height * 0.75, size.width, size.height * 0.8);
    path4.lineTo(size.width, size.height);
    path4.lineTo(0, size.height);
    path4.close();
    canvas.drawPath(path4, paint4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
