class Recipe {
  final String id;
  final String name;
  final String instruction;
  final List<String> ingredients;
  final List<String> keywords;
  final String time;
  final String? imageUrl; 

  Recipe({
    required this.id,
    required this.name,
    required this.instruction,
    required this.ingredients,
    required this.keywords,
    required this.time,
    this.imageUrl,
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
    );
  }
}
