import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/product.dart';
import '../../shared/models/order.dart';

final mockDataServiceProvider = Provider<MockDataService>((ref) {
  return MockDataService();
});

class MockDataService {
  List<Product>? _products;
  List<Order>? _orders;

  Future<void> _ensureProductsLoaded() async {
    if (_products != null) return;
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    final String response = await rootBundle.loadString('assets/mock_data/products.json');
    final List<dynamic> data = json.decode(response);
    _products = data.map((json) => Product.fromJson(json)).toList();
  }

  Future<void> _ensureOrdersLoaded() async {
    if (_orders != null) return;
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    final String response = await rootBundle.loadString('assets/mock_data/orders.json');
    final List<dynamic> data = json.decode(response);
    _orders = data.map((json) => Order.fromJson(json)).toList();
  }

  Future<List<Product>> getProducts() async {
    await _ensureProductsLoaded();
    return _products!;
  }

  Future<Product?> getProductById(String id) async {
    await _ensureProductsLoaded();
    return _products!.firstWhere((p) => p.id == id);
  }

  Future<List<Order>> getOrders() async {
    await _ensureOrdersLoaded();
    return _orders!;
  }
  
  Future<void> addProduct(Product product) async {
    await _ensureProductsLoaded();
    _products!.add(product);
  }

  Future<void> addOrder(Order order) async {
    await _ensureOrdersLoaded();
    _orders!.insert(0, order); // Add to top
  }
}
