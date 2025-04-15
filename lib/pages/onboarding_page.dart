import 'package:ecommerce_task6/controller/auth_controller.dart';
import 'package:ecommerce_task6/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatefulWidget {
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    String? token = await StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      // await Get.find<AuthController>().loadUserFromToken();
      Get.offAllNamed('/home');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Tokopaedi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed('/login'),
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
