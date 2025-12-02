import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:iansurii/app/data/models/desktop_item.dart';
import 'package:iansurii/app/modules/home/views/dock.dart';
import 'package:iansurii/app/modules/home/views/status_bar.dart';
import 'package:iansurii/app/modules/home/views/window.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          // Handle Ctrl+Alt+T for terminal
          if (event is KeyDownEvent) {
            final isCtrlPressed =
                event.logicalKey == LogicalKeyboardKey.controlLeft ||
                event.logicalKey == LogicalKeyboardKey.controlRight ||
                HardwareKeyboard.instance.isControlPressed;
            final isAltPressed =
                event.logicalKey == LogicalKeyboardKey.altLeft ||
                event.logicalKey == LogicalKeyboardKey.altRight ||
                HardwareKeyboard.instance.isAltPressed;
            final isTPressed = event.logicalKey == LogicalKeyboardKey.keyT;

            if (isCtrlPressed && isAltPressed && isTPressed) {
              controller.openApp('Terminal');
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              // Status bar at the top
              buildStatusBar(controller: controller, size: size),

              // Main desktop area
              Expanded(
                child: Stack(
                  children: [
                    // Background wallpaper
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/numbat_wallpaper.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Desktop icons
                    Obx(() {
                      final items = controller.desktopItems;
                      return Stack(
                        children: items.map((item) {
                          return Obx(
                            () => Positioned(
                              left: item.position.value.dx,
                              top: item.position.value.dy,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  controller.updateDesktopItemPosition(
                                    item.id,
                                    details.delta,
                                  );
                                },
                                onDoubleTap: () {
                                  if (item.type == DesktopItemType.folder) {
                                    controller.openFolder();
                                  } else if (item.file != null) {
                                    controller.openFile(item.file!);
                                  }
                                },
                                child: Container(
                                  width: 80,
                                  padding: const EdgeInsets.all(4),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildThumbnail(item),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),

                    // Windows stack (render in order; last is top)
                    Obx(() {
                      final wins = controller.windows;
                      return Stack(
                        children: wins
                            .map(
                              (w) => DesktopWindow(
                                window: w,
                                controller: controller,
                              ),
                            )
                            .toList(),
                      );
                    }),

                    // Dock - Always visible
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 24,
                      child: Center(child: buildDock(controller: controller)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(DesktopItem item) {
    if (item.type == DesktopItemType.folder) {
      return SizedBox(
        width: 64,
        height: 64,
        child: Image.asset('assets/images/folder.png', fit: BoxFit.contain),
      );
    }

    if (item.file != null) {
      final ext = item.file!.extension.toLowerCase();

      // Show image thumbnail
      if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) {
        return Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4),
            ],
          ),
          child: Image.asset(item.file!.absolutePath, fit: BoxFit.cover),
        );
      }

      // PDF icon
      if (ext == 'pdf') {
        return Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.red[700],
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
            size: 32,
          ),
        );
      }
    }

    // Default icon
    return SizedBox(
      width: 64,
      height: 64,
      child: Image.asset(item.iconPath, fit: BoxFit.contain),
    );
  }
}
