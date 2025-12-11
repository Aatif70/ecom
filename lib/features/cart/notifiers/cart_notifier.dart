import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/product.dart';

// Simple Cart Item model
class CartItem {
  final Product product;
  final ProductVariant variant;
  final int quantity;

  CartItem({
    required this.product,
    required this.variant,
    required this.quantity,
  });

  double get totalPrice => variant.mrp * quantity;
}

// Cart Notifier
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product, ProductVariant variant, int quantity) {
    // Check if item already exists
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id && item.variant.size == variant.size,
    );

    if (existingIndex != -1) {
      // Update quantity
      final existingItem = state[existingIndex];
      final newQuantity = existingItem.quantity + quantity;
      
      final newState = [...state];
      newState[existingIndex] = CartItem(
        product: product,
        variant: variant,
        quantity: newQuantity,
      );
      state = newState;
    } else {
      // Add new item
      state = [
        ...state,
        CartItem(product: product, variant: variant, quantity: quantity),
      ];
    }
  }

  void removeFromCart(CartItem item) {
    state = state.where((i) => i != item).toList();
  }

  void clearCart() {
    state = [];
  }

  double get totalAmount => state.fold(0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
