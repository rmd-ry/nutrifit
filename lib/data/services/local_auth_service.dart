import '../repositories/user_repository.dart';
import '../models/user_model.dart';

class LocalAuthService {
  static final UserRepository _userRepository = UserRepository();

  // Initialize demo data
  static Future<void> initialize() async {
    await _userRepository.initializeDemoData();
  }

  // Login
  static Future<bool> login(String email, String password) async {
    try {
      final user = await _userRepository.loginUser(email, password);
      return user != null;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Register
  static Future<bool> register(String email, String password, String name) async {
    try {
      final user = UserModel(
        email: email,
        name: name,
        // In real app, hash the password
      );
      
      return await _userRepository.saveUser(user);
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  // Get current user
  static Future<UserModel?> getCurrentUser() async {
    return await _userRepository.getCurrentUser();
  }

  // Get auth token
  static Future<String?> getToken() async {
    return await _userRepository.getAuthToken();
  }

  // Logout
  static Future<void> logout() async {
    await _userRepository.logout();
  }

  // Update user profile
  static Future<bool> updateProfile(UserModel user) async {
    return await _userRepository.updateUser(user);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    final user = await getCurrentUser();
    return token != null && user != null;
  }
}