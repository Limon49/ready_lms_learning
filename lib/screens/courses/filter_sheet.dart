import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../widgets/shared_widgets.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  final _topics = ['Web Design', 'Graphics', 'Art & Media', 'Product Design'];
  final _tags = ['Popular', 'Free', 'Discounted', 'New', 'Denim'];
  double _minPrice = 0;
  double _maxPrice = 150;
  Set<String> _selectedTopics = {};
  Set<String> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    final filter = ref.read(filterProvider);
    _selectedTopics = filter.selectedTopics.toSet();
    _selectedTags = filter.selectedTags.toSet();
    _minPrice = filter.minPrice;
    _maxPrice = filter.maxPrice;
  }

  void _apply() {
    final notifier = ref.read(filterProvider.notifier);
    for (final topic in _selectedTopics) notifier.toggleTopic(topic);
    for (final tag in _selectedTags) notifier.toggleTag(tag);
    notifier.setPriceRange(_minPrice, _maxPrice);
    Navigator.of(context).pop();
  }

  void _reset() {
    setState(() {
      _selectedTopics = {};
      _selectedTags = {};
      _minPrice = 0;
      _maxPrice = 150;
    });
    ref.read(filterProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.arrow_back_rounded, size: 20),
                  const SizedBox(width: 12),
                  Text('Filter', style: AppTextStyles.headline3),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // By Topic
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('By Topic', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                  const Icon(Icons.keyboard_arrow_up_rounded),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _topics.map((topic) {
                  final selected = _selectedTopics.contains(topic);
                  return GestureDetector(
                    onTap: () => setState(() {
                      selected ? _selectedTopics.remove(topic) : _selectedTopics.add(topic);
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        topic,
                        style: TextStyle(
                          fontSize: 13,
                          color: selected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // More
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('More', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                  const Icon(Icons.keyboard_arrow_up_rounded),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  final selected = _selectedTags.contains(tag);
                  return GestureDetector(
                    onTap: () => setState(() {
                      selected ? _selectedTags.remove(tag) : _selectedTags.add(tag);
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.success : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? AppColors.success : AppColors.border,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 13,
                          color: selected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Price Range
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Price Range', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                  const Icon(Icons.keyboard_arrow_up_rounded),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('USD', style: AppTextStyles.body2),
                  Text('\$${_minPrice.toInt()}', style: AppTextStyles.body2),
                  Text('\$${_maxPrice.toInt()}', style: AppTextStyles.body2),
                ],
              ),
              RangeSlider(
                values: RangeValues(_minPrice, _maxPrice),
                min: 0,
                max: 150,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.border,
                onChanged: (values) => setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                }),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _reset,
                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                      child: const Text('Reset Filter'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
