// // lib/features/notifications/presentation/screens/notifications_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// //import '../../../services/notification_service.dart';
// import '../../../../models/notification_model.dart';
// import '../services/ notification_service.dart';
//
// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});
//
//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }
//
// class _NotificationsScreenState extends State<NotificationsScreen> {
//   final NotificationService _notificationService = NotificationService();
//   final Color _primaryColor = Color(0xFFD4AF37);
//   final Color _darkBackgroundColor = Color(0xFF1A0F0F);
//   final Color _lightBackgroundColor = Color(0xFFF8F5F0);
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//   }
//
//   Future<void> _initializeNotifications() async {
//     await _notificationService.initialize();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: isDarkMode ? _darkBackgroundColor : _lightBackgroundColor,
//       appBar: AppBar(
//         title: Text(
//           '🔔 Notifications',
//           style: TextStyle(
//             color: isDarkMode ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: isDarkMode ? _darkBackgroundColor : Color(0xFFF4E4BC),
//         elevation: 0,
//         iconTheme: IconThemeData(color: _primaryColor),
//         actions: [
//           StreamBuilder<int>(
//             stream: _notificationService.getUnreadCount(),
//             builder: (context, snapshot) {
//               final unreadCount = snapshot.data ?? 0;
//               if (unreadCount == 0) {
//                 return IconButton(
//                   icon: Icon(Icons.checklist),
//                   onPressed: _showClearAllDialog,
//                   tooltip: 'Clear All',
//                 );
//               }
//               return Badge(
//                 label: Text('$unreadCount'),
//                 child: IconButton(
//                   icon: Icon(Icons.mark_email_read),
//                   onPressed: _markAllAsRead,
//                   tooltip: 'Mark All Read',
//                 ),
//               );
//             },
//           ),
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               switch (value) {
//                 case 'clear_all':
//                   _showClearAllDialog();
//                   break;
//                 case 'settings':
//                   _showNotificationSettings();
//                   break;
//               }
//             },
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'clear_all',
//                 child: Row(
//                   children: [
//                     Icon(Icons.delete_outline, color: Colors.red),
//                     SizedBox(width: 8),
//                     Text('Clear All'),
//                   ],
//                 ),
//               ),
//               PopupMenuItem(
//                 value: 'settings',
//                 child: Row(
//                   children: [
//                     Icon(Icons.settings),
//                     SizedBox(width: 8),
//                     Text('Notification Settings'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Quick Actions
//           _buildQuickActions(isDarkMode),
//
//           // Notifications List
//           Expanded(
//             child: _buildNotificationsList(isDarkMode),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuickActions(bool isDarkMode) {
//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isDarkMode ? Color(0xFF2D1B1B) : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildActionButton(
//             'Mark All Read',
//             Icons.check_circle_outline,
//             _markAllAsRead,
//             isDarkMode,
//           ),
//           _buildActionButton(
//             'Clear All',
//             Icons.delete_outline,
//             _showClearAllDialog,
//             isDarkMode,
//           ),
//           _buildActionButton(
//             'Settings',
//             Icons.settings,
//             _showNotificationSettings,
//             isDarkMode,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButton(String text, IconData icon, VoidCallback onTap, bool isDarkMode) {
//     return Column(
//       children: [
//         IconButton(
//           onPressed: onTap,
//           icon: Icon(icon, color: _primaryColor),
//           style: IconButton.styleFrom(
//             backgroundColor: _primaryColor.withOpacity(0.1),
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 10,
//             color: isDarkMode ? Colors.white70 : Colors.grey[700],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNotificationsList(bool isDarkMode) {
//     return StreamBuilder<List<NotificationModel>>(
//       stream: _notificationService.getUserNotifications(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(color: _primaryColor),
//           );
//         }
//
//         if (snapshot.hasError) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline, color: Colors.red, size: 50),
//                 SizedBox(height: 16),
//                 Text(
//                   'Error loading notifications',
//                   style: TextStyle(
//                     color: isDarkMode ? Colors.white70 : Colors.grey[700],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.notifications_off, color: _primaryColor, size: 80),
//                 SizedBox(height: 16),
//                 Text(
//                   'No notifications yet',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: isDarkMode ? Colors.white70 : Colors.grey[700],
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Your notifications will appear here',
//                   style: TextStyle(
//                     color: isDarkMode ? Colors.white54 : Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         final notifications = snapshot.data!;
//
//         return ListView.builder(
//           padding: EdgeInsets.all(8),
//           itemCount: notifications.length,
//           itemBuilder: (context, index) {
//             return _buildNotificationCard(notifications[index], isDarkMode);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildNotificationCard(NotificationModel notification, bool isDarkMode) {
//     return Dismissible(
//       key: Key(notification.id),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         color: Colors.red,
//         alignment: Alignment.centerRight,
//         padding: EdgeInsets.only(right: 20),
//         child: Icon(Icons.delete, color: Colors.white),
//       ),
//       onDismissed: (direction) {
//         _notificationService.deleteNotification(notification.id);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Notification deleted'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       },
//       child: Card(
//         margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         color: isDarkMode ? Color(0xFF2D1B1B) : Colors.white,
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: ListTile(
//           contentPadding: EdgeInsets.all(16),
//           leading: _buildNotificationIcon(notification),
//           title: Text(
//             notification.title,
//             style: TextStyle(
//               fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
//               color: isDarkMode ? Colors.white : Colors.black,
//               fontSize: 14,
//             ),
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 4),
//               Text(
//                 notification.body,
//                 style: TextStyle(
//                   color: isDarkMode ? Colors.white70 : Colors.grey[700],
//                   fontSize: 12,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               SizedBox(height: 4),
//               Text(
//                 DateFormat('MMM dd, yyyy • hh:mm a').format(notification.createdAt),
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: isDarkMode ? Colors.white54 : Colors.grey[500],
//                 ),
//               ),
//             ],
//           ),
//           trailing: notification.isRead
//               ? null
//               : Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: _primaryColor,
//               shape: BoxShape.circle,
//             ),
//           ),
//           onTap: () {
//             _handleNotificationTap(notification);
//             if (!notification.isRead) {
//               _notificationService.markAsRead(notification.id);
//             }
//           },
//           onLongPress: () => _showNotificationOptions(notification),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNotificationIcon(NotificationModel notification) {
//     Color iconColor;
//     IconData icon;
//
//     switch (notification.type) {
//       case 'order':
//         iconColor = Colors.blue;
//         icon = Icons.shopping_bag;
//         break;
//       case 'offer':
//         iconColor = Colors.green;
//         icon = Icons.local_offer;
//         break;
//       case 'system':
//         iconColor = Colors.orange;
//         icon = Icons.info;
//         break;
//       default:
//         iconColor = _primaryColor;
//         icon = Icons.notifications;
//     }
//
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: iconColor.withOpacity(0.1),
//         shape: BoxShape.circle,
//         border: Border.all(color: iconColor),
//       ),
//       child: Icon(icon, color: iconColor, size: 20),
//     );
//   }
//
//   void _handleNotificationTap(NotificationModel notification) {
//     switch (notification.type) {
//       case 'order':
//         if (notification.orderId != null) {
//           // Navigate to order details
//           Navigator.pushNamed(
//             context,
//             '/order-details',
//             arguments: notification.orderId,
//           );
//         }
//         break;
//       case 'offer':
//       // Navigate to offers screen
//         Navigator.pushNamed(context, '/offers');
//         break;
//       default:
//       // Show notification details
//         _showNotificationDetails(notification);
//     }
//   }
//
//   void _showNotificationDetails(NotificationModel notification) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(notification.title),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(notification.body),
//             SizedBox(height: 16),
//             Text(
//               'Type: ${notification.type}',
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//             Text(
//               'Date: ${DateFormat('MMM dd, yyyy • hh:mm a').format(notification.createdAt)}',
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showNotificationOptions(NotificationModel notification) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.visibility_off, color: _primaryColor),
//               title: Text('Mark as Read'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _notificationService.markAsRead(notification.id);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.delete, color: Colors.red),
//               title: Text('Delete'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _notificationService.deleteNotification(notification.id);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Notification deleted'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _markAllAsRead() {
//     _notificationService.markAllAsRead();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('All notifications marked as read'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//   void _showClearAllDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Clear All Notifications'),
//         content: Text('Are you sure you want to delete all notifications? This action cannot be undone.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _notificationService.clearAllNotifications();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('All notifications cleared'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             },
//             child: Text('Clear All', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showNotificationSettings() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Notification Settings'),
//         content: Container(
//           width: double.maxFinite,
//           child: ListView(
//             shrinkWrap: true,
//             children: [
//               _buildSettingSwitch('Order Notifications', true),
//               _buildSettingSwitch('Offer Notifications', true),
//               _buildSettingSwitch('Promotional Notifications', false),
//               _buildSettingSwitch('Sound', true),
//               _buildSettingSwitch('Vibration', true),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSettingSwitch(String title, bool value) {
//     return SwitchListTile(
//       title: Text(title),
//       value: value,
//       onChanged: (newValue) {
//         // Save setting to preferences
//       },
//     );
//   }
// }


