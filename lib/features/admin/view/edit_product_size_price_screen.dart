import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admin_models.dart';
import '../provider/admin_provider.dart';

class EditProductSizePriceScreen extends ConsumerStatefulWidget {
  final ProductSizePrice productSizePrice;
  const EditProductSizePriceScreen({super.key, required this.productSizePrice});

  @override
  ConsumerState<EditProductSizePriceScreen> createState() => _EditProductSizePriceScreenState();
}

class _EditProductSizePriceScreenState extends ConsumerState<EditProductSizePriceScreen> {
  late TextEditingController _priceController;
  late bool _isActive;
  late int _selectedDesignId;
  late int _selectedSizeId;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.productSizePrice.price.toString());
    _isActive = widget.productSizePrice.isActive;
    _selectedDesignId = widget.productSizePrice.designId;
    _selectedSizeId = widget.productSizePrice.sizeId;
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter price')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numeric price')),
      );
      return;
    }

    final res = await ref.read(productSizePriceControllerProvider.notifier).updateProductSizePrice(
      widget.productSizePrice.pspId,
      _selectedDesignId,
      _selectedSizeId,
      price,
      _isActive,
    );

    if (mounted) {
      if (res != null) {
        final message = res['Message'] ?? 'Product Size Price updated successfully';
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        Navigator.pop(context);
        // Note: The list screen should refresh on pop if set up correctly (e.g. using .then())
      } else {
        final state = ref.read(productSizePriceControllerProvider);
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product Size Price', style: TextStyle(color: Colors.red)),
        content: const Text(
          'Are you sure you want to delete this price configuration? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final error = await ref.read(productSizePriceControllerProvider.notifier)
          .deleteProductSizePrice(widget.productSizePrice.pspId);
      
      if (!mounted) return;

      if (error == null) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Product Size Price deleted successfully')),
        );
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Cannot Delete'),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productSizePriceControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Price'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Edit Price Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
             const SizedBox(height: 8),
            Text(
              "Modify price for ${widget.productSizePrice.designName} (${widget.productSizePrice.sizeName}).",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            
            const SizedBox(height: 32),

            // Design Dropdown
            ref.watch(allDesignsProvider).when(
              data: (designs) => DropdownButtonFormField<int>(
                isExpanded: true,
                value: designs.any((d) => d.id == _selectedDesignId) ? _selectedDesignId : null,
                decoration: InputDecoration(
                  labelText: 'Design',
                  prefixIcon: const Icon(Icons.design_services),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: designs.map((d) {
                   // Find first image if available
                   String? imageUrl;
                   if (d.images.isNotEmpty) imageUrl = d.images.first;

                   return DropdownMenuItem(
                    value: d.id,
                    child: Row(
                      children: [
                        if (imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(imageUrl, width: 24, height: 24, fit: BoxFit.cover, errorBuilder: (_,__,___) => const SizedBox(width: 24)),
                          )
                        else const SizedBox(width: 24),
                        const SizedBox(width: 12),
                        Expanded(child: Text(d.title, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDesignId = val);
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e,s) => Text('Error loading designs: $e'),
            ),

            const SizedBox(height: 16),

            // Size Dropdown
            ref.watch(allSizesProvider).when(
              data: (sizes) => DropdownButtonFormField<int>(
                isExpanded: true,
                value: sizes.any((s) => s.id == _selectedSizeId) ? _selectedSizeId : null,
                decoration: InputDecoration(
                  labelText: 'Size',
                  prefixIcon: const Icon(Icons.format_size),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: sizes.map((s) => DropdownMenuItem(
                  value: s.id,
                  child: Text(s.sizeLabel),
                )).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSizeId = val);
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e,s) => Text('Error loading sizes: $e'),
            ),

            const SizedBox(height: 24),

            // Editable Price
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Price',
                hintText: 'Enter price',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                 contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
             const SizedBox(height: 24),

             Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: SwitchListTile(
                title: const Text("Is Active"),
                subtitle: const Text("Enable this price configuration"),
                value: _isActive,
                onChanged: (val) {
                  setState(() {
                    _isActive = val;
                  });
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            
            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : _submit,
                 style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: Colors.blueAccent.withValues(alpha: 0.4),
                ),
                child: state.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Update Price',
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
             const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: state.isLoading ? null : _confirmDelete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Delete Price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
