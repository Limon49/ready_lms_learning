# ready_lms

A Flutter LMS (Learning Management System) application with clean architecture.

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # App-wide constants & strings
│   ├── router/
│   │   └── app_router.dart          # GoRouter configuration
│   └── theme/
│       ├── app_colors.dart          # Color palette
│       ├── app_text_styles.dart     # Typography styles
│       └── app_theme.dart           # Material ThemeData
│
├── data/
│   ├── models/
│   │   ├── user_model.dart          # User data class (Hive)
│   │   ├── user_model.g.dart        # Generated Hive adapter
│   │   ├── course_model.dart        # Course data class (Hive)
│   │   └── course_model.g.dart      # Generated Hive adapter
│   └── services/
│       ├── hive_service.dart        # Hive box management
│       ├── auth_repository.dart     # Auth business logic
│       └── course_repository.dart   # Course data + dummy seed data
│
├── viewmodels/
│   ├── auth_state.dart              # AuthState immutable model
│   ├── auth_viewmodel.dart          # Auth StateNotifier
│   └── home_viewmodel.dart          # Home StateNotifier
│
├── providers/
│   ├── auth_provider.dart           # Auth Riverpod providers
│   └── home_provider.dart           # Home Riverpod providers
│
├── views/
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── onboarding_screen.dart
│   │   ├── choose_role_screen.dart
│   │   ├── login_screen.dart
│   │   ├── login_email_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── signup_email_screen.dart
│   │   ├── verify_otp_screen.dart
│   │   ├── verification_success_screen.dart
│   │   ├── main_nav_screen.dart
│   │   ├── home_screen.dart
│   │   ├── courses_screen.dart
│   │   ├── instructors_screen.dart
│   │   ├── activities_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/
│       ├── primary_button.dart
│       ├── social_button.dart
│       ├── app_text_field.dart
│       ├── error_dialog.dart
│       ├── course_card.dart
│       ├── category_chip.dart
│       ├── section_header.dart
│       ├── discount_banner.dart
│       ├── search_bar_widget.dart
│       └── discount_banner.dart
│
└── main.dart                          # App entry point
```

## Getting Started

This project is a Flutter application built with:
- **Riverpod** for state management
- **GoRouter** for navigation
- **Hive** for local data persistence

Run the app:
```bash
flutter run
```

Generate Hive adapters:
```bash
flutter pub run build_runner build
```
# ready_lms_learning
