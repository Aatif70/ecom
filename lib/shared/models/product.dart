import 'package:json_annotation/json_annotation.dart';
import '../../features/catalog/models/design_model.dart';
import '../../core/constants/api_constants.dart';

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
  @JsonKey(name: 'is_new')
  final bool isNew;

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
    this.isNew = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  factory Product.fromDesign(Design design) {
    return Product(
      id: design.designId.toString(),
      sku: design.designNumber,
      title: design.title,
      category: design.categoryName,
      description: '', // Not provided in API yet
      images: design.images.map((img) {
        // Convert relative URL to absolute URL if needed
        if (img.imageUrl.startsWith('/')) {
          return '${ApiConstants.baseUrl}${img.imageUrl}';
        }
        return img.imageUrl;
      }).toList(),
      variants: design.sizePrices.map((sp) => ProductVariant(
        size: sp.sizeName,
        mrp: sp.price,
        availableQty: sp.stock,
      )).toList(),
      tags: [design.seriesName, design.brandName],
      createdAt: design.createdAt,
      isNew: design.isNew,
    );
  }
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
