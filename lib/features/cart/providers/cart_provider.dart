import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_model.dart';
import '../services/cart_service.dart';

final cartProvider = AsyncNotifierProvider<CartNotifier, Cart>(() {
  return CartNotifier();
});

class CartNotifier extends AsyncNotifier<Cart> {
  late final CartService _cartService;

  @override
  Future<Cart> build() async {
    _cartService = ref.read(cartServiceProvider);
    return _cartService.getCart();
  }

  Future<void> refreshCart() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _cartService.getCart());
  }

  Future<void> addToCart({
    required int designId,
    required int sizeId,
    required int quantity,
  }) async {
    // We don't set state to loading here to avoid full screen rebuilds if not desired, 
    // but ensuring UI feedback is handled by the caller or specialized state.
    // However, for consistency, let's keep the main cart state valid.
    await _cartService.addToCart(designId: designId, sizeId: sizeId, quantity: quantity);
    
    // Refresh cart to get updated totals and structure
    // We could optimize by appending the returned item, but TotalAmount would be stale.
    await refreshCart(); 
  }

  Future<void> updateQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    // Optimistic update could be complex with TotalAmount.
    // Simple approach: call API then refresh.
    await _cartService.updateCartItem(cartItemId: cartItemId, quantity: quantity);
    await refreshCart();
  }
}
