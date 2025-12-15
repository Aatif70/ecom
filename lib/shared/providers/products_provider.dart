import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/mock_data_service.dart';
import '../models/product.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final service = ref.watch(mockDataServiceProvider);
  return service.getProducts();
});
