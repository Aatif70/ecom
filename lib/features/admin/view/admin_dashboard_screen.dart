import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/mock_data_service.dart';
import '../../catalog/view/home_screen.dart'; // Reusing productsProvider

import 'add_product_screen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Orders'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => context.go('/'),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            _ProductList(),
            _OrderList(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddProductScreen()),
            );
          },
          label: const Text('Add Product'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _ProductList extends ConsumerWidget {
  const _ProductList();
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsFuture = ref.watch(productsProvider);
    return productsFuture.when(
      data: (products) => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Image.network(product.images.first, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(product.title),
            subtitle: Text('SKU: ${product.sku} | Variants: ${product.variants.length}'),
            trailing: const Icon(Icons.edit),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _OrderList extends ConsumerWidget {
  const _OrderList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersFuture = ref.watch(mockDataServiceProvider).getOrders();
    
    return FutureBuilder(
      future: ordersFuture,
      builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
         }
         final orders = snapshot.data ?? [];
         return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                child: ListTile(
                  title: Text(order.orderId),
                  subtitle: Text('Qty: ${order.totalQty} | Status: ${order.status}'),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      // Update status mock
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'pending', child: Text('Mark Pending')),
                      const PopupMenuItem(value: 'shipped', child: Text('Mark Shipped')),
                      const PopupMenuItem(value: 'delivered', child: Text('Mark Delivered')),
                    ],
                  ),
                ),
              );
            },
         );
      }
    );
  }
}
