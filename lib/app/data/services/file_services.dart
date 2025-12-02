import 'package:flutter/foundation.dart';
import 'package:iansurii/app/core/helpers/logging.dart';
import 'package:iansurii/app/data/repository/files.dart';

import '../models/file.dart';

class FileServices {
  FilesRepository _repository;

  FileServices(this._repository);

  Future<List<File>> getAllFiles() async {
    debugPrint("FileServices: Calling loadAllFiles...");
    Logging.info("Fetching all files from repository...");

    try {
      final files = await _repository.loadAllFiles();
      debugPrint("FileServices: Retrieved ${files.length} files");
      return files;
    } catch (e) {
      debugPrint("FileServices: Error - $e");
      rethrow;
    }
  }
}
