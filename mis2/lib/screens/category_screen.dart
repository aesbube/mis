import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_summary.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService api = ApiService();
  List<MealSummary> meals = [];
  List<MealSummary> filtered = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    meals = await api.fetchMealsByCategory(widget.category);
    filtered = meals;
    setState(() => loading = false);
  }

  void _search(String q) async {
    if (q.isEmpty) {
      setState(() => filtered = meals);
      return;
    }

    final results = await api.searchMeals(q);

    // Filter to only those belonging to this category (by matching names)
    final names = meals.map((e) => e.name.toLowerCase()).toSet();

    setState(() {
      filtered = results
          .where((r) => names.contains(r.name.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    onChanged: _search,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Пребарувај јадења...",
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.80,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final meal = filtered[i];
                      return MealCard(
                        meal: meal,
                        onTap: () async {
                          final detail = await api.fetchMealDetail(meal.id);
                          if (!mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MealDetailScreen(meal: detail),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
