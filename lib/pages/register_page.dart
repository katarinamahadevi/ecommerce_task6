// register_page.dart
import 'package:ecommerce_task6/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Register'), backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            Obx(
              () =>
                  authController.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: () async {
                          Get.toNamed('/login');
                          bool success = await authController.register(
                            nameController.text,
                            emailController.text,
                            passwordController.text,
                          );
                          if (success) {
                            Get.snackbar(
                              'Success',
                              'Registration successful',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              authController.errorMessage,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: Text('Register'),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
