import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../shared/models/product.dart';
import '../../catalog/view/home_screen.dart'; // To refresh list

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _skuController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  
  // Mock image picker
  final List<String> _images = [
    "https://images.unsplash.com/photo-1583391733958-3771e05d9e5b?auto=format&fit=crop&w=800&q=80"
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _skuController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: const Uuid().v4(),
        sku: _skuController.text,
        title: _titleController.text,
        category: "NEW",
        description: _descController.text,
        images: _images,
        variants: [
          ProductVariant(size: "M", mrp: double.tryParse(_priceController.text) ?? 100, availableQty: 100),
          ProductVariant(size: "L", mrp: double.tryParse(_priceController.text) ?? 100, availableQty: 100),
        ],
        tags: ["new"],
        createdAt: DateTime.now(),
      );

      await ref.read(mockDataServiceProvider).addProduct(newProduct);
      
      // Refresh list
      ref.invalidate(productsProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Added')));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Product')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
             // Image Upload Mock
             Container(
               height: 150,
               decoration: BoxDecoration(
                 color: Colors.grey[200],
                 borderRadius: BorderRadius.circular(12),
               ),
               child: Center(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                     const SizedBox(height: 8),
                     Text('Tap to upload images (Mock)', style: Theme.of(context).textTheme.bodySmall),
                   ],
                 ),
               ),
             ),
             const SizedBox(height: 24),
             
             TextFormField(
               controller: _skuController,
               decoration: const InputDecoration(labelText: 'SKU'),
               validator: (v) => v!.isEmpty ? 'Required' : null,
             ),
             const SizedBox(height: 16),
             TextFormField(
               controller: _titleController,
               decoration: const InputDecoration(labelText: 'Product Title'),
               validator: (v) => v!.isEmpty ? 'Required' : null,
             ),
              const SizedBox(height: 16),
             TextFormField(
               controller: _descController,
               decoration: const InputDecoration(labelText: 'Description'),
               maxLines: 3,
             ),
              const SizedBox(height: 16),
             TextFormField(
               controller: _priceController,
               decoration: const InputDecoration(labelText: 'Base Price (MRP)'),
               keyboardType: TextInputType.number,
               validator: (v) => v!.isEmpty ? 'Required' : null,
             ),
             
             const SizedBox(height: 32),
             ElevatedButton(
               onPressed: _saveProduct,
               child: const Text('Save Product'),
             ),
          ],
        ),
      ),
    );
  }
}
