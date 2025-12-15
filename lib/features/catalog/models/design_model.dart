import 'package:json_annotation/json_annotation.dart';

part 'design_model.g.dart';

@JsonSerializable()
class DesignResponse {
  @JsonKey(name: 'Data')
  final List<Design> data;
  @JsonKey(name: 'Success')
  final bool success;
  @JsonKey(name: 'Message')
  final String message;
  @JsonKey(name: 'StatusCode')
  final int statusCode;

  DesignResponse({
    required this.data,
    required this.success,
    required this.message,
    required this.statusCode,
  });

  factory DesignResponse.fromJson(Map<String, dynamic> json) => _$DesignResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DesignResponseToJson(this);
}

@JsonSerializable()
class Design {
  @JsonKey(name: 'DesignId')
  final int designId;
  @JsonKey(name: 'Title')
  final String title;
  @JsonKey(name: 'DesignNumber')
  final String designNumber;
  @JsonKey(name: 'CategoryId')
  final int categoryId;
  @JsonKey(name: 'CategoryName')
  final String categoryName;
  @JsonKey(name: 'SeriesId')
  final int seriesId;
  @JsonKey(name: 'SeriesName')
  final String seriesName;
  @JsonKey(name: 'BrandId')
  final int brandId;
  @JsonKey(name: 'BrandName')
  final String brandName;
  @JsonKey(name: 'IsNew')
  final bool isNew;
  @JsonKey(name: 'CreatedAt')
  final DateTime createdAt;
  @JsonKey(name: 'Images')
  final List<DesignImage> images;
  @JsonKey(name: 'SizePrices')
  final List<SizePrice> sizePrices;

  Design({
    required this.designId,
    required this.title,
    required this.designNumber,
    required this.categoryId,
    required this.categoryName,
    required this.seriesId,
    required this.seriesName,
    required this.brandId,
    required this.brandName,
    required this.isNew,
    required this.createdAt,
    required this.images,
    required this.sizePrices,
  });

  factory Design.fromJson(Map<String, dynamic> json) => _$DesignFromJson(json);
  Map<String, dynamic> toJson() => _$DesignToJson(this);
}

@JsonSerializable()
class DesignImage {
  @JsonKey(name: 'ImageId')
  final int imageId;
  @JsonKey(name: 'DesignId')
  final int designId;
  @JsonKey(name: 'ImageUrl')
  final String imageUrl;

  DesignImage({
    required this.imageId,
    required this.designId,
    required this.imageUrl,
  });

  factory DesignImage.fromJson(Map<String, dynamic> json) => _$DesignImageFromJson(json);
  Map<String, dynamic> toJson() => _$DesignImageToJson(this);
}

@JsonSerializable()
class SizePrice {
  @JsonKey(name: 'PSPId')
  final int pspId;
  @JsonKey(name: 'DesignId')
  final int designId;
  @JsonKey(name: 'SizeId')
  final int sizeId;
  @JsonKey(name: 'SizeName')
  final String sizeName;
  @JsonKey(name: 'Price')
  final double price;
  @JsonKey(name: 'Stock')
  final int stock;

  SizePrice({
    required this.pspId,
    required this.designId,
    required this.sizeId,
    required this.sizeName,
    required this.price,
    required this.stock,
  });

  factory SizePrice.fromJson(Map<String, dynamic> json) => _$SizePriceFromJson(json);
  Map<String, dynamic> toJson() => _$SizePriceToJson(this);
}
