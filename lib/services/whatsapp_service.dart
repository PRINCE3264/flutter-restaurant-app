// import 'package:url_launcher/url_launcher.dart';
// import '../models/order_model.dart';
//
// class WhatsAppService {
//   // Share order with customer
//   static Future<void> shareOrderWithCustomer(Order order) async {
//     try {
//       final message = _formatCustomerMessage(order);
//       final url = _getWhatsAppUrl(order.customerPhone, message);
//
//       if (await canLaunchUrl(Uri.parse(url))) {
//         await launchUrl(Uri.parse(url));
//       } else {
//         throw 'Could not launch WhatsApp. Please make sure WhatsApp is installed.';
//       }
//     } catch (e) {
//       throw 'Failed to share order with customer: $e';
//     }
//   }
//
//   // Share order with vendor
//   static Future<void> shareOrderWithVendor(Order order) async {
//     try {
//       if (order.vendorPhone == null) {
//         throw 'Vendor phone number not available';
//       }
//
//       final message = _formatVendorMessage(order);
//       final url = _getWhatsAppUrl(order.vendorPhone!, message);
//
//       if (await canLaunchUrl(Uri.parse(url))) {
//         await launchUrl(Uri.parse(url));
//       } else {
//         throw 'Could not launch WhatsApp';
//       }
//     } catch (e) {
//       throw 'Failed to share order with vendor: $e';
//     }
//   }
//
//   // Share order with both customer and vendor
//   static Future<void> shareOrderComplete(Order order) async {
//     try {
//       await shareOrderWithCustomer(order);
//       // Wait a bit before sharing with vendor
//       await Future.delayed(Duration(seconds: 2));
//       await shareOrderWithVendor(order);
//     } catch (e) {
//       throw 'Failed to share order: $e';
//     }
//   }
//
//   // Format customer message
//   static String _formatCustomerMessage(Order order) {
//     String items = '';
//     for (var item in order.items) {
//       items += '• ${item.name} x ${item.quantity} - ₹${item.totalPrice}\n';
//     }
//
//     return '''
// ✅ *ORDER CONFIRMED!* ✅
//
// *Order ID:* ${order.id}
// *Customer:* ${order.customerName}
// *Phone:* ${order.customerPhone}
// *Date:* ${order.formattedDate}
// *Time:* ${order.formattedTime}
//
// *📦 Order Details:*
// $items
// *Subtotal:* ₹${order.subtotal.toStringAsFixed(2)}
// *Tax (18%):* ₹${order.taxAmount.toStringAsFixed(2)}
// ${order.deliveryCharge > 0 ? '*Delivery Charge:* ₹${order.deliveryCharge.toStringAsFixed(2)}' : ''}
// *Total Amount:* ₹${order.totalAmount.toStringAsFixed(2)}
//
// *📍 ${order.orderType == 'delivery' ? 'Delivery Address:' : 'Pickup Information:'}*
// ${order.deliveryAddress}
// ${order.pickupTime != null ? '*Pickup Time:* ${order.pickupTime}' : ''}
//
// *Status:* ${order.status.toUpperCase()}
// *Payment:* ${order.paymentStatus.toUpperCase()}
//
// ${order.specialInstructions != null ? '*Special Instructions:* ${order.specialInstructions}' : ''}
//
// Thank you for your order! We will notify you when it\'s ready. 🎉
// ''';
//   }
//
//   // Format vendor message
//   static String _formatVendorMessage(Order order) {
//     String items = '';
//     for (var item in order.items) {
//       items += '• ${item.name} x ${item.quantity} - ₹${item.totalPrice}\n';
//     }
//
//     return '''
// 🆕 *NEW ORDER RECEIVED!* 🆕
//
// *Order ID:* ${order.id}
// *Customer:* ${order.customerName}
// *Phone:* ${order.customerPhone}
// *Time:* ${order.formattedTime}
//
// *📦 Order Items:*
// $items
// *Total:* ₹${order.totalAmount.toStringAsFixed(2)}
//
// *${order.orderType == 'delivery' ? '🚚 DELIVERY ORDER' : '🏃 PICKUP ORDER'}*
// ${order.deliveryAddress}
// ${order.pickupTime != null ? '*Pickup Time:* ${order.pickupTime}' : ''}
//
// *Status:* ${order.status.toUpperCase()}
// *Payment:* ${order.paymentStatus.toUpperCase()}
//
// ${order.specialInstructions != null ? '*Customer Notes:* ${order.specialInstructions}' : ''}
//
// Please prepare this order! ⏰
// ''';
//   }
//
//   // Get WhatsApp URL
//   static String _getWhatsAppUrl(String phoneNumber, String message) {
//     String cleanedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
//
//     if (!cleanedPhone.startsWith('+')) {
//       cleanedPhone = '+91$cleanedPhone';
//     }
//
//     String encodedMessage = Uri.encodeComponent(message);
//     return 'https://wa.me/$cleanedPhone?text=$encodedMessage';
//   }
//
//   // Support message
//   static Future<void> contactSupport(String supportPhone, String customerName) async {
//     try {
//       final message = '''
// Hello! I need support with my order.
//
// Customer: $customerName
// Order Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}
//
// Please assist me with the following issue:
// ''';
//
//       final url = _getWhatsAppUrl(supportPhone, message);
//
//       if (await canLaunchUrl(Uri.parse(url))) {
//         await launchUrl(Uri.parse(url));
//       } else {
//         throw 'Could not launch WhatsApp';
//       }
//     } catch (e) {
//       throw 'Failed to contact support: $e';
//     }
//   }
// }