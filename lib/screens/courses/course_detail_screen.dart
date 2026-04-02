import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../models/course.dart';
import '../../providers/providers.dart';
import '../../widgets/shared_widgets.dart';

class CourseDetailScreen extends ConsumerWidget {
  final Course course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWishlisted = ref.watch(wishlistProvider).contains(course.id);
    final isEnrolled = ref.watch(enrollmentProvider).contains(course.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => ref.read(wishlistProvider.notifier).toggle(course.id),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isWishlisted ? AppColors.accent : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                course.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.border,
                  child: const Icon(Icons.image_outlined, size: 60, color: AppColors.textHint),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(course.category, style: AppTextStyles.label),
                        ),
                        if (course.isNew) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('NEW',
                                style: AppTextStyles.label.copyWith(color: AppColors.secondary)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(course.title, style: AppTextStyles.headline2),
                    const SizedBox(height: 16),
                    // Instructor row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: Text(
                            course.instructor[0],
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(course.instructor, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500)),
                        const Spacer(),
                        const Icon(Icons.star_rounded, color: AppColors.starColor, size: 16),
                        const SizedBox(width: 4),
                        Text('${course.rating}', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                        Text(' (${course.reviewCount} reviews)', style: AppTextStyles.body2),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Stats
                    Row(
                      children: [
                        _StatChip(icon: Icons.access_time_rounded, label: '${course.durationHours} hours'),
                        const SizedBox(width: 16),
                        _StatChip(icon: Icons.people_rounded, label: '${course.studentsCount} students'),
                        const SizedBox(width: 16),
                        _StatChip(icon: Icons.play_lesson_rounded, label: '${course.lessons.length} lessons'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // About
                    Text('About This Course', style: AppTextStyles.headline3),
                    const SizedBox(height: 8),
                    Text(course.description, style: AppTextStyles.body1),
                    const SizedBox(height: 24),
                    // Curriculum
                    Text('Curriculum', style: AppTextStyles.headline3),
                    const SizedBox(height: 12),
                    ...course.lessons.asMap().entries.map((e) => _LessonItem(
                          index: e.key + 1,
                          title: e.value,
                        )),
                    const SizedBox(height: 32),
                    // Price + Enroll
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price', style: AppTextStyles.caption),
                            Text(
                              course.isFree ? 'Free' : '\$${course.price.toStringAsFixed(2)}',
                              style: AppTextStyles.headline2.copyWith(
                                color: course.isFree ? AppColors.success : AppColors.primary,
                              ),
                            ),
                            if (course.originalPrice != null)
                              Text(
                                '\$${course.originalPrice!.toStringAsFixed(0)}',
                                style: AppTextStyles.body2.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: PrimaryButton(
                            label: isEnrolled ? '✓ Enrolled' : (course.isFree ? 'Enroll Free' : 'Enroll Now'),
                            onTap: () async {
                              if (!isEnrolled) {
                                await ref.read(enrollmentProvider.notifier).enroll(course.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Enrolled in ${course.title}!'),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _LessonItem extends StatelessWidget {
  final int index;
  final String title;
  const _LessonItem({required this.index, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$index',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.play_circle_outline_rounded, color: AppColors.primary, size: 20),
        ],
      ),
    );
  }
}
