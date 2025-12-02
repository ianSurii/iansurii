import 'package:get/get.dart';
import 'package:iansurii/app/routes/app_pages.dart';

class LoadingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Navigate to home after 10 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Get.offAllNamed(Routes.HOME);
    });
  }
}
