import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WindowModel {
  final String id;
  String title;
  Widget content;
  final String iconPath; // For the dock/title bar

  // Reactive properties
  Rx<Offset> position;
  Rx<Size> size;
  RxBool isMinimized;
  RxBool isMaximized;

  // store pre-maximize rect
  Rect? preMaximizeRect;

  WindowModel({
    required this.id,
    required this.title,
    required this.content,
    Offset position = const Offset(100, 100),
    Size size = const Size(600, 400),
    bool isMinimized = false,
    bool isMaximized = false,
    this.iconPath = 'assets/icons/default_app.png',
  }) : position = position.obs,
       size = size.obs,
       isMinimized = isMinimized.obs,
       isMaximized = isMaximized.obs;
}
