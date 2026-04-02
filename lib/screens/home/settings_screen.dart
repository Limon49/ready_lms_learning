import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../services/hive_cache_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Text(
                    authState.userName.isNotEmpty
                        ? authState.userName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(authState.userName,
                          style: AppTextStyles.headline3.copyWith(fontSize: 16)),
                      Text(authState.userEmail, style: AppTextStyles.body2),
                      const SizedBox(height: 4),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          authState.role == 'instructor' ? 'Instructor' : 'Student',
                          style: AppTextStyles.label.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _SectionTitle(title: 'Account'),
          _SettingsTile(icon: Icons.person_outline_rounded, label: 'Edit Profile', onTap: () {}),
          _SettingsTile(icon: Icons.lock_outline_rounded, label: 'Change Password', onTap: () {}),
          _SettingsTile(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
          _SettingsTile(icon: Icons.language_rounded, label: 'Language', trailing: 'English', onTap: () {}),
          const SizedBox(height: 16),

          _SectionTitle(title: 'App'),
          _SettingsTile(icon: Icons.dark_mode_outlined, label: 'Dark Mode', onTap: () {}),
          _SettingsTile(icon: Icons.storage_outlined, label: 'Clear Cache', onTap: () async {
            await HiveCacheService.clearAll();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          }),
          _SettingsTile(icon: Icons.info_outline_rounded, label: 'About', onTap: () {}),
          const SizedBox(height: 16),

          _SectionTitle(title: 'Support'),
          _SettingsTile(icon: Icons.help_outline_rounded, label: 'Help Center', onTap: () {}),
          _SettingsTile(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () {}),
          _SettingsTile(icon: Icons.description_outlined, label: 'Terms of Service', onTap: () {}),
          const SizedBox(height: 24),

          // Logout
          GestureDetector(
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.error.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                  const SizedBox(width: 10),
                  Text('Log Out',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppColors.textPrimary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: AppTextStyles.body1),
            ),
            if (trailing != null) ...[
              Text(trailing!, style: AppTextStyles.body2),
              const SizedBox(width: 6),
            ],
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}
