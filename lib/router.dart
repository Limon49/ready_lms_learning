import 'package:flutter/material.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/role_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/main_scaffold.dart';
import 'screens/home/search_screen.dart';
import 'screens/courses/all_courses_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _fade(const SplashScreen());
    case '/onboarding':
      return _slide(const OnboardingScreen());
    case '/role':
      return _slide(const RoleSelectionScreen());
    case '/login':
      return _fade(const LoginScreen());
    case '/signup':
      return _slide(const SignUpScreen());
    case '/home':
      return _fade(const MainScaffold());
    case '/search':
      return _slide(const SearchScreen());
    case '/courses':
      return _slide(const AllCoursesScreen());
    default:
      return _fade(const SplashScreen());
  }
}

PageRouteBuilder _fade(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 250),
    );

PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    );
