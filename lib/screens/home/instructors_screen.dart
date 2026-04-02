import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../data/mock_data.dart';
import '../../models/course.dart';

class InstructorsScreen extends ConsumerWidget {
  const InstructorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Instructors')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: MockData.instructors.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) {
          final instructor = MockData.instructors[i];
          return _InstructorCard(instructor: instructor);
        },
      ),
    );
  }
}

class _InstructorCard extends StatelessWidget {
  final Instructor instructor;
  const _InstructorCard({required this.instructor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(instructor.avatarUrl),
            onBackgroundImageError: (_, __) {},
            backgroundColor: AppColors.border,
            child: Text(instructor.name[0], style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(instructor.name,
                    style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                Text(instructor.specialty, style: AppTextStyles.body2),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.starColor, size: 14),
                    Text(' ${instructor.rating}', style: AppTextStyles.caption),
                    const SizedBox(width: 12),
                    const Icon(Icons.people_rounded, size: 14, color: AppColors.textSecondary),
                    Text(' ${instructor.studentsCount}', style: AppTextStyles.caption),
                    const SizedBox(width: 12),
                    const Icon(Icons.play_lesson_rounded, size: 14, color: AppColors.textSecondary),
                    Text(' ${instructor.coursesCount} courses', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Follow',
                style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
