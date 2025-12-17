import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/user_profile.dart';
import '../../auth/provider/auth_provider.dart';
export '../../../shared/models/user_profile.dart';

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final response = await authService.getProfile();
  return response.data;
});

final updateProfileProvider = StateNotifierProvider<UpdateProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  return UpdateProfileNotifier(ref);
});

class UpdateProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final Ref ref;

  UpdateProfileNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> updateProfile(UpdateProfileRequest request) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.updateProfile(request);
      
      if (response.success && response.data != null) {
        state = AsyncValue.data(response.data);
        // Invalidate the profile provider to refresh the data
        ref.invalidate(userProfileProvider);
      } else {
        state = AsyncValue.error(
          Exception(response.message ?? 'Failed to update profile'),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
