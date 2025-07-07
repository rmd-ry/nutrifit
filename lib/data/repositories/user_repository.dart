import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserRepository {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  // Get all users (for login validation)
  Future<List<UserModel>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    
    if (usersJson == null) return [];
    
    final List<dynamic> usersList = jsonDecode(usersJson);
    return usersList.map((json) => UserModel.fromJson(json)).toList();
  }

  // Save user (register)
  Future<bool> saveUser(UserModel user) async {
    try {
      final users = await getAllUsers();
      
      // Check if email already exists
      if (users.any((u) => u.email == user.email)) {
        return false; // Email already exists
      }
      
      // Add new user with ID
      final newUser = user.copyWith(id: users.length + 1);
      users.add(newUser);
      
      final prefs = await SharedPreferences.getInstance();
      final usersJson = jsonEncode(users.map((u) => u.toJson()).toList());
      await prefs.setString(_usersKey, usersJson);
      
      return true;
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  // Login user
  Future<UserModel?> loginUser(String email, String password) async {
    try {
      final users = await getAllUsers();
      
      // Simple password validation (in real app, use proper hashing)
      final user = users.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('User not found'),
      );
      
      // For demo, any password works. In real app, validate hashed password
      if (password.isNotEmpty) {
        await _setCurrentUser(user);
        await _setAuthToken(user.id.toString());
        return user;
      }
      
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Get current logged in user
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    
    if (userJson == null) return null;
    
    return UserModel.fromJson(jsonDecode(userJson));
  }

  // Set current user
  Future<void> _setCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  // Set auth token
  Future<void> _setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get auth token
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.remove(_tokenKey);
  }

  // Update user profile
  Future<bool> updateUser(UserModel user) async {
    try {
      final users = await getAllUsers();
      final index = users.indexWhere((u) => u.id == user.id);
      
      if (index != -1) {
        users[index] = user;
        
        final prefs = await SharedPreferences.getInstance();
        final usersJson = jsonEncode(users.map((u) => u.toJson()).toList());
        await prefs.setString(_usersKey, usersJson);
        
        // Update current user if it's the same user
        final currentUser = await getCurrentUser();
        if (currentUser?.id == user.id) {
          await _setCurrentUser(user);
        }
        
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Initialize with demo data
  Future<void> initializeDemoData() async {
    final users = await getAllUsers();
    if (users.isEmpty) {
      // Add demo user
      final demoUser = UserModel(
        id: 1,
        email: 'demo@nutrifit.com',
        name: 'Ghazi',
        weight: 70.0,
        height: 180.0,
        birthDate: '17/08/2000',
        dailyCalorieTarget: 2000,
      );
      
      await saveUser(demoUser);
    }
  }
}