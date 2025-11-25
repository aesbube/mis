import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal_summary.dart';

class MealCard extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;

  const MealCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(imageUrl: meal.thumb, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          Text(meal.name, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
