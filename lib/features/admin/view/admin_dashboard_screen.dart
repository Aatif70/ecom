import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/admin_orders_provider.dart';
import '../models/admin_models.dart';


import 'brand_list_screen.dart';
import 'category_list_screen.dart';
import 'series_list_screen.dart';
import 'design_list_screen.dart';
import 'size_list_screen.dart';
import 'product_size_price_list_screen.dart';
import 'user_list_screen.dart';
import 'profile_screen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 8,
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
              Tab(text: 'Products'),
              Tab(text: 'Sizes'),
              Tab(text: 'Prices'),
              Tab(text: 'Users'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
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
            UserManagementScreen(),
          ],
        ),

      ),
    );
  }
}



class _OrderList extends ConsumerStatefulWidget {
  const _OrderList();

  @override
  ConsumerState<_OrderList> createState() => _OrderListState();
}

class _OrderListState extends ConsumerState<_OrderList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminOrdersProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminOrdersProvider);
    final notifier = ref.read(adminOrdersProvider.notifier);

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              'pending',
              'processing',
              'shipped',
              'delivered',
              'cancelled'
            ].map((status) {
              final isSelected = notifier.currentStatus == status;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(status.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      notifier.updateStatus(status);
                    }
                  },
                  backgroundColor: isSelected ? _getStatusColor(status) : null,
                  selectedColor: _getStatusColor(status),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: state.when(
            data: (orders) {
              if (orders.isEmpty) {
                return const Center(child: Text('No orders found'));
              }
              return RefreshIndicator(
                onRefresh: () => notifier.refresh(),
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      child: ExpansionTile(
                        title: Text(order.orderNumber,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('User: ${order.userName}'),
                            Text('Mobile: ${order.userMobile}'),
                            Text('Date: ${order.orderDate.toString().split('.')[0]}'),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Chip(label: Text('Qty: ${order.totalQty}')),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(order.status),
                                  backgroundColor: _getStatusColor(order.status),
                                ),
                              ],
                            ),
                          ],
                        ),
                        children: order.orderItems.map((item) {
                          return ListTile(
                            leading: item.designImageUrl.isNotEmpty
                                ? Image.network(item.designImageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, o, s) =>
                                        const Icon(Icons.image_not_supported))
                                : const Icon(Icons.image),
                            title: Text(item.designName),
                            subtitle: Text(
                                'Qty: ${item.totalQuantity} | Size: ${item.sizeDetails.map((e) => e.sizeName).join(', ')}'),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: SelectableText('Error: $e')),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade100;
      case 'processing':
        return Colors.blue.shade100;
      case 'shipped':
        return Colors.indigo.shade100;
      case 'delivered':
        return Colors.green.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}

