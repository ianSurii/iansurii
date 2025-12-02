import 'dart:io';
import 'package:flutter/material.dart';

class ImageViewerApp extends StatelessWidget {
  final String imagePath;
  final bool isAsset;

  const ImageViewerApp({
    super.key,
    required this.imagePath,
    this.isAsset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isAsset
          ? Image.asset(imagePath, fit: BoxFit.contain)
          : Image.file(File(imagePath), fit: BoxFit.contain),
    );
  }
}
