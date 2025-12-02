import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iansurii/app/modules/home/controllers/home_controller.dart';
import 'package:iansurii/app/modules/home/views/apps/app_menu.dart';

Widget buildDock({required HomeController controller}) {
  return Obx(() {
    final minimizedWindows = controller.windows
        .where((w) => w.isMinimized.value)
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App Menu Icon
          _buildDockIcon('assets/images/logo.png', () {
            Get.dialog(
              Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.all(40),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                    maxHeight: 600,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const AppMenuView(),
                ),
              ),
            );
          }),
          const SizedBox(width: 8),

          // Firefox
          _buildDockIcon(
            'assets/images/firefox.png',
            () => controller.openApp('Firefox'),
          ),
          const SizedBox(width: 8),

          // Files
          _buildDockIcon(
            'assets/images/folder.png',
            () => controller.openApp('Files'),
          ),
          const SizedBox(width: 8),

          // Settings
          _buildDockIcon(
            'assets/images/settings.png',
            () => controller.openApp('Settings'),
          ),
          const SizedBox(width: 8),

          // Terminal
          _buildDockIcon(
            'assets/images/terminal.png',
            () => controller.openApp('Terminal'),
          ),

          // Separator if there are minimized windows
          if (minimizedWindows.isNotEmpty) ...[
            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white.withOpacity(0.3),
            ),
          ],

          // Show minimized windows
          ...minimizedWindows.map((w) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildDockIcon(
                w.iconPath,
                () => controller.unminimizeWindow(w.id),
                isMinimized: true,
              ),
            );
          }).toList(),
        ],
      ),
    );
  });
}

Widget _buildDockIcon(
  String iconPath,
  VoidCallback onTap, {
  bool isMinimized = false,
}) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isMinimized
              ? Border.all(color: Colors.blue.withOpacity(0.6), width: 2)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(iconPath, fit: BoxFit.cover),
        ),
      ),
    ),
  );
}
