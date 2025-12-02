import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iansurii/app/core/helpers/logging.dart';
import 'package:iansurii/app/data/models/desktop_item.dart';
import 'package:iansurii/app/data/models/file.dart';
import 'package:iansurii/app/data/models/window_model.dart';
import 'package:iansurii/app/data/services/file_services.dart';
import 'package:iansurii/app/modules/home/views/apps/browser_app.dart';
import 'package:iansurii/app/modules/home/views/apps/file_manager.dart';
import 'package:iansurii/app/modules/home/views/apps/image_viewer.dart';
import 'package:iansurii/app/modules/home/views/apps/markdown_viewer.dart';
import 'package:iansurii/app/modules/home/views/apps/pdf_viewer.dart';
import 'package:iansurii/app/modules/home/views/apps/settings_app.dart';
import 'package:iansurii/app/modules/home/views/apps/terminal_app.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  final fileServices = Get.find<FileServices>();
  final _uuid = const Uuid();

  // State
  RxList<File> desktopFiles = <File>[].obs;
  RxList<DesktopItem> desktopItems = <DesktopItem>[].obs;
  RxList<WindowModel> windows = <WindowModel>[].obs;
  RxBool isDockVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFiles();
  }

  Future<void> fetchFiles() async {
    try {
      final files = await fileServices.getAllFiles();
      desktopFiles.assignAll(files);
      Logging.info("Fetched ${files.length} files.");

      // Create desktop items with initial grid positions
      _initializeDesktopItems();
    } catch (e) {
      Logging.error("Error fetching files: $e");
    }
  }

  void _initializeDesktopItems() {
    final items = <DesktopItem>[];

    // Add Home folder first
    items.add(
      DesktopItem(
        id: 'home-folder',
        name: 'Home',
        iconPath: 'assets/images/folder.png',
        type: DesktopItemType.folder,
        position: const Offset(20, 40),
      ),
    );

    // Add files in a grid
    double x = 20;
    double y = 140; // Start below the folder
    const double spacing = 100;
    const double maxWidth = 800;

    for (var file in desktopFiles) {
      final ext = file.extension.toLowerCase();
      String icon = 'assets/images/logo.png';

      // Use folder icon for unknown types
      if (!['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf'].contains(ext)) {
        icon = 'assets/images/folder.png';
      }

      items.add(
        DesktopItem(
          id: _uuid.v4(),
          name: file.name,
          iconPath: icon,
          type: DesktopItemType.file,
          position: Offset(x, y),
          file: file,
        ),
      );

      x += spacing;
      if (x > maxWidth) {
        x = 20;
        y += 120;
      }
    }

    desktopItems.assignAll(items);
  }

  void updateDesktopItemPosition(String id, Offset delta) {
    final item = desktopItems.firstWhereOrNull((i) => i.id == id);
    if (item != null) {
      item.position.value += delta;
    }
  }

  void openFolder() {
    _createWindow(
      title: 'Files - Home/Desktop',
      content: FileManagerApp(controller: this),
      iconPath: 'assets/images/folder.png',
    );
  }

  // --- Window Management ---

  void openFile(File file) {
    // Check if file is already open
    final existingWindow = windows.firstWhereOrNull(
      (w) => w.title == file.name,
    );

    if (existingWindow != null) {
      // Bring existing window to front and unminimize if needed
      if (existingWindow.isMinimized.value) {
        existingWindow.isMinimized.value = false;
      }
      bringToFront(existingWindow.id);
      return;
    }

    Widget content;
    String icon = 'assets/images/folder.png';

    String ext = file.extension.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) {
      content = ImageViewerApp(imagePath: file.absolutePath);
      icon = 'assets/images/logo.png';
    } else if (ext == 'pdf') {
      content = PdfViewerApp(filePath: file.absolutePath);
      icon = 'assets/images/logo.png';
    } else if (['md', 'markdown'].contains(ext)) {
      content = MarkdownViewerApp(filePath: file.absolutePath);
      icon = 'assets/images/logo.png';
    } else {
      content = Center(child: Text("Cannot open ${file.name}"));
    }

    _createWindow(title: file.name, content: content, iconPath: icon);
  }

  void openApp(String appName) {
    Widget content;
    String icon;
    String title = appName;

    switch (appName) {
      case 'Firefox':
        content = const BrowserApp();
        icon = 'assets/images/firefox.png';
        break;
      case 'Settings':
        content = const SettingsApp();
        icon = 'assets/images/settings.png';
        break;
      case 'Files':
        content = FileManagerApp(controller: this);
        icon = 'assets/images/folder.png';
        title = 'Files - Home/Desktop';
        break;
      case 'Terminal':
        content = const TerminalApp();
        icon = 'assets/images/terminal.png'; // Use logo as terminal icon
        title = 'Terminal: ~';
        break;
      default:
        return;
    }

    _createWindow(title: title, content: content, iconPath: icon);
  }

  void _createWindow({
    required String title,
    required Widget content,
    required String iconPath,
  }) {
    final id = _uuid.v4();
    final window = WindowModel(
      id: id,
      title: title,
      content: content,
      iconPath: iconPath,
      position: const Offset(100, 100),
    );
    windows.add(window);
    bringToFront(id);
  }

  void closeWindow(String id) {
    windows.removeWhere((w) => w.id == id);
  }

  void minimizeWindow(String id) {
    final window = windows.firstWhereOrNull((w) => w.id == id);
    if (window != null) {
      window.isMinimized.value = true;
    }
  }

  void unminimizeWindow(String id) {
    final window = windows.firstWhereOrNull((w) => w.id == id);
    if (window != null) {
      window.isMinimized.value = false;
      bringToFront(id);
    }
  }

  void maximizeWindow(String id, Size screenSize) {
    final window = windows.firstWhereOrNull((w) => w.id == id);
    if (window != null) {
      if (window.isMaximized.value) {
        // Restore
        if (window.preMaximizeRect != null) {
          window.position.value = window.preMaximizeRect!.topLeft;
          window.size.value = window.preMaximizeRect!.size;
        }
        window.isMaximized.value = false;
      } else {
        // Maximize - take full screen
        window.preMaximizeRect = Rect.fromLTWH(
          window.position.value.dx,
          window.position.value.dy,
          window.size.value.width,
          window.size.value.height,
        );
        window.position.value = const Offset(0, 0);
        window.size.value = Size(screenSize.width, screenSize.height);
        window.isMaximized.value = true;
      }
      bringToFront(id);
    }
  }

  void bringToFront(String id) {
    final index = windows.indexWhere((w) => w.id == id);
    if (index != -1 && index != windows.length - 1) {
      final window = windows.removeAt(index);
      windows.add(window);
    }
  }

  void updateWindowPosition(String id, Offset delta) {
    final window = windows.firstWhereOrNull((w) => w.id == id);
    if (window != null && !window.isMaximized.value) {
      window.position.value += delta;
    }
  }

  void updateWindowSize(String id, Offset delta) {
    final window = windows.firstWhereOrNull((w) => w.id == id);
    if (window != null && !window.isMaximized.value) {
      final newSize = Size(
        window.size.value.width + delta.dx,
        window.size.value.height + delta.dy,
      );
      if (newSize.width > 200 && newSize.height > 150) {
        window.size.value = newSize;
      }
    }
  }
}
