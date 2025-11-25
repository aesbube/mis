import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const base = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse("$base/categories.php"));
    final data = jsonDecode(res.body);
    return (data['categories'] as List)
        .map((e) => Category.fromJson(e))
        .toList();
  }

  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final res = await http.get(
      Uri.parse("$base/filter.php?c=${Uri.encodeComponent(category)}"),
    );
    final data = jsonDecode(res.body);
    return (data['meals'] as List).map((e) => MealSummary.fromJson(e)).toList();
  }

  Future<List<MealSummary>> searchMeals(String query) async {
    final res = await http.get(
      Uri.parse("$base/search.php?s=${Uri.encodeComponent(query)}"),
    );

    final data = jsonDecode(res.body);
    final list = data['meals'] as List?;

    if (list == null) return [];
    return list.map((e) => MealSummary.fromJson(e)).toList();
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final res = await http.get(Uri.parse("$base/lookup.php?i=$id"));
    final data = jsonDecode(res.body);
    return MealDetail.fromJson(data['meals'][0]);
  }

  Future<MealDetail> fetchRandomMeal() async {
    final res = await http.get(Uri.parse("$base/random.php"));
    final data = jsonDecode(res.body);
    return MealDetail.fromJson(data['meals'][0]);
  }
}
