// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  orderId: json['order_id'] as String,
  date: DateTime.parse(json['date'] as String),
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalQty: (json['total_qty'] as num).toInt(),
  pendingQty: (json['pending_qty'] as num).toInt(),
  status: json['status'] as String,
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'order_id': instance.orderId,
  'date': instance.date.toIso8601String(),
  'items': instance.items,
  'total_qty': instance.totalQty,
  'pending_qty': instance.pendingQty,
  'status': instance.status,
};

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  productId: json['product_id'] as String,
  size: json['size'] as String,
  qty: (json['qty'] as num).toInt(),
  unitPrice: (json['unit_price'] as num).toDouble(),
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'product_id': instance.productId,
  'size': instance.size,
  'qty': instance.qty,
  'unit_price': instance.unitPrice,
};
