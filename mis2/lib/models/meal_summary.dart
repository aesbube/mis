class MealSummary {
  final String id;
  final String name;
  final String thumb;

  MealSummary({
    required this.id,
    required this.name,
    required this.thumb,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'],
      name: json['strMeal'],
      thumb: json['strMealThumb'],
    );
  }
}
