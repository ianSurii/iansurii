import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iansurii/app/modules/home/controllers/home_controller.dart';

class AppMenuView extends StatelessWidget {
  const AppMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    final apps = [
      {'name': 'Firefox', 'icon': 'assets/images/firefox.png'},
      {'name': 'Files', 'icon': 'assets/images/folder.png'},
      {'name': 'Settings', 'icon': 'assets/images/settings.png'},
      {'name': 'Terminal', 'icon': 'assets/images/terminal.png'},
    ];

    return Container(
      color: const Color(0xFF2C2C2C),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.apps, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Applications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2, end: 0),

          const SizedBox(height: 24),

          // Search bar
          Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3C3C3C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search applications...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 100.ms, duration: 300.ms)
              .slideY(begin: -0.2, end: 0),

          const SizedBox(height: 24),

          // Apps grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                return _buildAppIcon(app['name']!, app['icon']!, () {
                  controller.openApp(app['name']!);
                  Get.back(); // Close the menu
                }, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(
    String name,
    String iconPath,
    VoidCallback onTap,
    int index,
  ) {
    return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(iconPath, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (100 + index * 50).ms, duration: 300.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))
        .then()
        .shimmer(delay: 500.ms, duration: 1000.ms);
  }
}
