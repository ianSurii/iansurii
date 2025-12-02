import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iansurii/app/data/models/desktop_item.dart';
import 'package:iansurii/app/modules/home/controllers/home_controller.dart';

class FileManagerApp extends StatelessWidget {
  final HomeController controller;

  const FileManagerApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Toolbar / Breadcrumbs (Simplified)
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              color: Colors.grey[100],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 18),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                const Text("Home / Desktop", style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          // File List
          Expanded(
            child: Obx(() {
              // Filter only files for the file manager view (exclude the folder itself if we want)
              // Or just show all "files" available in the system
              final files = controller.desktopItems
                  .where((item) => item.type == DesktopItemType.file)
                  .toList();

              if (files.isEmpty) {
                return const Center(child: Text("No files found"));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final item = files[index];
                  return GestureDetector(
                    onDoubleTap: () {
                      if (item.file != null) {
                        controller.openFile(item.file!);
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child:
                              item.file != null &&
                                  _isImage(item.file!.extension)
                              ? Image.asset(
                                  item.file!.absolutePath,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(item.iconPath, fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  bool _isImage(String ext) {
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext.toLowerCase());
  }
}
