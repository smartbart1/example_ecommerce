class Category {
  final String name;

  Category({required this.name});

  // From JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name']);
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
