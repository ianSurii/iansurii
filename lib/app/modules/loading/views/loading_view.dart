import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/loading_controller.dart';

class LoadingView extends GetView<LoadingController> {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access controller to ensure it's initialized and onInit is called
    controller.hashCode;

    return Scaffold(
      backgroundColor: const Color(0xFF47033E), // Ubuntu purple background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset('assets/images/logo.png', width: 120, height: 120),

            const SizedBox(height: 40),

            // Circular progress indicator
            const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),

            const SizedBox(height: 40),

            // Ubuntu text/logo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent, // Ubuntu orange
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/ubuntu.png', height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
