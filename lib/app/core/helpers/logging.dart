import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class Logging {
  static final Logger log = Logger('Logging');

  static void info(String message) {
    try {
      // if (kDebugMode) {
        log.info('ℹ️ $message');
      // }
    } catch (e) {
      print('Logging info error: $e');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      log.fine('🐛 $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      log.warning('⚠️ $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      log.severe('❌ $message', error, stackTrace);
    }
  }

  static void verbose(String message) {
    if (kDebugMode) {
      log.finer('🔍 $message');
    }
  }
}
