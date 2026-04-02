import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../widgets/shared_widgets.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  String? _selectedRole;

  void _continue() async {
    if (_selectedRole == null) return;
    await ref.read(authProvider.notifier).setRole(_selectedRole!);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text('Choose Your Role', style: AppTextStyles.headline2),
              const SizedBox(height: 48),
              Text(
                'Select how you want to use the app',
                style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              _RoleCard(
                icon: Icons.school_rounded,
                iconBg: const Color(0xFFEEF2FF),
                iconColor: AppColors.primary,
                title: 'Student',
                subtitle: 'Browse courses, learn new skills',
                isSelected: _selectedRole == 'student',
                onTap: () => setState(() => _selectedRole = 'student'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.cast_for_education_rounded,
                iconBg: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFE65100),
                title: 'Instructor',
                subtitle: 'Create courses, teach students, and earn',
                isSelected: _selectedRole == 'instructor',
                onTap: () => setState(() => _selectedRole = 'instructor'),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Continue',
                onTap: _selectedRole != null ? _continue : null,
                isDisabled: _selectedRole == null,
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
                  child: Text(
                    'Decide later',
                    style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: AppTextStyles.body2,
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: AppTextStyles.body2),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}
