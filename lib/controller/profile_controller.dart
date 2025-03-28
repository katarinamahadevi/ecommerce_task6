import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';
// import 'auth_controller.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = Get.put(ProfileService());
  // final AuthController _authController = Get.find<AuthController>();

  final Rx<UserModel?> _user = Rx<UserModel?>(null);
  UserModel? get user => _user.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final userData = await _profileService.getUserProfile();
      if (userData != null) {
        _user.value = userData;
      } else {
        _errorMessage.value = 'Failed to load user data';
      }
    } catch (e) {
      _errorMessage.value = 'An error occurred';
    } finally {
      _isLoading.value = false;
    }
  }
  Future<void> updateUserProfile(String name, String password) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      bool success = await _profileService.updateUserProfile(name, password);
      if (success) {
        await fetchUserProfile(); // Refresh data setelah update
        Get.snackbar("Success", "Profile updated successfully");
      } else {
        _errorMessage.value = 'Profile update failed';
        Get.snackbar("Error", "Failed to update profile");
      }
    } catch (e) {
      _errorMessage.value = 'An error occurred';
      Get.snackbar("Error", "An unexpected error occurred");
    } finally {
      _isLoading.value = false;
    }
  }
}

