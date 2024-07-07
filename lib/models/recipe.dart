class Recipe {
  final String id;
  final String name;
  final String instruction;
  final List<String> ingredients;
  final List<String> keywords;
  final String time;
  final String? imageUrl;
  final double rating;
  final int ratingCount;

  Recipe({
    required this.id,
    required this.name,
    required this.instruction,
    required this.ingredients,
    required this.keywords,
    required this.time,
    this.imageUrl,
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  factory Recipe.fromMap(Map<String, dynamic> data, String documentId) {
    return Recipe(
      id: documentId,
      name: data['name'] ?? '',
      instruction: data['instruction'] ?? '',
      ingredients: List<String>.from(data['ingrediente'] ?? []),
      keywords: List<String>.from(data['keywords'] ?? []),
      time: data['tiempo'] ?? '',
      imageUrl: data['imageUrl'],
      rating: data['rating']?.toDouble() ?? 0.0,
      ratingCount: data['ratingCount']?.toInt() ?? 0,
    );
  }
}
