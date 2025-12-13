import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/admin_provider.dart';
import 'add_brand_screen.dart';

class BrandListScreen extends ConsumerWidget {
  const BrandListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Basic pagination mock - just loading page 1 for now
    final brandsAsync = ref.watch(brandsProvider(1));

    return Scaffold(
      body: brandsAsync.when(
        data: (brands) => ListView.builder(
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];
            return ListTile(
              leading: brand.logoUrl != null
                  ? Image.network(brand.logoUrl!, width: 50, height: 50, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image))
                  : const Icon(Icons.branding_watermark),
              title: Text(brand.name),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBrandScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
