import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../theme.dart';

class FilterDrawer extends ConsumerStatefulWidget {
  const FilterDrawer({super.key});

  @override
  ConsumerState<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends ConsumerState<FilterDrawer> {
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
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {}, // absorb taps inside drawer
        child: Material(
          color: AppColors.surface,
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
          child: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.82,
              height: double.infinity,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.close_rounded),
                        ),
                        const SizedBox(width: 12),
                        Text('Filter', style: AppTextStyles.headline3),
                      ],
                    ),
                  ),
                  const Divider(height: 28),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // By Topic
                          _SectionLabel(title: 'By Topic'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _topics.map((topic) {
                              final selected = _selectedTopics.contains(topic);
                              return _FilterChip(
                                label: topic,
                                isSelected: selected,
                                selectedColor: AppColors.primary,
                                onTap: () => setState(() {
                                  selected
                                      ? _selectedTopics.remove(topic)
                                      : _selectedTopics.add(topic);
                                }),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // More
                          _SectionLabel(title: 'More'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _tags.map((tag) {
                              final selected = _selectedTags.contains(tag);
                              return _FilterChip(
                                label: tag,
                                isSelected: selected,
                                selectedColor: AppColors.success,
                                onTap: () => setState(() {
                                  selected
                                      ? _selectedTags.remove(tag)
                                      : _selectedTags.add(tag);
                                }),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Price Range
                          _SectionLabel(title: 'Price Range'),
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
                                  child: const Text('Reset'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _apply,
                                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                                  child: const Text('Apply'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
        const Icon(Icons.keyboard_arrow_up_rounded),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? selectedColor : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}