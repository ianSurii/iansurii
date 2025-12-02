import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:iansurii/app/core/helpers/logging.dart';

import '../models/file.dart';
import 'package:path/path.dart' as p;

class FilesRepository {
  FilesRepository();

  // load files
  Future<List<File>> loadAllFiles() async {
    try {
      // 1. Load the AssetManifest (Works for both standard and web)
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

      // 2. Filter: Get all keys starting with 'assets/files/'
      final filePaths = manifest
          .listAssets()
          .where((String key) => key.startsWith('assets/files/'))
          .toList();

      print("Found ${filePaths.length} files in assets/files/.");

      // 3. Map to your Model
      List<File> models = filePaths.map((path) {
        return File(
          name: _getFileName(path),
          extension: _getFileExtension(path),
          parentDirectory: _getParentDirectory(path),
          absolutePath: path,
        );
      }).toList();

      Logging.debug("Files${models.map((e) => e.toJson()).toList()}");

      return models;
    } catch (e) {
      Logging.error("Error loading files: $e");
      return [];
    }
  }

  String _getFileName(String path) {
    return p.basename(path);
  }

  String _getFileExtension(String path) {
    return p.extension(path).replaceAll('.', '');
  }

  String _getParentDirectory(String path) {
    return p.dirname(path);
  }
}
