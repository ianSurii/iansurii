import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iansurii/app/core/depandancies/depandancy.dart';
import 'package:iansurii/app/core/helpers/logging.dart';
import 'package:logging/logging.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyInjection().initDependencies();
  _setupLogging();

  Logging.info("Dependencies initialized. Starting application...");

  runApp(
    GetMaterialApp(
      title: "Ian Muthuri",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}

void _setupLogging() {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}
