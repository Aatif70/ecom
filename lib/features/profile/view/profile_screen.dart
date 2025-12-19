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
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: profileAsync.when(
                        data: (profile) => profile != null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 88,
                                      height: 88,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.15),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        border: Border.all(color: Colors.white, width: 3),
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
                                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                                    const SizedBox(height: 16),
                                    Text(
                                      profile.fullName ?? 'User',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3, end: 0),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        profile.email ?? '',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Content
            SliverToBoxAdapter(
              child: profileAsync.when(
                data: (profile) {
                  if (profile == null) {
                    return const Center(child: Text('No profile data available'));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Business Information Card (Moved up as it's often more important for sellers)
                        _buildSectionCard(
                          context,
                          title: 'Business Details',
                          icon: Icons.store_rounded,
                          child: Column(
                            children: [
                              _buildInfoRow(
                                context,
                                icon: Icons.store,
                                label: 'Shop Name',
                                value: profile.shopName ?? 'Not set',
                                isHighlight: true,
                              ),
                              const Divider(height: 32),
                              _buildInfoRow(
                                context,
                                icon: Icons.location_on,
                                label: 'Location',
                                value: profile.address ?? 'Not set',
                              ),
                              const Divider(height: 32),
                              _buildInfoRow(
                                context,
                                icon: Icons.receipt_long,
                                label: 'GST Number',
                                value: profile.gst ?? 'Not set',
                                isMonospace: true,
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0),

                        const SizedBox(height: 20),

                        // Personal Information Card
                        _buildSectionCard(
                          context,
                          title: 'Personal Info',
                          icon: Icons.person_rounded,
                          child: Column(
                            children: [
                              _buildInfoRow(
                                context,
                                icon: Icons.phone_android,
                                label: 'Mobile Number',
                                value: profile.mobile ?? 'Not set',
                              ),
                              const Divider(height: 32),
                              _buildInfoRow(
                                context,
                                icon: Icons.email_outlined,
                                label: 'Email Address',
                                value: profile.email ?? 'Not set',
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: -0.05, end: 0),

                        const SizedBox(height: 20),

                        // My Orders Feature Card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => context.go('/orders'),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'My Orders',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Track current and past orders',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: -0.05, end: 0),

                        const SizedBox(height: 32),

                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showEditProfileDialog(context, ref, profile),
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                label: const Text('Edit Profile'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  foregroundColor: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Logout'),
                                      content: const Text('Are you sure you want to logout?'),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        FilledButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.red[50],
                                            foregroundColor: Colors.red,
                                          ),
                                          child: const Text('Logout'),
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
                                icon: const Icon(Icons.logout, size: 18),
                                label: const Text('Logout'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: Colors.red.shade100),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  foregroundColor: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
    bool isMonospace = false,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isHighlight
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 22,
            color: isHighlight ? Theme.of(context).primaryColor : Colors.grey[600],
          ),
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
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
                  color: Colors.black87,
                  fontFamily: isMonospace ? 'Courier New' : null,
                  fontFamilyFallback: isMonospace ? const ['monospace'] : null,
                ),
              ),
            ],
          ),
        ),
      ],
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
      backgroundColor: Colors.grey[50], 
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    icon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Business Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _shopNameController,
                    label: 'Shop Name',
                    icon: Icons.store_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Shop Address',
                    icon: Icons.location_on_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _gstController,
                    label: 'GST Number',
                    icon: Icons.receipt_long_outlined,
                    textCapitalization: TextCapitalization.characters,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
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
                                    behavior: SnackBarBehavior.floating,
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
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );
                        }
                      },
                style: FilledButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: updateState.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
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
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 22, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black87, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: Colors.grey[600]),
        floatingLabelStyle: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
