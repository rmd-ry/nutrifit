class UserModel {
  final int? id;
  final String email;
  final String name;
  final double? weight;
  final double? height;
  final String? birthDate;
  final int dailyCalorieTarget;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.email,
    required this.name,
    this.weight,
    this.height,
    this.birthDate,
    this.dailyCalorieTarget = 2000,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'weight': weight,
      'height': height,
      'birth_date': birthDate,
      'daily_calorie_target': dailyCalorieTarget,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      birthDate: json['birth_date'],
      dailyCalorieTarget: json['daily_calorie_target'] ?? 2000,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    double? weight,
    double? height,
    String? birthDate,
    int? dailyCalorieTarget,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      birthDate: birthDate ?? this.birthDate,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      createdAt: createdAt,
    );
  }
}