import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/mock_data_service.dart';
import '../../auth/provider/auth_provider.dart';

import 'brand_list_screen.dart';
import 'category_list_screen.dart';
import 'series_list_screen.dart';
import 'design_list_screen.dart';

import 'size_list_screen.dart';
import 'product_size_price_list_screen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [

              Tab(text: 'Orders'),
              Tab(text: 'Brands'),
              Tab(text: 'Categories'),
              Tab(text: 'Series'),
              Tab(text: 'Designs'),
              Tab(text: 'Sizes'),
              Tab(text: 'Prices'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                 await ref.read(authProvider.notifier).logout();
                 if (context.mounted) {
                   context.go('/login');
                 }
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [

            _OrderList(),
            BrandListScreen(),
            CategoryListScreen(),
            SeriesListScreen(),
            DesignListScreen(),
            SizeListScreen(),
            ProductSizePriceListScreen(),
          ],
        ),

      ),
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

