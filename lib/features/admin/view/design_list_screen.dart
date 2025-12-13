import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../provider/admin_provider.dart';
import '../models/admin_models.dart';
import 'add_design_screen.dart';

class DesignListScreen extends ConsumerWidget {
  const DesignListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designsAsync = ref.watch(designsProvider(1));

    return Scaffold(
      body: designsAsync.when(
        data: (designs) => RefreshIndicator(
          onRefresh: () async {
             ref.refresh(designsProvider(1));
          },
          child: designs.isEmpty 
          ? const Center(child: Text('No Designs Found'))
          : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: designs.length,
            itemBuilder: (context, index) {
              final design = designs[index];
              return _DesignItem(design: design, index: index);
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDesignScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DesignItem extends StatelessWidget {
  final Design design;
  final int index;

  const _DesignItem({required this.design, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    design.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (design.isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Text('NEW', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Design #: ${design.designNumber}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildTag(Icons.branding_watermark, design.brandName),
                _buildTag(Icons.category, design.categoryName),
                _buildTag(Icons.layers, design.seriesName),
              ],
            )
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0, delay: (50 * index).ms);
  }

  Widget _buildTag(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.blueAccent),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.blueAccent, fontSize: 11)),
        ],
      ),
    );
  }
}
