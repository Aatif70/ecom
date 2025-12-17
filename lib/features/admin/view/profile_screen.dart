import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/provider/auth_provider.dart';
import '../../auth/provider/profile_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final userProfile = profileState.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileState.error != null
              ? Center(child: Text('Error: ${profileState.error}'))
              : userProfile == null
                  ? const Center(child: Text('No profile data found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder or actual image if available
                             // If you have a specific avatar URL structure or asset, replace this.
                          ),
                          const SizedBox(height: 24),
                          Text(
                            userProfile.fullName ?? 'No Name',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userProfile.email ?? 'No Email',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 32),
                          _buildProfileItem(Icons.phone, 'Mobile', userProfile.mobile ?? 'N/A'),
                          _buildProfileItem(Icons.store, 'Shop Name', userProfile.shopName ?? 'N/A'),
                          _buildProfileItem(Icons.location_on, 'Address', userProfile.address ?? 'N/A'),
                          _buildProfileItem(Icons.receipt_long, 'GST', userProfile.gst ?? 'N/A'),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await ref.read(authProvider.notifier).logout();
                                if (context.mounted) {
                                  context.go('/login');
                                }
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text('Logout'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
