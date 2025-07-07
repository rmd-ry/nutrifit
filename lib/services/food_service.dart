import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class FoodService {
  static const String baseUrl = 'http://your-domain.com/api';

  static Future<bool> addFood(String foodName, int calories, String mealTime, String notes) async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/food/add.php'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'food_name': foodName,
          'calories': calories,
          'meal_time': mealTime,
          'notes': notes,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'];
      }
      return false;
    } catch (e) {
      print('Add food error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getDailyFood(String date) async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/food/daily.php?date=$date'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      print('Get daily food error: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getWeeklyFood(String startDate, String endDate) async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/food/weekly.php?start_date=$startDate&end_date=$endDate'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Get weekly food error: $e');
      return [];
    }
  }
}