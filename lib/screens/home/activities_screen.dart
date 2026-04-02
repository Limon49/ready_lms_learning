import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../data/mock_data.dart';
import '../../widgets/shared_widgets.dart';
import '../courses/course_detail_screen.dart';

class ActivitiesScreen extends ConsumerWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrolledIds = ref.watch(enrollmentProvider);
    final wishlistIds = ref.watch(wishlistProvider);

    final enrolledCourses = MockData.courses
        .where((c) => enrolledIds.contains(c.id))
        .toList();
    final wishlistedCourses = MockData.courses
        .where((c) => wishlistIds.contains(c.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Activities')),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: AppColors.surface,
              child: const TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: 'Enrolled'),
                  Tab(text: 'Wishlist'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _CourseList(
                    courses: enrolledCourses,
                    emptyMessage: 'No enrolled courses yet',
                    emptyIcon: Icons.school_outlined,
                  ),
                  _CourseList(
                    courses: wishlistedCourses,
                    emptyMessage: 'No wishlisted courses yet',
                    emptyIcon: Icons.favorite_outline_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseList extends ConsumerWidget {
  final List courses;
  final String emptyMessage;
  final IconData emptyIcon;

  const _CourseList({
    required this.courses,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(emptyMessage, style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: courses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) {
        final course = courses[i];
        final isWishlisted = ref.watch(wishlistProvider).contains(course.id);
        return CourseCard(
          course: course,
          isWishlisted: isWishlisted,
          onWishlistToggle: () => ref.read(wishlistProvider.notifier).toggle(course.id),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
          ),
        );
      },
    );
  }
}
