import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  final ProfileController _profileController = Get.find<ProfileController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = _profileController.user?.name ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            SizedBox(height: 20),
            Obx(() {
              return ElevatedButton(
                onPressed:
                    _profileController.isLoading
                        ? null
                        : () async {
                          await _profileController.updateUserProfile(
                            nameController.text,
                            passwordController.text,
                          );
                          Get.to(() => EditProfilePage());
                        },
                child:
                    _profileController.isLoading
                        ? CircularProgressIndicator()
                        : Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.black),
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 235, 234, 234),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
