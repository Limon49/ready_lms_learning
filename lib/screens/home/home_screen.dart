import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/course.dart';
import '../../data/mock_data.dart';
import '../courses/course_detail_screen.dart';
import '../courses/filter_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final coursesState = ref.watch(coursesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(coursesProvider.notifier).refresh(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: Text(
                          authState.userName.isNotEmpty ? authState.userName[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${authState.userName}',
                              style: AppTextStyles.headline3.copyWith(fontSize: 16),
                            ),
                            Text(
                              'Browse or search your courses.',
                              style: AppTextStyles.body2,
                            ),
                          ],
                        ),
                      ),
                      _IconButton(
                        icon: Icons.shopping_cart_outlined,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _IconButton(
                        icon: Icons.notifications_outlined,
                        onTap: () {},
                        hasNotif: true,
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed('/search'),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: AppColors.textHint, size: 20),
                                const SizedBox(width: 10),
                                Text('Search', style: AppTextStyles.body1.copyWith(color: AppColors.textHint)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const FilterSheet(),
                        ),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.tune_rounded, color: AppColors.textPrimary, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Discount Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _DiscountBanner(),
                ),
              ),

              // Top Rated Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                  child: SectionHeader(
                    title: 'Top Rated Courses',
                    onSeeMore: () => Navigator.of(context).pushNamed('/courses'),
                  ),
                ),
              ),

              // Category Filter
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: MockData.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final cat = MockData.categories[i];
                      final isSelected =
                          coursesState.selectedCategory == cat;
                      return CategoryChip(
                        label: cat,
                        isSelected: isSelected,
                        onTap: () => ref
                            .read(coursesProvider.notifier)
                            .selectCategory(cat),
                      );
                    },
                  ),
                ),
              ),

              // Top Rated Courses List
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 270,
                  child: coursesState.isLoading
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          itemCount: 3,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (_, __) => const SizedBox(
                            width: 220,
                            child: CourseCardShimmer(),
                          ),
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          itemCount: ref.read(coursesProvider.notifier).topRatedCourses.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (_, i) {
                            final courses = ref.read(coursesProvider.notifier).topRatedCourses;
                            final course = courses[i];
                            final isWishlisted = ref.watch(wishlistProvider).contains(course.id);
                            return SizedBox(
                              width: 220,
                              child: CourseCard(
                                course: course,
                                isWishlisted: isWishlisted,
                                onWishlistToggle: () =>
                                    ref.read(wishlistProvider.notifier).toggle(course.id),
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => CourseDetailScreen(course: course),
                                )),
                              ),
                            );
                          },
                        ),
                ),
              ),

              // Free Courses Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                  child: SectionHeader(
                    title: 'Free Courses',
                    onSeeMore: () {},
                  ),
                ),
              ),

              // Category Filter for Free
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: MockData.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final cat = MockData.categories[i];
                      return CategoryChip(
                        label: cat,
                        isSelected: i == 1,
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ),

              // Free Courses List
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 270,
                  child: coursesState.isLoading
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          itemCount: 3,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (_, __) =>
                              const SizedBox(width: 220, child: CourseCardShimmer()),
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          itemCount: ref.read(coursesProvider.notifier).freeCourses.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (_, i) {
                            final courses = ref.read(coursesProvider.notifier).freeCourses;
                            final course = courses[i];
                            final isWishlisted = ref.watch(wishlistProvider).contains(course.id);
                            return SizedBox(
                              width: 220,
                              child: CourseCard(
                                course: course,
                                isWishlisted: isWishlisted,
                                onWishlistToggle: () =>
                                    ref.read(wishlistProvider.notifier).toggle(course.id),
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => CourseDetailScreen(course: course),
                                )),
                              ),
                            );
                          },
                        ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasNotif;

  const _IconButton({required this.icon, required this.onTap, this.hasNotif = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
          if (hasNotif)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DiscountBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.bannerGradientStart, AppColors.bannerGradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Discounted Courses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Discount 50% for the first purchases',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Purchase Now',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Illustration placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school_rounded, color: Colors.white, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}
