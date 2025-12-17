import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/profile_provider.dart';
import '../../../features/auth/provider/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userProfileProvider);
          await ref.read(userProfileProvider.future);
        },
        child: CustomScrollView(
          slivers: [
            // Modern AppBar with gradient
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: profileAsync.when(
                      data: (profile) => profile != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                // Avatar
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      profile.fullName?.substring(0, 1).toUpperCase() ?? 'U',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ).animate().scale(duration: 600.ms),
                                const SizedBox(height: 12),
                                Text(
                                  profile.fullName ?? 'User',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ).animate().fadeIn(duration: 400.ms),
                                const SizedBox(height: 4),
                                Text(
                                  profile.email ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                              ],
                            )
                          : const SizedBox.shrink(),
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),

            // Profile Content
            SliverToBoxAdapter(
              child: profileAsync.when(
                data: (profile) {
                  if (profile == null) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No profile data available'),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Information Card
                        _buildSectionCard(
                          context,
                          title: 'Profile Information',
                          icon: Icons.person_outline,
                          child: Column(
                            children: [
                              _buildInfoRow(
                                context,
                                icon: Icons.person,
                                label: 'Full Name',
                                value: profile.fullName ?? 'N/A',
                              ),
                              const Divider(height: 24),
                              _buildInfoRow(
                                context,
                                icon: Icons.email,
                                label: 'Email',
                                value: profile.email ?? 'N/A',
                              ),
                              const Divider(height: 24),
                              _buildInfoRow(
                                context,
                                icon: Icons.phone,
                                label: 'Mobile',
                                value: profile.mobile ?? 'N/A',
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),

                        const SizedBox(height: 16),

                        // Business Information Card
                        _buildSectionCard(
                          context,
                          title: 'Business Information',
                          icon: Icons.business_outlined,
                          child: Column(
                            children: [
                              _buildInfoRow(
                                context,
                                icon: Icons.store,
                                label: 'Shop Name',
                                value: profile.shopName ?? 'N/A',
                              ),
                              const Divider(height: 24),
                              _buildInfoRow(
                                context,
                                icon: Icons.location_on,
                                label: 'Address',
                                value: profile.address ?? 'N/A',
                              ),
                              const Divider(height: 24),
                              _buildInfoRow(
                                context,
                                icon: Icons.receipt_long,
                                label: 'GST Number',
                                value: profile.gst ?? 'N/A',
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: -0.1, end: 0),

                        const SizedBox(height: 16),

                        // Orders Section (Placeholder)
                        _buildSectionCard(
                          context,
                          title: 'My Orders',
                          icon: Icons.shopping_bag_outlined,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                title: const Text('View All Orders'),
                                subtitle: const Text('Track your order history'),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                onTap: () {
                                  // Navigate to orders screen
                                  context.go('/orders');
                                },
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: -0.1, end: 0),

                        const SizedBox(height: 16),

                        // Action Buttons
                        _buildActionButton(
                          context,
                          icon: Icons.edit_outlined,
                          label: 'Edit Profile',
                          onTap: () {
                            _showEditProfileDialog(context, ref, profile);
                          },
                        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                        const SizedBox(height: 12),

                        _buildActionButton(
                          context,
                          icon: Icons.logout,
                          label: 'Logout',
                          color: Colors.red,
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text('Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Logout', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && context.mounted) {
                              await ref.read(authProvider.notifier).logout();
                              if (context.mounted) {
                                context.go('/login');
                              }
                            }
                          },
                        ).animate().fadeIn(duration: 400.ms, delay: 400.ms),

                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: $error'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(userProfileProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final buttonColor = color ?? Theme.of(context).primaryColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: buttonColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: buttonColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: buttonColor,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: buttonColor),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, dynamic profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: profile),
      ),
    );
  }
}

class EditProfileScreen extends ConsumerStatefulWidget {
  final dynamic profile;

  const EditProfileScreen({required this.profile, super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _shopNameController;
  late TextEditingController _addressController;
  late TextEditingController _gstController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.profile.fullName ?? '');
    _emailController = TextEditingController(text: widget.profile.email ?? '');
    _mobileController = TextEditingController(text: widget.profile.mobile ?? '');
    _shopNameController = TextEditingController(text: widget.profile.shopName ?? '');
    _addressController = TextEditingController(text: widget.profile.address ?? '');
    _gstController = TextEditingController(text: widget.profile.gst ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _shopNameController.dispose();
    _addressController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _fullNameController,
              label: 'Full Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _mobileController,
              label: 'Mobile',
              icon: Icons.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _shopNameController,
              label: 'Shop Name',
              icon: Icons.store,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              icon: Icons.location_on,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _gstController,
              label: 'GST Number',
              icon: Icons.receipt_long,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: updateState.isLoading
                    ? null
                    : () async {
                        final request = UpdateProfileRequest(
                          fullName: _fullNameController.text,
                          email: _emailController.text,
                          mobile: _mobileController.text,
                          shopName: _shopNameController.text,
                          address: _addressController.text,
                          gst: _gstController.text,
                        );

                        await ref.read(updateProfileProvider.notifier).updateProfile(request);

                        if (mounted) {
                          final state = ref.read(updateProfileProvider);
                          state.when(
                            data: (data) {
                              if (data != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profile updated successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            loading: () {},
                            error: (error, _) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $error'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          );
                        }
                      },
                child: updateState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
