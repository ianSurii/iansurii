import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SystemTrayMenu extends StatefulWidget {
  const SystemTrayMenu({super.key});

  @override
  State<SystemTrayMenu> createState() => _SystemTrayMenuState();
}

class _SystemTrayMenuState extends State<SystemTrayMenu> {
  double _volume = 70.0;
  double _brightness = 80.0;
  bool _wifiEnabled = true;
  bool _bluetoothEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFE95420),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'iansurii',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'iansurii@local',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.2, end: 0),

            // Quick Settings
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connectivity toggles
                  Row(
                    children: [
                      Expanded(
                        child: _buildToggleButton(
                          icon: Icons.wifi,
                          label: 'Wi-Fi',
                          isActive: _wifiEnabled,
                          onTap: () =>
                              setState(() => _wifiEnabled = !_wifiEnabled),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildToggleButton(
                          icon: Icons.bluetooth,
                          label: 'Bluetooth',
                          isActive: _bluetoothEnabled,
                          onTap: () => setState(
                            () => _bluetoothEnabled = !_bluetoothEnabled,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms, duration: 200.ms),

                  const SizedBox(height: 16),

                  // Volume Control
                  _buildSliderControl(
                    icon: Icons.volume_up,
                    label: 'Volume',
                    value: _volume,
                    onChanged: (value) => setState(() => _volume = value),
                  ).animate().fadeIn(delay: 150.ms, duration: 200.ms),

                  const SizedBox(height: 16),

                  // Brightness Control
                  _buildSliderControl(
                    icon: Icons.brightness_6,
                    label: 'Brightness',
                    value: _brightness,
                    onChanged: (value) => setState(() => _brightness = value),
                  ).animate().fadeIn(delay: 200.ms, duration: 200.ms),

                  const SizedBox(height: 16),

                  // Divider
                  Divider(color: Colors.white.withOpacity(0.1)),

                  const SizedBox(height: 8),

                  // Power Options
                  Column(
                    children: [
                      _buildPowerOption(
                        icon: Icons.lock,
                        label: 'Lock',
                        onTap: () {},
                      ),
                      const SizedBox(height: 4),
                      _buildPowerOption(
                        icon: Icons.logout,
                        label: 'Log Out',
                        onTap: () {},
                      ),
                      const SizedBox(height: 4),
                      _buildPowerOption(
                        icon: Icons.restart_alt,
                        label: 'Restart',
                        onTap: () {},
                      ),
                      const SizedBox(height: 4),
                      _buildPowerOption(
                        icon: Icons.power_settings_new,
                        label: 'Shut Down',
                        color: Colors.red,
                        onTap: () {},
                      ),
                    ],
                  ).animate().fadeIn(delay: 250.ms, duration: 200.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFE95420).withOpacity(0.2)
                : const Color(0xFF3C3C3C),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? const Color(0xFFE95420) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFFE95420) : Colors.white70,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderControl({
    required IconData icon,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const Spacer(),
            Text(
              '${value.round()}%',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFFE95420),
            inactiveTrackColor: const Color(0xFF3C3C3C),
            thumbColor: const Color(0xFFE95420),
            overlayColor: const Color(0xFFE95420).withOpacity(0.3),
            trackHeight: 4,
          ),
          child: Slider(value: value, min: 0, max: 100, onChanged: onChanged),
        ),
      ],
    );
  }

  Widget _buildPowerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: color ?? Colors.white70, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(color: color ?? Colors.white, fontSize: 14),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
