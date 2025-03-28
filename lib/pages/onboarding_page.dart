import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatelessWidget {
  @override
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
