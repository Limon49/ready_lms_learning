import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/course.dart';

// ─── App Logo ─────────────────────────────────────────────────────
class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 48,
    this.showText = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.white;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: c.withOpacity(0.2),
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          child: Center(
            child: CustomPaint(
              size: Size(size * 0.6, size * 0.6),
              painter: _LogoPainter(color: c),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 8),
          Text('Ready LMS',
              style: TextStyle(color: c, fontSize: 20, fontWeight: FontWeight.w700)),
          Text('Where Learning Meets Growth',
              style: TextStyle(color: c.withOpacity(0.7), fontSize: 12)),
        ],
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color color;
  _LogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Graduation cap
    final capPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.15)
      ..lineTo(size.width * 0.05, size.height * 0.38)
      ..lineTo(size.width * 0.5, size.height * 0.55)
      ..lineTo(size.width * 0.95, size.height * 0.38)
      ..close();
    canvas.drawPath(capPath, fillPaint);

    // Board
    final boardPath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.45)
      ..lineTo(size.width * 0.25, size.height * 0.75)
      ..lineTo(size.width * 0.75, size.height * 0.75)
      ..lineTo(size.width * 0.75, size.height * 0.45);
    canvas.drawPath(boardPath, paint);

    // Tassel
    canvas.drawLine(
      Offset(size.width * 0.95, size.height * 0.38),
      Offset(size.width * 0.95, size.height * 0.65),
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.95, size.height * 0.68),
      size.width * 0.04,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Social Login Button ──────────────────────────────────────────
class SocialLoginButton extends StatelessWidget {
  final String label;
  final String iconAsset;
  final bool isApple;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.iconAsset,
    this.isApple = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isApple ? Icons.apple : Icons.g_mobiledata_rounded,
              size: 24,
              color: isApple ? Colors.black : Colors.red,
            ),
            const SizedBox(width: 10),
            Text(label,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Primary Button ───────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: isDisabled
            ? null
            : const LinearGradient(
                colors: [AppColors.primaryLight, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isDisabled ? AppColors.primaryLight.withOpacity(0.5) : null,
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: isDisabled || isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(label, style: AppTextStyles.button),
          ),
        ),
      ),
    );
  }
}

// ─── Course Card ──────────────────────────────────────────────────
class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;
  final bool isWishlisted;
  final VoidCallback? onWishlistToggle;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.isWishlisted = false,
    this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    course.thumbnailUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: AppColors.border,
                      child: const Icon(Icons.image_outlined, color: AppColors.textHint, size: 40),
                    ),
                  ),
                ),
                if (course.isFree)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _Badge(label: 'FREE', color: AppColors.success),
                  ),
                if (course.isDiscounted)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _Badge(label: '50% OFF', color: AppColors.accent),
                  ),
                if (course.isNew && !course.isFree && !course.isDiscounted)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _Badge(label: 'NEW', color: AppColors.secondary),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWishlistToggle,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 16,
                        color: isWishlisted ? AppColors.accent : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${course.category} | ${course.instructor}',
                        style: AppTextStyles.label,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text('${course.durationHours} hrs',
                          style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.title,
                    style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        course.isFree ? 'Free' : '\$${course.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: course.isFree ? AppColors.success : AppColors.textPrimary,
                        ),
                      ),
                      if (course.originalPrice != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '\$${course.originalPrice!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      const Spacer(),
                      const Icon(Icons.star_rounded, color: AppColors.starColor, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${course.rating} (${course.reviewCount})',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
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

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeMore;

  const SectionHeader({super.key, required this.title, this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headline3),
        if (onSeeMore != null)
          GestureDetector(
            onTap: onSeeMore,
            child: const Text('Show More',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                )),
          ),
      ],
    );
  }
}

// ─── Category Chip ────────────────────────────────────────────────
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Shimmer Loading ──────────────────────────────────────────────
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = 8,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(_animation.value - 1, 0),
            end: Alignment(_animation.value, 0),
            colors: const [
              AppColors.shimmerBase,
              AppColors.shimmerHighlight,
              AppColors.shimmerBase,
            ],
          ),
        ),
      ),
    );
  }
}

class CourseCardShimmer extends StatelessWidget {
  const CourseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(height: 140, radius: 16),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 120, height: 12),
                SizedBox(height: 8),
                ShimmerBox(height: 16),
                SizedBox(height: 4),
                ShimmerBox(width: 180, height: 16),
                SizedBox(height: 8),
                Row(
                  children: [
                    ShimmerBox(width: 60, height: 14),
                    Spacer(),
                    ShimmerBox(width: 80, height: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── OTP Field ────────────────────────────────────────────────────
class OtpField extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const OtpField({
    super.key,
    required this.controllers,
    required this.focusNodes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (i) {
        return Container(
          width: 44,
          height: 52,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.background,
          ),
          child: TextField(
            controller: controllers[i],
            focusNode: focusNodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: AppTextStyles.headline3,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              fillColor: Colors.transparent,
            ),
            onChanged: (val) {
              if (val.isNotEmpty && i < 5) {
                focusNodes[i + 1].requestFocus();
              } else if (val.isEmpty && i > 0) {
                focusNodes[i - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
