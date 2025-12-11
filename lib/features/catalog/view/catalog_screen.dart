import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../shared/models/product.dart';
import '../../../shared/widgets/product_card.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  final String? initialCategory;
  const CatalogScreen({super.key, this.initialCategory});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = ['AFGHANI', 'KURTI', 'PLAZZO', 'GOWN', 'LEHENGA'];

  @override
  void initState() {
    super.initState();
    int initialIndex = 0;
    if (widget.initialCategory != null) {
      initialIndex = categories.indexOf(widget.initialCategory!);
      if (initialIndex == -1) initialIndex = 0;
    }
    _tabController = TabController(length: categories.length, initialIndex: initialIndex, vsync: this);
  }

  @override
  void didUpdateWidget(CatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory && widget.initialCategory != null) {
      final index = categories.indexOf(widget.initialCategory!);
      if (index != -1) {
        _tabController.animateTo(index);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsFuture = ref.watch(mockDataServiceProvider).getProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((c) => Tab(text: c)).toList(),
        ),
         actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading catalog'));
          }

          final allProducts = snapshot.data ?? [];

          return TabBarView(
            controller: _tabController,
            children: categories.map((category) {
              final categoryProducts = allProducts.where((p) => p.category == category).toList();
              
              if (categoryProducts.isEmpty) {
                return Center(child: Text("No products in $category"));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categoryProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: categoryProducts[index]);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
