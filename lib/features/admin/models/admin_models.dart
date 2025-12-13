import '../../../core/constants/api_constants.dart';

class Brand {
  final int id;
  final String name;
  final String? logoUrl;

  Brand({required this.id, required this.name, this.logoUrl});

  factory Brand.fromJson(Map<String, dynamic> json) {
    String? logo = json['LogoUrl'];
    if (logo != null && !logo.startsWith('http')) {
      logo = '${ApiConstants.baseUrl}$logo';
    }
    return Brand(
      id: json['BrandId'] ?? json['Id'] ?? 0,
      name: json['Name'] ?? '',
      logoUrl: logo,
    );
  }
}

class Category {
  final int id;
  final String name;
  final String? imageUrl;

  Category({required this.id, required this.name, this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    String? img = json['ImageUrl'];
    if (img != null && !img.startsWith('http')) {
      img = '${ApiConstants.baseUrl}$img';
    }
    return Category(
      id: json['CategoryId'] ?? json['Id'] ?? 0,
      name: json['Name'] ?? '',
      imageUrl: img,
    );
  }
}

class Series {
  final int id;
  final String name;

  Series({required this.id, required this.name});

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['SeriesId'] ?? json['Id'] ?? 0,
      name: json['Name'] ?? '',
    );
  }
}
