import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iansurii/app/data/models/window_model.dart';
import 'package:iansurii/app/modules/home/controllers/home_controller.dart';

class DesktopWindow extends StatelessWidget {
  final WindowModel window;
  final HomeController controller;

  const DesktopWindow({
    super.key,
    required this.window,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (window.isMinimized.value) return const SizedBox.shrink();

      return Positioned(
            left: window.position.value.dx,
            top: window.position.value.dy,
            width: window.size.value.width,
            height: window.size.value.height,
            child: GestureDetector(
              onTap: () => controller.bringToFront(window.id),
              child: Material(
                elevation: 12,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Title bar
                      GestureDetector(
                        onPanUpdate: (details) {
                          controller.updateWindowPosition(
                            window.id,
                            details.delta,
                          );
                        },
                        onDoubleTap: () => controller.maximizeWindow(
                          window.id,
                          MediaQuery.of(context).size,
                        ),
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                window.iconPath,
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  window.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              // Controls
                              IconButton(
                                icon: const Icon(Icons.minimize, size: 18),
                                onPressed: () =>
                                    controller.minimizeWindow(window.id),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              IconButton(
                                icon: Obx(
                                  () => Icon(
                                    window.isMaximized.value
                                        ? Icons.fullscreen_exit
                                        : Icons.crop_square,
                                    size: 18,
                                  ),
                                ),
                                onPressed: () => controller.maximizeWindow(
                                  window.id,
                                  MediaQuery.of(context).size,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () =>
                                    controller.closeWindow(window.id),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Content
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: window.content,
                        ),
                      ),

                      // Resize handle
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onPanUpdate: (details) => controller.updateWindowSize(
                            window.id,
                            details.delta,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.drag_handle,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .animate()
          .fadeIn(duration: 200.ms)
          .scale(begin: const Offset(0.8, 0.8), duration: 200.ms);
    });
  }
}
