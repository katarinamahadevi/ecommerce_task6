import 'package:ecommerce_task6/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    final success = await _authController.login(email, password);
    if (success) {
      Get.offNamed('/home');
    } else {
      // Show error message from the controller
      Get.snackbar(
        'Login Failed', 
        _authController.errorMessage.isNotEmpty 
          ? _authController.errorMessage 
          : 'Unable to login',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Obx(() => _authController.isLoading 
              ? CircularProgressIndicator() 
              : ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                )
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}