// lib/features/notifications/presentation/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../services/notification_service.dart'; // FIXED IMPORT PATH
import '../../../../models/notification_model.dart';
// import '../services/ notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationService _notificationService;
  final Color _primaryColor = Color(0xFFD4AF37);
  final Color _darkBackgroundColor = Color(0xFF1A0F0F);
  final Color _lightBackgroundColor = Color(0xFFF8F5F0);

  // @override
  // void initState() {
  //   super.initState();
  //   _notificationService = Provider.of<NotificationService>(context, listen: false);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notificationService = context.read<NotificationService>();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? _darkBackgroundColor : _lightBackgroundColor,
      appBar: AppBar(
        title: Text(
          '🔔 Notifications',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: isDarkMode ? _darkBackgroundColor : Color(0xFFF4E4BC),
        elevation: 0,
        iconTheme: IconThemeData(color: _primaryColor),
        actions: [
          StreamBuilder<int>(
            stream: _notificationService.getUnreadCount(),
            builder: (context, snapshot) {
              final unreadCount = snapshot.data ?? 0;
              if (unreadCount == 0) {
                return IconButton(
                  icon: Icon(Icons.checklist),
                  onPressed: _showClearAllDialog,
                  tooltip: 'Clear All',
                );
              }
              return Badge(
                label: Text('$unreadCount'),
                child: IconButton(
                  icon: Icon(Icons.mark_email_read),
                  onPressed: _markAllAsRead,
                  tooltip: 'Mark All Read',
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'clear_all':
                  _showClearAllDialog();
                  break;
                case 'settings':
                  _showNotificationSettings();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear All'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Notification Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions
          _buildQuickActions(isDarkMode),

          // Notifications List
          Expanded(
            child: _buildNotificationsList(isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2D1B1B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            'Mark All Read',
            Icons.check_circle_outline,
            _markAllAsRead,
            isDarkMode,
          ),
          _buildActionButton(
            'Clear All',
            Icons.delete_outline,
            _showClearAllDialog,
            isDarkMode,
          ),
          _buildActionButton(
            'Settings',
            Icons.settings,
            _showNotificationSettings,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onTap, bool isDarkMode) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: _primaryColor),
          style: IconButton.styleFrom(
            backgroundColor: _primaryColor.withOpacity(0.1),
          ),
        ),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: isDarkMode ? Colors.white70 : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsList(bool isDarkMode) {
    return StreamBuilder<List<NotificationModel>>(
      stream: _notificationService.getUserNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: _primaryColor),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 16),
                Text(
                  'Error loading notifications',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please check your connection',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off, color: _primaryColor, size: 80),
                SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your notifications will appear here',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _testNotification,
                  icon: Icon(Icons.notification_add),
                  label: Text('Test Notification'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        final notifications = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationCard(notifications[index], isDarkMode);
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, bool isDarkMode) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(notification);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        color: isDarkMode ? Color(0xFF2D1B1B) : Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: _buildNotificationIcon(notification),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                notification.body,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey[700],
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                _formatDate(notification.createdAt),
                style: TextStyle(
                  fontSize: 10,
                  color: isDarkMode ? Colors.white54 : Colors.grey[500],
                ),
              ),
            ],
          ),
          trailing: notification.isRead
              ? null
              : Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          onTap: () {
            _handleNotificationTap(notification);
            if (!notification.isRead) {
              _notificationService.markAsRead(notification.id);
            }
          },
          onLongPress: () => _showNotificationOptions(notification),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationModel notification) {
    Color iconColor;
    IconData icon;

    switch (notification.type) {
      case 'order':
        iconColor = Colors.blue;
        icon = Icons.shopping_bag;
        break;
      case 'offer':
        iconColor = Colors.green;
        icon = Icons.local_offer;
        break;
      case 'payment':
        iconColor = Colors.green;
        icon = Icons.payment;
        break;
      case 'system':
        iconColor = Colors.orange;
        icon = Icons.info;
        break;
      default:
        iconColor = _primaryColor;
        icon = Icons.notifications;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: iconColor),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  void _handleNotificationTap(NotificationModel notification) {
    switch (notification.type) {
      case 'order':
        if (notification.orderId != null) {
          // Navigate to order details
          _showSnackBar('Opening order details...');
          // Navigator.pushNamed(
          //   context,
          //   '/order-details',
          //   arguments: notification.orderId,
          // );
        }
        break;
      case 'offer':
        _showSnackBar('Opening offers...');
        // Navigator.pushNamed(context, '/offers');
        break;
      default:
        _showNotificationDetails(notification);
    }
  }

  void _showNotificationDetails(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.body,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 8),
              Text(
                'Type: ${notification.type.toUpperCase()}',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                'Date: ${DateFormat('MMM dd, yyyy • hh:mm a').format(notification.createdAt)}',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              if (notification.orderId != null) ...[
                SizedBox(height: 4),
                Text(
                  'Order ID: ${notification.orderId}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ]
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if (!notification.isRead)
            TextButton(
              onPressed: () {
                _notificationService.markAsRead(notification.id);
                Navigator.pop(context);
                _showSnackBar('Marked as read');
              },
              child: Text('Mark Read'),
            ),
        ],
      ),
    );
  }

  void _showNotificationOptions(NotificationModel notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!notification.isRead)
              ListTile(
                leading: Icon(Icons.visibility_off, color: _primaryColor),
                title: Text('Mark as Read'),
                onTap: () {
                  Navigator.pop(context);
                  _notificationService.markAsRead(notification.id);
                  _showSnackBar('Marked as read');
                },
              ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(notification);
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.blue),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _shareNotification(notification);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(NotificationModel notification) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Notification'),
        content: Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == true) {
      _notificationService.deleteNotification(notification.id);
      _showSnackBar('Notification deleted');
      return true;
    }
    return false;
  }

  void _shareNotification(NotificationModel notification) {
    // Implement share functionality
    _showSnackBar('Share feature coming soon!');
  }

  void _markAllAsRead() {
    _notificationService.markAllAsRead();
    _showSnackBar('All notifications marked as read');
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Notifications'),
        content: Text('Are you sure you want to delete all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _notificationService.clearAllNotifications();
              _showSnackBar('All notifications cleared');
            },
            child: Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification Settings'),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildSettingSwitch('Order Notifications', true),
              _buildSettingSwitch('Offer Notifications', true),
              _buildSettingSwitch('Payment Notifications', true),
              _buildSettingSwitch('Promotional Notifications', false),
              _buildSettingSwitch('Sound', true),
              _buildSettingSwitch('Vibration', true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Settings saved');
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        // Save setting to preferences
        _showSnackBar('$title: ${newValue ? 'ON' : 'OFF'}');
      },
    );
  }

  void _testNotification() {
    _notificationService.showSimpleNotification(
      'Test Notification ✅',
      'This is a test notification from your app at ${DateTime.now().toString()}',
    );
    _showSnackBar('Test notification sent!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}