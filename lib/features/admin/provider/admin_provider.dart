import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/provider/auth_provider.dart'; // To access storage service via provider potentially or directly
import '../services/admin_service.dart';
import '../models/admin_models.dart';

final adminServiceProvider = Provider<AdminService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return AdminService(storageService);
});

// --- Brands ---

final brandsProvider = FutureProvider.autoDispose.family<List<Brand>, int>((ref, page) async {
  final adminService = ref.watch(adminServiceProvider);
  return adminService.getBrands(page, 10); // Default pageSize 10
});

class BrandController extends StateNotifier<AsyncValue<void>> {
  final AdminService _adminService;

  BrandController(this._adminService) : super(const AsyncData(null));

  Future<Map<String, dynamic>?> addBrand(String name, File imageFile) async {
    state = const AsyncLoading();
    try {
      final res = await _adminService.addBrand(name, imageFile);
      state = const AsyncData(null);
      return res;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

final brandControllerProvider = StateNotifierProvider<BrandController, AsyncValue<void>>((ref) {
  final adminService = ref.watch(adminServiceProvider);
  return BrandController(adminService);
});

// --- Categories ---

final categoriesProvider = FutureProvider.autoDispose.family<List<Category>, int>((ref, page) async {
  final adminService = ref.watch(adminServiceProvider);
  return adminService.getCategories(page, 10);
});

class CategoryController extends StateNotifier<AsyncValue<void>> {
  final AdminService _adminService;

  CategoryController(this._adminService) : super(const AsyncData(null));

  Future<void> addCategory(String name, File imageFile) async {
    state = const AsyncLoading();
    try {
      await _adminService.addCategory(name, imageFile);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final categoryControllerProvider = StateNotifierProvider<CategoryController, AsyncValue<void>>((ref) {
  final adminService = ref.watch(adminServiceProvider);
  return CategoryController(adminService);
});
