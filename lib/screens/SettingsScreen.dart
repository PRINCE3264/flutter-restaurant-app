import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick Settings
          _SettingsSection(title: "Quick Settings", icon: Icons.settings),
          _SettingsItem(
            icon: Icons.wifi,
            title: 'Wi-Fi',
            subtitle: 'Connect to network',
            value: 'Connected',
            onTap: () => _showSnackBar(context, 'Wi-Fi Settings'),
          ),
          _SettingsItem(
            icon: Icons.network_cell,
            title: 'Mobile Network',
            subtitle: 'SIM & Data usage',
            value: '4G',
            onTap: () => _showSnackBar(context, 'Mobile Network Settings'),
          ),
          _SettingsItem(
            icon: Icons.bluetooth,
            title: 'Bluetooth',
            subtitle: 'Connect to devices',
            value: 'On',
            onTap: () => _showSnackBar(context, 'Bluetooth Settings'),
          ),
          _SettingsItem(
            icon: Icons.brightness_6,
            title: 'Brightness',
            subtitle: 'Adjust screen brightness',
            value: 'Auto',
            onTap: () => _showSnackBar(context, 'Brightness Settings'),
          ),
          const SizedBox(height: 16),

          // Display & Sound
          _SettingsSection(title: "Display & Sound", icon: Icons.display_settings),
          _SettingsItem(
            icon: Icons.wallpaper,
            title: 'Wallpaper',
            subtitle: 'Change home & lock screen',
            onTap: () => _showSnackBar(context, 'Wallpaper Settings'),
          ),
          _SettingsItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            value: 'Off',
            onTap: () => _showSnackBar(context, 'Dark Mode Settings'),
          ),
          _SettingsItem(
            icon: Icons.volume_up,
            title: 'Sound & Vibration',
            subtitle: 'Ringtone and vibration settings',
            onTap: () => _showSnackBar(context, 'Sound & Vibration Settings'),
          ),
          _SettingsItem(
            icon: Icons.font_download,
            title: 'Font Size',
            subtitle: 'Adjust text size',
            value: 'Medium',
            onTap: () => _showSnackBar(context, 'Font Size Settings'),
          ),
          const SizedBox(height: 16),

          // Notifications
          _SettingsSection(title: "Notifications", icon: Icons.notifications_active),
          _SettingsItem(
            icon: Icons.notifications,
            title: 'App Notifications',
            subtitle: 'Manage app notifications',
            value: 'On',
            onTap: () => _showSnackBar(context, 'Notification Settings'),
          ),
          _SettingsItem(
            icon: Icons.do_not_disturb,
            title: 'Do Not Disturb',
            subtitle: 'Silence notifications',
            value: 'Off',
            onTap: () => _showSnackBar(context, 'Do Not Disturb Settings'),
          ),
          _SettingsItem(
            icon: Icons.schedule,
            title: 'Notification Schedule',
            subtitle: 'Set quiet hours',
            onTap: () => _showSnackBar(context, 'Notification Schedule'),
          ),
          const SizedBox(height: 16),

          // Security & Privacy
          _SettingsSection(title: "Security & Privacy", icon: Icons.security),
          _SettingsItem(
            icon: Icons.fingerprint,
            title: 'Fingerprint',
            subtitle: 'Add fingerprints',
            value: '2 Added',
            onTap: () => _showSnackBar(context, 'Fingerprint Settings'),
          ),
          _SettingsItem(
            icon: Icons.face,
            title: 'Face Recognition',
            subtitle: 'Add face recognition',
            value: 'Not Set',
            onTap: () => _showSnackBar(context, 'Face Recognition Settings'),
          ),
          _SettingsItem(
            icon: Icons.lock,
            title: 'Screen Lock',
            subtitle: 'Set screen lock type',
            value: 'PIN',
            onTap: () => _showSnackBar(context, 'Screen Lock Settings'),
          ),
          _SettingsItem(
            icon: Icons.lock_outline,
            title: 'App Lock',
            subtitle: 'Lock sensitive applications',
            onTap: () => _showSnackBar(context, 'App Lock Settings'),
          ),
          const SizedBox(height: 16),

          // Apps & Permissions
          _SettingsSection(title: "Apps & Permissions", icon: Icons.apps),
          _SettingsItem(
            icon: Icons.app_settings_alt,
            title: 'App Permissions',
            subtitle: 'Manage app access',
            onTap: () => _showSnackBar(context, 'App Permissions'),
          ),
          _SettingsItem(
            icon: Icons.storage,
            title: 'App Storage',
            subtitle: 'Clear app cache and data',
            onTap: () => _showSnackBar(context, 'App Storage'),
          ),
          _SettingsItem(
            icon: Icons.update,
            title: 'App Updates',
            subtitle: 'Update applications',
            value: '2 Pending',
            onTap: () => _showSnackBar(context, 'App Updates'),
          ),
          const SizedBox(height: 16),

          // System
          _SettingsSection(title: "System", icon: Icons.build),
          _SettingsItem(
            icon: Icons.update,
            title: 'System Update',
            subtitle: 'Check for OS updates',
            value: 'Up to date',
            onTap: () => _showSnackBar(context, 'System Update'),
          ),
          _SettingsItem(
            icon: Icons.backup,
            title: 'Backup & Restore',
            subtitle: 'Backup your data',
            onTap: () => _showSnackBar(context, 'Backup & Restore'),
          ),
          _SettingsItem(
            icon: Icons.restore,
            title: 'Reset Options',
            subtitle: 'Factory reset and more',
            onTap: () => _showResetOptionsDialog(context),
          ),
          _SettingsItem(
            icon: Icons.developer_mode,
            title: 'Developer Options',
            subtitle: 'Advanced settings',
            onTap: () => _showSnackBar(context, 'Developer Options'),
          ),
          const SizedBox(height: 16),

          // Support & About
          _SettingsSection(title: "Support & About", icon: Icons.support_agent),
          _SettingsItem(
            icon: Icons.help_center,
            title: 'Help & Support',
            subtitle: 'Get help and tutorials',
            onTap: () => _showSnackBar(context, 'Help & Support'),
          ),
          _SettingsItem(
            icon: Icons.feedback,
            title: 'Send Feedback',
            subtitle: 'Report issues and suggestions',
            onTap: () => _showSnackBar(context, 'Send Feedback'),
          ),
          _SettingsItem(
            icon: Icons.share,
            title: 'Share App',
            subtitle: 'Share with friends',
            onTap: () => _showSnackBar(context, 'Share App'),
          ),
          _SettingsItem(
            icon: Icons.rate_review,
            title: 'Rate App',
            subtitle: 'Rate us on Play Store',
            onTap: () => _showSnackBar(context, 'Rate App'),
          ),
          _SettingsItem(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            subtitle: 'View our privacy policy',
            onTap: () => _showSnackBar(context, 'Privacy Policy'),
          ),
          _SettingsItem(
            icon: Icons.info,
            title: 'About App',
            subtitle: 'App information and version',
            value: '1.0.0',
            onTap: () => _showAboutAppDialog(context),
          ),
          const SizedBox(height: 16),

          // Actions
          _SettingsSection(title: "Actions", icon: Icons.settings_power),
          _SettingsItem(
            icon: Icons.restart_alt,
            title: 'Restart App',
            subtitle: 'Close and restart application',
            onTap: () => _showSnackBar(context, 'App will restart'),
          ),
          _SettingsItem(
            icon: Icons.exit_to_app,
            title: 'Exit App',
            subtitle: 'Close the application',
            isDestructive: true,
            onTap: () => _showExitDialog(context),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: const Color(0xFF6C63FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showResetOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Options'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose reset option:'),
              SizedBox(height: 16),
              Text('• Reset App Settings - Reset all app preferences'),
              SizedBox(height: 8),
              Text('• Clear Cache - Clear temporary files'),
              SizedBox(height: 8),
              Text('• Clear Data - Erase all app data'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSnackBar(context, 'App settings reset');
              },
              child: const Text('Reset Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSnackBar(context, 'Cache cleared');
              },
              child: const Text('Clear Cache'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info, color: Color(0xFF6C63FF)),
              SizedBox(width: 8),
              Text('About App'),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Restaurant Management App'),
                SizedBox(height: 8),
                Text('Version: 1.0.0'),
                SizedBox(height: 8),
                Text('Build: 2024.01.01'),
                SizedBox(height: 16),
                Text(
                  'A complete restaurant management solution for modern businesses.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the application?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // In a real app, you might use SystemNavigator.pop() to exit
                _showSnackBar(context, 'App exit requested');
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? value;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.value,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.shade50
                : const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : const Color(0xFF6C63FF),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDestructive ? Colors.red.shade600 : Colors.grey.shade600,
          ),
        ),
        trailing: value != null
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value!,
              style: TextStyle(
                color: isDestructive ? Colors.red : Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isDestructive ? Colors.red : Colors.grey.shade500,
            ),
          ],
        )
            : Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDestructive ? Colors.red : Colors.grey.shade500,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SettingsSection({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C63FF),
            ),
          ),
        ],
      ),
    );
  }
}