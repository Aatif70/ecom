// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignResponse _$DesignResponseFromJson(Map<String, dynamic> json) =>
    DesignResponse(
      data: (json['Data'] as List<dynamic>)
          .map((e) => Design.fromJson(e as Map<String, dynamic>))
          .toList(),
      success: json['Success'] as bool,
      message: json['Message'] as String,
      statusCode: (json['StatusCode'] as num).toInt(),
    );

Map<String, dynamic> _$DesignResponseToJson(DesignResponse instance) =>
    <String, dynamic>{
      'Data': instance.data,
      'Success': instance.success,
      'Message': instance.message,
      'StatusCode': instance.statusCode,
    };

Design _$DesignFromJson(Map<String, dynamic> json) => Design(
  designId: (json['DesignId'] as num).toInt(),
  title: json['Title'] as String,
  designNumber: json['DesignNumber'] as String,
  categoryId: (json['CategoryId'] as num).toInt(),
  categoryName: json['CategoryName'] as String,
  seriesId: (json['SeriesId'] as num).toInt(),
  seriesName: json['SeriesName'] as String,
  brandId: (json['BrandId'] as num).toInt(),
  brandName: json['BrandName'] as String,
  isNew: json['IsNew'] as bool,
  createdAt: DateTime.parse(json['CreatedAt'] as String),
  images: (json['Images'] as List<dynamic>)
      .map((e) => DesignImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  sizePrices: json['SizePrices'] as List<dynamic>,
);

Map<String, dynamic> _$DesignToJson(Design instance) => <String, dynamic>{
  'DesignId': instance.designId,
  'Title': instance.title,
  'DesignNumber': instance.designNumber,
  'CategoryId': instance.categoryId,
  'CategoryName': instance.categoryName,
  'SeriesId': instance.seriesId,
  'SeriesName': instance.seriesName,
  'BrandId': instance.brandId,
  'BrandName': instance.brandName,
  'IsNew': instance.isNew,
  'CreatedAt': instance.createdAt.toIso8601String(),
  'Images': instance.images,
  'SizePrices': instance.sizePrices,
};

DesignImage _$DesignImageFromJson(Map<String, dynamic> json) => DesignImage(
  imageId: (json['ImageId'] as num).toInt(),
  designId: (json['DesignId'] as num).toInt(),
  imageUrl: json['ImageUrl'] as String,
);

Map<String, dynamic> _$DesignImageToJson(DesignImage instance) =>
    <String, dynamic>{
      'ImageId': instance.imageId,
      'DesignId': instance.designId,
      'ImageUrl': instance.imageUrl,
    };
