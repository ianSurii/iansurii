import 'package:get/get.dart';
import 'package:iansurii/app/data/repository/files.dart';
import 'package:iansurii/app/data/services/file_services.dart';

class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._internal();

  DependencyInjection._internal();

  factory DependencyInjection() {
    return _instance;
  }

  Future<void> initDependencies() async {
    // import file repository and services
    Get.put(FilesRepository(), permanent: true);
    Get.put(FileServices(Get.find<FilesRepository>()), permanent: true);


    
  }
}
