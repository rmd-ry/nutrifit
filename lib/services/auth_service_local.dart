// Update auth_service.dart to use local data
import '../data/services/local_auth_service.dart';
import '../data/models/user_model.dart';

class AuthService {
  // Initialize
  static Future<void> initialize() async {
    await LocalAuthService.initialize();
  }

  // Login
  static Future<bool> login(String email, String password) async {
    return await LocalAuthService.login(email, password);
  }

  // Register
  static Future<bool> register(String email, String password, String name) async {
    return await LocalAuthService.register(email, password, name);
  }

  // Get current user
  static Future<Map<String, dynamic>?> getUser() async {
    final user = await LocalAuthService.getCurrentUser();
    return user?.toJson();
  }

  // Get token
  static Future<String?> getToken() async {
    return await LocalAuthService.getToken();
  }

  // Logout
  static Future<void> logout() async {
    await LocalAuthService.logout();
  }

  // Check if logged in
  static Future<bool> isLoggedIn() async {
    return await LocalAuthService.isLoggedIn();
  }

  // Update profile
  static Future<bool> updateProfile(Map<String, dynamic> userData) async {
    try {
      final user = await LocalAuthService.getCurrentUser();
      if (user == null) return false;

      final updatedUser = user.copyWith(
        name: userData['name'],
        weight: userData['weight']?.toDouble(),
        height: userData['height']?.toDouble(),
        birthDate: userData['birth_date'],
        dailyCalorieTarget: userData['daily_calorie_target'],
      );

      return await LocalAuthService.updateProfile(updatedUser);
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
}