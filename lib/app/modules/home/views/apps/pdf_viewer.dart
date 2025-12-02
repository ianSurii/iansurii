import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfViewerApp extends StatelessWidget {
  final String filePath;

  const PdfViewerApp({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return PdfViewer.asset(
      filePath,
      params: PdfViewerParams(backgroundColor: Colors.grey[300]!),
    );
  }
}
