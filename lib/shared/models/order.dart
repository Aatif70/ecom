import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  @JsonKey(name: 'order_id')
  final String orderId;
  final DateTime date;
  final List<OrderItem> items;
  @JsonKey(name: 'total_qty')
  final int totalQty;
  @JsonKey(name: 'pending_qty')
  final int pendingQty;
  final String status; // pending, processed, shipped, delivered

  Order({
    required this.orderId,
    required this.date,
    required this.items,
    required this.totalQty,
    required this.pendingQty,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class OrderItem {
  @JsonKey(name: 'product_id')
  final String productId;
  final String size;
  final int qty;
  @JsonKey(name: 'unit_price')
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.size,
    required this.qty,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
