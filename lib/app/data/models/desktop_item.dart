import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iansurii/app/data/models/file.dart';

enum DesktopItemType { file, folder, app }

class DesktopItem {
  final String id;
  final String name;
  final String iconPath;
  final DesktopItemType type;
  final File? file; // If it's a file

  // Reactive position
  Rx<Offset> position;

  DesktopItem({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.type,
    required Offset position,
    this.file,
  }) : position = position.obs;
}
