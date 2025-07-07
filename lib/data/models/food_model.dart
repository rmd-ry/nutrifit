class FoodModel {
  final int? id;
  final int userId;
  final String foodName;
  final int calories;
  final String mealTime; // sarapan, makan_siang, makan_malam
  final String? notes;
  final DateTime entryDate;
  final DateTime createdAt;

  FoodModel({
    this.id,
    required this.userId,
    required this.foodName,
    required this.calories,
    required this.mealTime,
    this.notes,
    DateTime? entryDate,
    DateTime? createdAt,
  }) : entryDate = entryDate ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'food_name': foodName,
      'calories': calories,
      'meal_time': mealTime,
      'notes': notes,
      'entry_date': entryDate.toIso8601String().split('T')[0],
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      userId: json['user_id'],
      foodName: json['food_name'],
      calories: json['calories'],
      mealTime: json['meal_time'],
      notes: json['notes'],
      entryDate: DateTime.parse(json['entry_date']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class DailyStatsModel {
  final DateTime date;
  final int totalCalories;
  final int waterGlasses;
  final int steps;
  final List<FoodModel> foodEntries;

  DailyStatsModel({
    required this.date,
    required this.totalCalories,
    required this.waterGlasses,
    required this.steps,
    required this.foodEntries,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'total_calories': totalCalories,
      'water_glasses': waterGlasses,
      'steps': steps,
      'food_entries': foodEntries.map((e) => e.toJson()).toList(),
    };
  }

  factory DailyStatsModel.fromJson(Map<String, dynamic> json) {
    return DailyStatsModel(
      date: DateTime.parse(json['date']),
      totalCalories: json['total_calories'],
      waterGlasses: json['water_glasses'],
      steps: json['steps'],
      foodEntries: (json['food_entries'] as List)
          .map((e) => FoodModel.fromJson(e))
          .toList(),
    );
  }
}