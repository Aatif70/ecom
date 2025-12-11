import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String sku;
  final String title;
  final String category;
  final String description;
  final List<String> images;
  final List<ProductVariant> variants;
  final List<String> tags;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Product({
    required this.id,
    required this.sku,
    required this.title,
    required this.category,
    required this.description,
    required this.images,
    required this.variants,
    required this.tags,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class ProductVariant {
  final String size;
  final double mrp;
  @JsonKey(name: 'available_qty')
  final int availableQty;

  ProductVariant({
    required this.size,
    required this.mrp,
    required this.availableQty,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => _$ProductVariantFromJson(json);
  Map<String, dynamic> toJson() => _$ProductVariantToJson(this);
}
