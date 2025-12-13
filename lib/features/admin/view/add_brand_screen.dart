import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/admin_provider.dart';

class AddBrandScreen extends ConsumerStatefulWidget {
  const AddBrandScreen({super.key});

  @override
  ConsumerState<AddBrandScreen> createState() => _AddBrandScreenState();
}

class _AddBrandScreenState extends ConsumerState<AddBrandScreen> {
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

    await ref.read(brandControllerProvider.notifier).addBrand(
      _nameController.text,
      _imageFile!,
    );

    // Check state for success/error
    // Ideally use ref.listen in build, but simple await/check assumes success if no error thrown in controller
    // With AsyncValue in controller:
    final state = ref.read(brandControllerProvider);
    if (state.hasError) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
       }
    } else {
      if (mounted) {
        Navigator.pop(context);
        // Refresh list logic usually handled by simple auto-dispose or invalidation
        ref.invalidate(brandsProvider(1)); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brandControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Brand')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Brand Name'),
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
                  : const Text('Add Brand'),
            ),
          ],
        ),
      ),
    );
  }
}
