import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../models/meal_summary.dart';
import 'meal_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService api = ApiService();
  final FavoritesService favService = FavoritesService();
  List<MealSummary> meals = [];
  List<MealSummary> filtered = [];
  Set<String> favoritesSet = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    meals = await api.fetchMealsByCategory(widget.category);
    filtered = meals;
    await _loadFavorites();
    setState(() => loading = false);
  }

  Future<void> _loadFavorites() async {
    final favorites = await favService.getFavorites();
    setState(() {
      favoritesSet = favorites.toSet();
    });
  }

  void _search(String q) async {
    if (q.isEmpty) {
      setState(() => filtered = meals);
      return;
    }

    final results = await api.searchMeals(q);
    final names = meals.map((e) => e.name.toLowerCase()).toSet();

    setState(() {
      filtered = results
          .where((r) => names.contains(r.name.toLowerCase()))
          .toList();
    });
  }

  Future<void> _toggleFavorite(String mealId) async {
    await favService.toggleFavorite(mealId);
    await _loadFavorites();
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
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final meal = filtered[i];
                      final isFav = favoritesSet.contains(meal.id);

                      return Stack(
                        children: [
                          InkWell(
                            onTap: () async {
                              final detail = await api.fetchMealDetail(meal.id);
                              if (!mounted) return;
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      MealDetailScreen(meal: detail),
                                ),
                              );
                              await _loadFavorites();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Hero(
                                    tag: 'meal_${meal.id}',
                                    child: Image.network(
                                      meal.thumb,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    meal.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: IconButton(
                                icon: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav ? Colors.red : Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () => _toggleFavorite(meal.id),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
