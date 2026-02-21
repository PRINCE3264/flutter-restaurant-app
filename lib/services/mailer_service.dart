import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailerService {
  // ⚠️ Ensure these are correct and use a 16-character App Password (no spaces).
  static const String _username = 'princekumarvidyarthi4@gmail.com';
  static const String _appPassword = 'siuuqvslwkovlutm';// Example: Replace with your actual App Password

  // ✅ Added userName parameter
  static Future<void> sendOtpEmail(String recipientEmail, String otp, {String userName = "User"}) async {
    // Note: The gmail() function handles the SMTP setup for Gmail.
    final smtpServer = gmail(_username, _appPassword);

    final message = Message()
      ..from = Address(_username, 'Food App')
      ..recipients.add(recipientEmail)
      ..subject = '👋 Hello $userName! Your OTP Code for Food App' // Personalized Subject
      ..html = """
     
      <html>
      <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>OTP Verification</title>
          <style>
              /* --- Full Page Color and Container --- */
              body, table { 
                  margin: 0; 
                  padding: 0; 
                  background-color: #f0f4f8; /* Full Page Color */
                  font-family: Arial, sans-serif; 
              }
              .card {
                  /* Card Hover Effect Simulation (Shadow, Rounding, White BG) */
                  background: #ffffff;
                  border-radius: 12px;
                  box-shadow: 0 8px 16px rgba(0,0,0,0.1); 
                  overflow: hidden;
              }
              .header {
                  background: linear-gradient(90deg, #1E88E5, #64B5F6); /* Blue Gradient */
                  color: white;
                  text-align: center;
                  padding: 25px;
              }
              .otp-box {
                  display: inline-block;
                  padding: 15px 30px;
                  font-size: 36px;
                  color: #D32F2F; /* Red Color for OTP */
                  border: 2px dashed #FF9800; /* Orange Dashed Border */
                  border-radius: 8px;
                  margin: 20px 0;
                  font-weight: bold;
              }
              .button {
                  /* Changed link to be a generic verification message */
                  display: inline-block; 
                  margin-top: 20px; 
                  padding: 12px 25px; 
                  background: #1E88E5; 
                  color: white; 
                  text-decoration: none; 
                  border-radius: 50px;
                  font-weight: bold;
              }
          </style>
      </head>
      <body>
          <table width="100%" cellpadding="0" cellspacing="0" role="presentation">
              <tr>
                  <td align="center" style="padding: 30px 10px;">
                      <!-- Central Card -->
                      <table width="400" cellpadding="0" cellspacing="0" class="card" role="presentation">
                          <tr>
                              <td class="header">
                                  <h1 style="margin: 0; font-size: 24px;">Food App OTP Verification</h1>
                              </td>
                          </tr>
                          <tr>
                              <td style="padding: 30px; text-align: center;">
                                  <!-- Personalized Greeting -->
                                  <p style="font-size: 16px; color: #555;">Hello **$userName**, </p>
                                  <p style="font-size: 18px; color: #333; font-weight: bold;">Use the following Passcode to verify your account:</p>
                                  
                                  <div class="otp-box">
                                      $otp
                                  </div>
                                  
                                  <p style="font-size: 14px; color: #777;">This OTP will expire in 5 minutes. Please enter it on the app screen to complete verification.</p>
                                  
                                  <!-- New Verification Message -->
                                  <div style="margin-top: 20px; font-size: 16px; color: #1E88E5; font-weight: bold;">
                                     Complete Verification on App Screen
                                  </div>
                              </td>
                          </tr>
                          <tr>
                              <td style="background-color: #e3e6e9; text-align: center; padding: 15px; font-size: 12px; color: #999;">
                                  Please do not reply to this email. | Food App Team
                              </td>
                          </tr>
                      </table>
                      <!-- End Central Card -->
                  </td>
              </tr>
          </table>
      </body>
      </html>
      """;

    try {
      final report = await send(message, smtpServer);
      print('✅ OTP sent successfully: $report');
    } on MailerException catch (e) {
      print('❌ MailerException: ${e.message}');
      for (var p in e.problems) {
        print('   > ${p.code}: ${p.msg}');
      }
      // Re-throw the error so your calling function can catch it and display a message.
      throw Exception('Failed to send OTP email: ${e.toString()}');
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw Exception('Failed to send OTP email: ${e.toString()}');
    }
  }
}
