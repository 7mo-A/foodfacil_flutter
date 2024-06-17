import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  RecipeListItem({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
          ? Image.network(
              recipe.imageUrl!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.fastfood, size: 50);
              },
            )
          : Icon(Icons.fastfood, size: 50),
      title: Text(recipe.name),
      subtitle: Text('Tiempo: ${recipe.time}\nIngredientes: ${recipe.ingredients.join(', ')}'),
      onTap: onTap,
    );
  }
}
