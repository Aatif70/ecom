import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/provider/auth_provider.dart';
import '../models/cart_model.dart';

final cartServiceProvider = Provider<CartService>((ref) {
  final apiClient = ApiClient();
  final authService = ref.read(authServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return CartService(apiClient, authService, storageService);
});

class CartService {
  final ApiClient _apiClient;
  final AuthService _authService;
  final StorageService _storageService;

  CartService(this._apiClient, this._authService, this._storageService);

  Future<CartItem> addToCart({
    required int designId,
    required int sizeId,
    required int quantity,
  }) async {
    final token = await _storageService.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartItemsEndpoint}');

    final response = await _apiClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'DesignId': designId,
        'SizeId': sizeId,
        'Quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final cartItemResponse = CartItemResponse.fromJson(json);
      return cartItemResponse.data;
    } else {
      throw Exception('Failed to add item to cart: ${response.statusCode}');
    }
  }

  Future<Cart> getCart() async {
    final token = await _storageService.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartEndpoint}');

    final response = await _apiClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final cartResponse = CartResponse.fromJson(json);
      return cartResponse.data;
    } else {
      throw Exception('Failed to retrieve cart: ${response.statusCode}');
    }
  }

  Future<void> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) async {
    final token = await _storageService.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartItemsEndpoint}/$cartItemId');

    final response = await _apiClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'Quantity': quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart item: ${response.statusCode}');
    }
  }
}
