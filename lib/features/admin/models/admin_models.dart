
class Brand {
  final int id; // Assuming ID is int from common API patterns, but specific response not shown. I will assume int based on User Id.
  final String name;
  final String? logoUrl;

  Brand({required this.id, required this.name, this.logoUrl});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['Id'] ?? 0,
      name: json['Name'] ?? '',
      logoUrl: json['LogoUrl'], // Check actual response key if possible, assuming standard
    );
  }
}

class Category {
  final int id;
  final String name;
  final String? imageUrl;

  Category({required this.id, required this.name, this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['Id'] ?? 0,
      name: json['Name'] ?? '',
      imageUrl: json['ImageUrl'],
    );
  }
}
