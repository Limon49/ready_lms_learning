import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../widgets/shared_widgets.dart';
import '../courses/course_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _ctrl,
            focusNode: _focus,
            onChanged: (q) => ref.read(searchProvider.notifier).search(q),
            decoration: InputDecoration(
              hintText: 'Search courses...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
              suffixIcon: _ctrl.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _ctrl.clear();
                        ref.read(searchProvider.notifier).clear();
                      },
                      child: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
      body: searchState.query.isEmpty
          ? _SearchSuggestions()
          : searchState.results.isEmpty
              ? _EmptyResults(query: searchState.query)
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: searchState.results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, i) {
                    final course = searchState.results[i];
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

class _SearchSuggestions extends StatelessWidget {
  final _popular = ['UX Design', 'Python', 'Flutter', 'Web Design', 'React', 'Marketing'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popular Searches', style: AppTextStyles.headline3),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popular.map((s) => Chip(
              label: Text(s),
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border),
              labelStyle: AppTextStyles.body2,
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final String query;
  const _EmptyResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('No results for "$query"', style: AppTextStyles.headline3),
          const SizedBox(height: 8),
          Text('Try a different keyword', style: AppTextStyles.body2),
        ],
      ),
    );
  }
}
