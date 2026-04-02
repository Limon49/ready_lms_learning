import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../widgets/shared_widgets.dart';
import '../../services/hive_cache_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      title: 'Discover Top Courses',
      subtitle: 'Explore thousands of courses from expert instructors',
      imagePath: 'discover',
    ),
    _OnboardingPage(
      title: 'Learn Anytime, Anywhere',
      subtitle: 'Access lessons on your schedule, and track your progress',
      imagePath: 'learn',
    ),
    _OnboardingPage(
      title: 'Teach & Share Your Knowledge',
      subtitle: 'Create courses, reach students, and earn from your expertise.',
      imagePath: 'teach',
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await HiveCacheService.setOnboardingComplete();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _pages[i],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  GestureDetector(
                    onTap: _finish,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Skip',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: const ExpandingDotsEffect(
                    dotColor: AppColors.border,
                    activeDotColor: AppColors.primary,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                  ),
                ),
                GestureDetector(
                  onTap: _next,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryLight, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 80),
          Expanded(
            flex: 3,
            child: _OnboardingIllustration(type: imagePath),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: AppTextStyles.headline2.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

class _OnboardingIllustration extends StatelessWidget {
  final String type;
  const _OnboardingIllustration({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: _IllustrationPainter(type: type),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  final String type;
  _IllustrationPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final iconPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Draw decorative circles
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 20, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.25), 14, paint);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.7), 16, paint);

    // Main icon area
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.5,
      height: size.height * 0.5,
    );

    if (type == 'discover') {
      // Phone with courses
      _drawPhone(canvas, center, size, iconPaint);
    } else if (type == 'learn') {
      // Headphones + screen
      _drawLearn(canvas, center, size, iconPaint);
    } else {
      // Book and chat
      _drawTeach(canvas, center, size, iconPaint);
    }
  }

  void _drawPhone(Canvas canvas, Offset center, Size size, Paint paint) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size.width * 0.35, height: size.height * 0.5),
      const Radius.circular(16),
    );
    canvas.drawRRect(rrect, paint..color = AppColors.primary.withOpacity(0.2));

    // Screen lines
    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(center.dx - size.width * 0.12, center.dy - size.height * 0.1 + i * 14),
        Offset(center.dx + size.width * (i == 0 ? 0.12 : 0.06), center.dy - size.height * 0.1 + i * 14),
        linePaint,
      );
    }

    // Globe icon
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.2, center.dy - size.height * 0.2),
      20,
      paint..color = AppColors.secondary.withOpacity(0.8),
    );
  }

  void _drawLearn(Canvas canvas, Offset center, Size size, Paint paint) {
    // Monitor
    final monitorRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 10), width: size.width * 0.45, height: size.height * 0.35),
      const Radius.circular(12),
    );
    canvas.drawRRect(monitorRect, paint..color = AppColors.primary.withOpacity(0.2));

    // Play button
    final path = Path()
      ..moveTo(center.dx - 8, center.dy - 22)
      ..lineTo(center.dx + 14, center.dy - 10)
      ..lineTo(center.dx - 8, center.dy + 2)
      ..close();
    canvas.drawPath(path, paint..color = AppColors.primary);

    // Person sitting
    canvas.drawCircle(Offset(center.dx - size.width * 0.05, center.dy + size.height * 0.2), 14, paint..color = AppColors.primary.withOpacity(0.6));
  }

  void _drawTeach(Canvas canvas, Offset center, Size size, Paint paint) {
    // Book
    final bookRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size.width * 0.3, height: size.height * 0.4),
      const Radius.circular(8),
    );
    canvas.drawRRect(bookRect, paint..color = AppColors.primary.withOpacity(0.2));

    // Chat bubbles
    final bubble1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx + 20, center.dy - size.height * 0.15, 60, 30),
      const Radius.circular(12),
    );
    canvas.drawRRect(bubble1, paint..color = AppColors.primary.withOpacity(0.5));

    final bubble2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx + 10, center.dy + 10, 50, 25),
      const Radius.circular(10),
    );
    canvas.drawRRect(bubble2, paint..color = AppColors.secondary.withOpacity(0.5));
  }

  @override
  bool shouldRepaint(_) => false;
}
