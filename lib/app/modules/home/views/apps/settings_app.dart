import 'package:flutter/material.dart';

class SettingsApp extends StatelessWidget {
  const SettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildSettingCategory('Appearance', [
            _buildSettingItem(
              Icons.wallpaper,
              'Background',
              'Numbat Wallpaper',
            ),
            _buildSettingItem(Icons.palette, 'Theme', 'Ubuntu Dark'),
            _buildSettingItem(Icons.dock, 'Dock', 'Always visible'),
          ]),
          const Divider(height: 32),
          _buildSettingCategory('System', [
            _buildSettingItem(Icons.person, 'User', 'iansurii@local'),
            _buildSettingItem(Icons.computer, 'Device', 'Ubuntu Desktop'),
            _buildSettingItem(Icons.info, 'About', 'Ubuntu 22.04 LTS'),
          ]),
          const Divider(height: 32),
          _buildSettingCategory('Power', [
            _buildSettingItem(
              Icons.power_settings_new,
              'Power Mode',
              'Balanced',
            ),
            _buildSettingItem(Icons.battery_full, 'Battery', '100%'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingCategory(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE95420), // Ubuntu orange
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.grey[700]),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
