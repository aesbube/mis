import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';

class MealDetailScreen extends StatelessWidget {
  final MealDetail meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal.name)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          CachedNetworkImage(
            imageUrl: meal.thumb,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),
          Text(meal.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text("Категорија: ${meal.category}"),
          Text("Регион: ${meal.area}"),
          const SizedBox(height: 12),
          Text("Состојки", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          ...meal.ingredients.entries.map(
            (e) => Text("- ${e.key}: ${e.value}"),
          ),
          const SizedBox(height: 12),
          Text("Упатства", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(meal.instructions),
          const SizedBox(height: 20),
          if (meal.youtube.isNotEmpty)
            ElevatedButton.icon(
              icon: const Icon(Icons.video_library),
              label: const Text("YouTube видео"),
              onPressed: () async {
                final uri = Uri.parse(meal.youtube);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
        ],
      ),
    );
  }
}
