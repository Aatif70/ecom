import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/admin_provider.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  ConsumerState<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends ConsumerState<AddCategoryScreen> {
  final _nameController = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submit() async {
    if (_nameController.text.isEmpty || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name and select an image')),
      );
      return;
    }

    final res = await ref.read(categoryControllerProvider.notifier).addCategory(
      _nameController.text,
      _imageFile!,
    );

    if (mounted) {
      if (res != null) {
        // Success
        final message = res['Message'] ?? 'Category added successfully';
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Success'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pop(context); // Close screen
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
        ref.invalidate(categoriesProvider(1));
      } else {
         // Error handled by state or propagated
         final state = ref.read(categoryControllerProvider);
         if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: state.isLoading ? null : _submit,
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
