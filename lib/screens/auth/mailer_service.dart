// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
//
// class MailerService {
//   // ✅ Use your Gmail and the 16-character App Password
//   static const String _username = 'princekumarvidyarthi4@gmail.com';
//   static const String _appPassword = 'wijmuypisejxhjdf'; // example, yours may differ
//
//   static Future<void> sendOtpEmail(String recipientEmail, String otp) async {
//     final smtpServer = gmail(_username, _appPassword);
//
//     final message = Message()
//       ..from = Address(_username, 'Food App')
//       ..recipients.add(recipientEmail)
//       ..subject = '🔹 Your OTP Code 🔹'
//       ..html = """
//       <html>
//         <body style="font-family: Arial; background:#f8f9fa; padding:20px;">
//           <div style="max-width:400px;margin:auto;background:#fff;padding:20px;border-radius:10px;">
//             <h2 style="color:#1E88E5;">Food App OTP Verification</h2>
//             <p>Your OTP code is:</p>
//             <h1 style="color:#D32F2F;">$otp</h1>
//             <p>This code will expire in 5 minutes.</p>
//           </div>
//         </body>
//       </html>
//       """;
//
//     try {
//       final report = await send(message, smtpServer);
//       print('✅ OTP sent successfully: $report');
//     } on MailerException catch (e) {
//       print('❌ MailerException: ${e.message}');
//       for (var p in e.problems) {
//         print('   > ${p.code}: ${p.msg}');
//       }
//     } catch (e) {
//       print('❌ Unexpected error: $e');
//     }
//   }
// }
