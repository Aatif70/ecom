// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResponse _$CartResponseFromJson(Map<String, dynamic> json) => CartResponse(
  data: Cart.fromJson(json['Data'] as Map<String, dynamic>),
  success: json['Success'] as bool,
  message: json['Message'] as String,
  statusCode: (json['StatusCode'] as num).toInt(),
);

Map<String, dynamic> _$CartResponseToJson(CartResponse instance) =>
    <String, dynamic>{
      'Data': instance.data,
      'Success': instance.success,
      'Message': instance.message,
      'StatusCode': instance.statusCode,
    };

CartItemResponse _$CartItemResponseFromJson(Map<String, dynamic> json) =>
    CartItemResponse(
      data: CartItem.fromJson(json['Data'] as Map<String, dynamic>),
      success: json['Success'] as bool,
      message: json['Message'] as String,
      statusCode: (json['StatusCode'] as num).toInt(),
    );

Map<String, dynamic> _$CartItemResponseToJson(CartItemResponse instance) =>
    <String, dynamic>{
      'Data': instance.data,
      'Success': instance.success,
      'Message': instance.message,
      'StatusCode': instance.statusCode,
    };

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
  cartId: (json['CartId'] as num).toInt(),
  userId: (json['UserId'] as num).toInt(),
  createdAt: DateTime.parse(json['CreatedAt'] as String),
  cartItems: (json['CartItems'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: (json['TotalAmount'] as num).toDouble(),
);

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
  'CartId': instance.cartId,
  'UserId': instance.userId,
  'CreatedAt': instance.createdAt.toIso8601String(),
  'CartItems': instance.cartItems,
  'TotalAmount': instance.totalAmount,
};

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
  cartItemId: (json['CartItemId'] as num).toInt(),
  cartId: (json['CartId'] as num).toInt(),
  designId: (json['DesignId'] as num).toInt(),
  designName: json['DesignName'] as String,
  designImageUrl: json['DesignImageUrl'] as String,
  sizeId: (json['SizeId'] as num).toInt(),
  sizeLabel: json['SizeLabel'] as String,
  quantity: (json['Quantity'] as num).toInt(),
);

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'CartItemId': instance.cartItemId,
  'CartId': instance.cartId,
  'DesignId': instance.designId,
  'DesignName': instance.designName,
  'DesignImageUrl': instance.designImageUrl,
  'SizeId': instance.sizeId,
  'SizeLabel': instance.sizeLabel,
  'Quantity': instance.quantity,
};
