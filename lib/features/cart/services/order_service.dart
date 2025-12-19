import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/provider/auth_provider.dart';
import '../models/order_model.dart';
import '../models/orders_list_model.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  final apiClient = ApiClient();
  final storageService = ref.read(storageServiceProvider);
  return OrderService(apiClient, storageService);
});

class OrderService {
  final ApiClient _apiClient;
  final StorageService _storageService;

  OrderService(this._apiClient, this._storageService);

  Future<Order> placeOrder() async {
    final token = await _storageService.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.orderEndpoint}');

    final response = await _apiClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final orderResponse = OrderResponse.fromJson(json);
      return orderResponse.data;
    } else {
      throw Exception('Failed to place order: ${response.statusCode}');
    }
  }

  Future<List<Order>> getMyOrders({int page = 1, int pageSize = 10}) async {
    final token = await _storageService.getToken();
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.myOrdersEndpoint}?page=$page&pageSize=$pageSize',
    );

    final response = await _apiClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final ordersResponse = OrdersListResponse.fromJson(json);
      return ordersResponse.data;
    } else {
      throw Exception('Failed to fetch orders: ${response.statusCode}');
    }
  }

  Future<void> cancelOrder(int orderId) async {
    final token = await _storageService.getToken();
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.myOrdersEndpoint}/$orderId/cancel',
    );

    final response = await _apiClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel order: ${response.statusCode}');
    }
  }
}
