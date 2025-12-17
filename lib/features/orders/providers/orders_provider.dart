import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/models/order_model.dart';
import '../../cart/services/order_service.dart';


final ordersListProvider = FutureProvider<List<Order>>((ref) async {
  final orderService = ref.read(orderServiceProvider);
  return orderService.getMyOrders();
});

final ordersNotifierProvider = StateNotifierProvider<OrdersNotifier, AsyncValue<List<Order>>>((ref) {
  final orderService = ref.read(orderServiceProvider);
  return OrdersNotifier(orderService);
});

class OrdersNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final OrderService _orderService;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;

  OrdersNotifier(this._orderService) : super(const AsyncValue.loading()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _orderService.getMyOrders(page: _currentPage, pageSize: _pageSize);
    });
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    await loadOrders();
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    
    state.whenData((currentOrders) async {
      _currentPage++;
      try {
        final newOrders = await _orderService.getMyOrders(page: _currentPage, pageSize: _pageSize);
        if (newOrders.isEmpty) {
          _hasMore = false;
        } else {
          state = AsyncValue.data([...currentOrders, ...newOrders]);
        }
      } catch (e, st) {
        _currentPage--; // Revert page increment on error
        state = AsyncValue.error(e, st);
      }
    });
  }
}
