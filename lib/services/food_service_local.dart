// Update food_service.dart to use local data
import '../data/services/local_food_service.dart';
import '../data/models/food_model.dart';

class FoodService {
  // Initialize
  static Future<void> initialize() async {
    await LocalFoodService.initialize();
  }

  // Add food
  static Future<bool> addFood(String foodName, int calories, String mealTime, String notes) async {
    return await LocalFoodService.addFood(foodName, calories, mealTime, notes);
  }

  // Get daily food data
  static Future<Map<String, dynamic>?> getDailyFood([String? date]) async {
    try {
      DateTime targetDate = DateTime.now();
      if (date != null) {
        targetDate = DateTime.parse(date);
      }

      final dailyStats = await LocalFoodService.getDailyFood(targetDate);
      return dailyStats?.toJson();
    } catch (e) {
      print('Get daily food error: $e');
      return null;
    }
  }

  // Get weekly food data
  static Future<List<Map<String, dynamic>>> getWeeklyFood(String startDate, String endDate) async {
    try {
      final start = DateTime.parse(startDate);
      final weeklyCalories = await LocalFoodService.getWeeklyCalories(start);
      
      List<Map<String, dynamic>> result = [];
      for (int i = 0; i < weeklyCalories.length; i++) {
        final date = start.add(Duration(days: i));
        result.add({
          'entry_date': date.toIso8601String().split('T')[0],
          'daily_calories': weeklyCalories[i],
        });
      }
      
      return result;
    } catch (e) {
      print('Get weekly food error: $e');
      return [];
    }
  }

  // Get food entries by date
  static Future<List<Map<String, dynamic>>> getFoodEntriesByDate(String date) async {
    try {
      final targetDate = DateTime.parse(date);
      final entries = await LocalFoodService.getFoodEntriesByDate(targetDate);
      return entries.map((e) => e.toJson()).toList();
    } catch (e) {
      print('Get food entries by date error: $e');
      return [];
    }
  }

  // Update water intake
  static Future<bool> updateWaterIntake(int glasses) async {
    return await LocalFoodService.updateWaterIntake(glasses);
  }

  // Update steps
  static Future<bool> updateSteps(int steps) async {
    return await LocalFoodService.updateSteps(steps);
  }
}