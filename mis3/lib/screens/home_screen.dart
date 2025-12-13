import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'category_screen.dart';
import 'meal_detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  List<Category> categories = [];
  List<Category> filtered = [];
  bool loading = true;
  final TextEditingController ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    categories = await api.fetchCategories();
    filtered = categories;
    setState(() => loading = false);
  }

  void _search(String q) {
    q = q.toLowerCase();
    setState(() {
      filtered = categories
          .where(
            (c) =>
                c.name.toLowerCase().contains(q) ||
                c.description.toLowerCase().contains(q),
          )
          .toList();
    });
  }

  Future<void> _openRandom() async {
    final meal = await api.fetchRandomMeal();
    if (!mounted) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => MealDetailScreen(meal: meal)));
  }

  void _testNotification() {
    NotificationService().scheduleDailyNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Категории"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const FavoritesScreen())),
          ),
          IconButton(icon: const Icon(Icons.casino), onPressed: _openRandom),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _testNotification,
            tooltip: 'Тест нотификација',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: ctrl,
                    onChanged: _search,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Пребарувај категории...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      return CategoryCard(
                        category: filtered[i],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                CategoryScreen(category: filtered[i].name),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
