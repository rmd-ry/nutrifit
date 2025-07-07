import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_model.dart';

class FoodRepository {
  static const String _foodEntriesKey = 'food_entries';
  static const String _dailyStatsKey = 'daily_stats';

  // Get all food entries for a user
  Future<List<FoodModel>> getAllFoodEntries(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString('${_foodEntriesKey}_$userId');
    
    if (entriesJson == null) return [];
    
    final List<dynamic> entriesList = jsonDecode(entriesJson);
    return entriesList.map((json) => FoodModel.fromJson(json)).toList();
  }

  // Add food entry
  Future<bool> addFoodEntry(FoodModel foodEntry) async {
    try {
      final entries = await getAllFoodEntries(foodEntry.userId);
      
      // Add new entry with ID
      final newEntry = FoodModel(
        id: entries.length + 1,
        userId: foodEntry.userId,
        foodName: foodEntry.foodName,
        calories: foodEntry.calories,
        mealTime: foodEntry.mealTime,
        notes: foodEntry.notes,
        entryDate: foodEntry.entryDate,
      );
      
      entries.add(newEntry);
      
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = jsonEncode(entries.map((e) => e.toJson()).toList());
      await prefs.setString('${_foodEntriesKey}_${foodEntry.userId}', entriesJson);
      
      // Update daily stats
      await _updateDailyStats(foodEntry.userId, foodEntry.entryDate);
      
      return true;
    } catch (e) {
      print('Error adding food entry: $e');
      return false;
    }
  }

  // Get food entries for specific date
  Future<List<FoodModel>> getFoodEntriesByDate(int userId, DateTime date) async {
    final allEntries = await getAllFoodEntries(userId);
    final dateString = date.toIso8601String().split('T')[0];
    
    return allEntries.where((entry) {
      final entryDateString = entry.entryDate.toIso8601String().split('T')[0];
      return entryDateString == dateString;
    }).toList();
  }

  // Get daily calories for specific date
  Future<int> getDailyCalories(int userId, DateTime date) async {
    final entries = await getFoodEntriesByDate(userId, date);
    return entries.fold(0, (sum, entry) => sum + entry.calories);
  }

  // Get weekly calories data
  Future<List<int>> getWeeklyCalories(int userId, DateTime startDate) async {
    List<int> weeklyData = [];
    
    for (int i = 0; i < 7; i++) {
      final date = startDate.add(Duration(days: i));
      final calories = await getDailyCalories(userId, date);
      weeklyData.add(calories);
    }
    
    return weeklyData;
  }

  // Get daily stats
  Future<DailyStatsModel> getDailyStats(int userId, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = date.toIso8601String().split('T')[0];
    final statsJson = prefs.getString('${_dailyStatsKey}_${userId}_$dateString');
    
    if (statsJson != null) {
      return DailyStatsModel.fromJson(jsonDecode(statsJson));
    }
    
    // Create default stats if not exists
    final foodEntries = await getFoodEntriesByDate(userId, date);
    final totalCalories = foodEntries.fold(0, (sum, entry) => sum + entry.calories);
    
    return DailyStatsModel(
      date: date,
      totalCalories: totalCalories,
      waterGlasses: 4, // Default value
      steps: 7800, // Default value
      foodEntries: foodEntries,
    );
  }

  // Update daily stats
  Future<void> _updateDailyStats(int userId, DateTime date) async {
    final foodEntries = await getFoodEntriesByDate(userId, date);
    final totalCalories = foodEntries.fold(0, (sum, entry) => sum + entry.calories);
    
    final stats = DailyStatsModel(
      date: date,
      totalCalories: totalCalories,
      waterGlasses: 4, // You can make this dynamic
      steps: 7800, // You can make this dynamic
      foodEntries: foodEntries,
    );
    
    final prefs = await SharedPreferences.getInstance();
    final dateString = date.toIso8601String().split('T')[0];
    await prefs.setString(
      '${_dailyStatsKey}_${userId}_$dateString',
      jsonEncode(stats.toJson()),
    );
  }

  // Update water intake
  Future<bool> updateWaterIntake(int userId, DateTime date, int glasses) async {
    try {
      final stats = await getDailyStats(userId, date);
      final updatedStats = DailyStatsModel(
        date: stats.date,
        totalCalories: stats.totalCalories,
        waterGlasses: glasses,
        steps: stats.steps,
        foodEntries: stats.foodEntries,
      );
      
      final prefs = await SharedPreferences.getInstance();
      final dateString = date.toIso8601String().split('T')[0];
      await prefs.setString(
        '${_dailyStatsKey}_${userId}_$dateString',
        jsonEncode(updatedStats.toJson()),
      );
      
      return true;
    } catch (e) {
      print('Error updating water intake: $e');
      return false;
    }
  }

  // Update steps
  Future<bool> updateSteps(int userId, DateTime date, int steps) async {
    try {
      final stats = await getDailyStats(userId, date);
      final updatedStats = DailyStatsModel(
        date: stats.date,
        totalCalories: stats.totalCalories,
        waterGlasses: stats.waterGlasses,
        steps: steps,
        foodEntries: stats.foodEntries,
      );
      
      final prefs = await SharedPreferences.getInstance();
      final dateString = date.toIso8601String().split('T')[0];
      await prefs.setString(
        '${_dailyStatsKey}_${userId}_$dateString',
        jsonEncode(updatedStats.toJson()),
      );
      
      return true;
    } catch (e) {
      print('Error updating steps: $e');
      return false;
    }
  }

  // Initialize demo data
  Future<void> initializeDemoData(int userId) async {
    final entries = await getAllFoodEntries(userId);
    if (entries.isEmpty) {
      // Add demo food entries
      final today = DateTime.now();
      final yesterday = today.subtract(Duration(days: 1));
      
      final demoEntries = [
        FoodModel(
          userId: userId,
          foodName: 'Sandwich',
          calories: 500,
          mealTime: 'sarapan',
          notes: 'Sandwich dengan telur dan sayuran',
          entryDate: today,
        ),
        FoodModel(
          userId: userId,
          foodName: 'Nasi Goreng',
          calories: 750,
          mealTime: 'makan_siang',
          notes: 'Nasi goreng ayam',
          entryDate: today,
        ),
        FoodModel(
          userId: userId,
          foodName: 'Roti Bakar',
          calories: 300,
          mealTime: 'sarapan',
          notes: 'Roti bakar dengan selai',
          entryDate: yesterday,
        ),
        FoodModel(
          userId: userId,
          foodName: 'Salad',
          calories: 200,
          mealTime: 'makan_malam',
          notes: 'Salad sayuran segar',
          entryDate: yesterday,
        ),
      ];
      
      for (final entry in demoEntries) {
        await addFoodEntry(entry);
      }
    }
  }
}