import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://your-domain.com/api';

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Save token
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['data']['token']);
          await prefs.setString('user', jsonEncode(data['data']['user']));
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static Future<bool> register(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'];
      }
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, dynamic>?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }
}