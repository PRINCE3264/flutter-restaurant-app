import 'package:flutter/material.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/custom_appbar.dart';

class PaymentLogsScreen extends StatelessWidget {
  const PaymentLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Payment Gateway Logs'),
      drawer: const AdminSidebar(),
      body: const Center(child: Text('Payment Logs Page')),
    );
  }
}
