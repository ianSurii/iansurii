import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';
import 'system_tray.dart';

class StatusBarWidget extends StatefulWidget {
  final HomeController controller;
  final Size size;

  const StatusBarWidget({
    super.key,
    required this.controller,
    required this.size,
  });

  @override
  State<StatusBarWidget> createState() => _StatusBarWidgetState();
}

class _StatusBarWidgetState extends State<StatusBarWidget> {
  late Timer _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('EEE MMM d HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C), // Ubuntu dark theme
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Ubuntu logo
          Row(
            children: [
              const SizedBox(width: 8),
              // Ubuntu logo
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFE95420), // Ubuntu orange
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.circle, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),

          // Center - Time
          Text(
            _currentTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Right side - Status icons
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // Get the position for the popup
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final position = renderBox.localToGlobal(Offset.zero);

                Get.dialog(
                  Stack(
                    children: [
                      // Transparent barrier to close on outside tap
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      // System tray menu
                      Positioned(
                        top: position.dy + 35,
                        right: 8,
                        child: const SystemTrayMenu(),
                      ),
                    ],
                  ),
                  barrierColor: Colors.transparent,
                  barrierDismissible: true,
                );
              },
              child: Row(
                children: [
                  _buildStatusIcon(Icons.volume_up, () {}),
                  const SizedBox(width: 8),
                  _buildStatusIcon(Icons.wifi, () {}),
                  const SizedBox(width: 8),
                  _buildStatusIcon(Icons.battery_full, () {}),
                  const SizedBox(width: 8),
                  _buildStatusIcon(Icons.power_settings_new, () {}),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

Widget buildStatusBar({
  required HomeController controller,
  required Size size,
}) {
  return StatusBarWidget(controller: controller, size: size);
}
