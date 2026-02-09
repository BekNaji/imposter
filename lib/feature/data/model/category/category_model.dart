class CategoryModel {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final bool isLocked;
  final List<String> words;

  CategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    this.isLocked = false,
    this.words = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imagePath: json['imagePath'],
      isLocked: json['isLocked'] ?? false,
      words: List<String>.from(json['words']),
    );
  }
}