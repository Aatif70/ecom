import 'order_model.dart';

class OrdersListResponse {
  final List<Order> data;
  final bool success;
  final String message;
  final List<dynamic> validationErrors;
  final int statusCode;
  final String timestamp;

  OrdersListResponse({
    required this.data,
    required this.success,
    required this.message,
    required this.validationErrors,
    required this.statusCode,
    required this.timestamp,
  });

  factory OrdersListResponse.fromJson(Map<String, dynamic> json) {
    return OrdersListResponse(
      data: (json['Data'] as List)
          .map((order) => Order.fromJson(order))
          .toList(),
      success: json['Success'],
      message: json['Message'],
      validationErrors: json['ValidationErrors'] ?? [],
      statusCode: json['StatusCode'],
      timestamp: json['Timestamp'],
    );
  }
}
