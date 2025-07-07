import '../repositories/food_repository.dart';
import '../models/food_model.dart';
import 'local_auth_service.dart';

class LocalFoodService {
  static final FoodRepository _foodRepository = FoodRepository();

  // Initialize demo data
  static Future<void> initialize() async {
    final user = await LocalAuthService.getCurrentUser();
    if (user != null) {
      await _foodRepository.initializeDemoData(user.id!);
    }
  }

  // Add food entry
  static Future<bool> addFood(String foodName, int calories, String mealTime, String notes) async {
    try {
      final user = await LocalAuthService.getCurrentUser();
      if (user == null) return false;

      final foodEntry = FoodModel(
        userId: user.id!,
        foodName: foodName,
        calories: calories,
        mealTime: mealTime,
        notes: notes,
      );

      return await _foodRepository.addFoodEntry(foodEntry);
    } catch (e) {
      print('Add food error: $e');
      return false;
    }
  }

  // Get daily food data
  static Future<DailyStatsModel?> getDailyFood([DateTime? date]) async {
    try {
      final user = await LocalAuthService.getCurrentUser();
      if (user == null) return null;

      final targetDate = date ?? DateTime.now();
      return await _foodRepository.getDailyStats(user.id!, targetDate);
    } catch (e) {
      print('Get daily food error: $e');
      return null;
    }
  }

  // Get weekly calories data
  static Future<List<int>> getWeeklyCalories([DateTime? startDate]) async {
    try {
      final user = await LocalAuthService.getCurrentUser();
      if (user == null) return [];

      final start = startDate ?? DateTime.now().subtract(Duration(days: 6));
      return await _foodRepository.getWeeklyCalories(user.id!, start);
    } catch (e) {
      print('Get weekly calories error: $e');
      return [];
    }
  }

  // Get food entries by date
  static Future<List<FoodModel>> getFoodEntriesByDate(DateTime date) async {
    try {
      final user = await LocalAuthService.getCurrentUser();
      if (user == null) return [];

      return await _foodRepository.getFoodEntriesByDate(user.id!, date);
    } catch (e) {
      print('Get food entries error: $e');
      return [];
    }
  }

  // Update water intake
  static Future<bool> updateWaterIntake(int glasses, [DateTime? date]) async {
    try {
      final user = await LocalAuthService.getCurrentUser();
      if (user == null) return false;

      final targetDate = date ?? DateTime.now();
      return await _foodRepository.updateWaterIntake(user.id!, targetDate, glasses);
    } catch (e) {
      print('Update water intake error: $e');
      return false;
    }
  }

  // Update steps
  static Future<bool> updateSteps(int steps, [DateTime? date]) async {
    try {
      final user = await LocalAuthService.getCurrentUser();
      if (user == null) return false;

      final targetDate = date ?? DateTime.now();
      return await _foodRepository.updateSteps(user.id!, targetDate, steps);
    } catch (e) {
      print('Update steps error: $e');
      return false;
    }
  }

  // Get average daily calories for a week
  static Future<int> getAverageWeeklyCalories([DateTime? startDate]) async {
    try {
      final weeklyData = await getWeeklyCalories(startDate);
      if (weeklyData.isEmpty) return 0;
      
      final total = weeklyData.reduce((a, b) => a + b);
      return (total / weeklyData.length).round();
    } catch (e) {
      print('Get average weekly calories error: $e');
      return 0;
    }
  }
}