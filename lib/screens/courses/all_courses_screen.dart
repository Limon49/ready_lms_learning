import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../widgets/shared_widgets.dart';
import 'course_detail_screen.dart';
import 'filter_sheet.dart';

class AllCoursesScreen extends ConsumerWidget {
  const AllCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesState = ref.watch(coursesProvider);
    final filter = ref.watch(filterProvider);
    final filtered = filter.apply(coursesState.courses);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Courses'),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const FilterDrawer(),
            ),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: coursesState.isLoading
          ? GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,
              itemBuilder: (_, __) => const CourseCardShimmer(),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final course = filtered[i];
                final isWishlisted = ref.watch(wishlistProvider).contains(course.id);
                return CourseCard(
                  course: course,
                  isWishlisted: isWishlisted,
                  onWishlistToggle: () =>
                      ref.read(wishlistProvider.notifier).toggle(course.id),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CourseDetailScreen(course: course),
                  )),
                );
              },
            ),
    );
  }
}
