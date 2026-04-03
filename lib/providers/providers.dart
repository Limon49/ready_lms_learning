import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import '../data/mock_data.dart';
import '../services/hive_cache_service.dart';


class AuthState {
  final bool isLoggedIn;
  final String userName;
  final String userEmail;
  final String role;

  const AuthState({
    required this.isLoggedIn,
    required this.userName,
    required this.userEmail,
    required this.role,
  });

  AuthState copyWith({bool? isLoggedIn, String? userName, String? userEmail, String? role}) =>
      AuthState(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        userName: userName ?? this.userName,
        userEmail: userEmail ?? this.userEmail,
        role: role ?? this.role,
      );
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState(
        isLoggedIn: HiveCacheService.isLoggedIn,
        userName: HiveCacheService.userName,
        userEmail: HiveCacheService.userEmail,
        role: HiveCacheService.userRole,
      );

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.isEmpty || password.isEmpty) return false;
    if (password.length < 6) return false;
    final name = email.split('@').first;
    await HiveCacheService.saveUserSession(name: name, email: email, role: state.role);
    state = state.copyWith(isLoggedIn: true, userName: name, userEmail: email);
    return true;
  }

  Future<bool> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (name.isEmpty || email.isEmpty || password.isEmpty) return false;
    await HiveCacheService.saveUserSession(name: name, email: email, role: 'student');
    state = state.copyWith(isLoggedIn: true, userName: name, userEmail: email);
    return true;
  }

  Future<void> logout() async {
    await HiveCacheService.setLoggedIn(false);
    state = state.copyWith(isLoggedIn: false, userName: '', userEmail: '');
  }

  Future<void> setRole(String role) async {
    await HiveCacheService.setUserRole(role);
    state = state.copyWith(role: role);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

// COURSES

class CoursesState {
  final List<Course> courses;
  final bool isLoading;
  final String selectedCategory;

  const CoursesState({required this.courses, required this.isLoading, required this.selectedCategory});

  CoursesState copyWith({List<Course>? courses, bool? isLoading, String? selectedCategory}) =>
      CoursesState(
        courses: courses ?? this.courses,
        isLoading: isLoading ?? this.isLoading,
        selectedCategory: selectedCategory ?? this.selectedCategory,
      );
}

class CoursesNotifier extends Notifier<CoursesState> {
  @override
  CoursesState build() {
    _loadCourses();
    return const CoursesState(courses: [], isLoading: true, selectedCategory: 'All');
  }

  Future<void> _loadCourses() async {
    // Try Hive cache first – instant load
    final cached = HiveCacheService.getCachedCourses();
    if (cached != null && cached.isNotEmpty) {
      state = state.copyWith(courses: cached, isLoading: false);
      return;
    }
    // Simulate network fetch then cache
    await Future.delayed(const Duration(milliseconds: 700));
    await HiveCacheService.cacheCourses(MockData.courses);
    state = state.copyWith(courses: MockData.courses, isLoading: false);
  }

  void selectCategory(String category) => state = state.copyWith(selectedCategory: category);

  List<Course> get topRatedCourses => [...state.courses]..sort((a, b) => b.rating.compareTo(a.rating));
  List<Course> get freeCourses => state.courses.where((c) => c.isFree).toList();

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));
    await HiveCacheService.cacheCourses(MockData.courses);
    state = state.copyWith(courses: MockData.courses, isLoading: false);
  }
}

final coursesProvider = NotifierProvider<CoursesNotifier, CoursesState>(CoursesNotifier.new);


// SEARCH

class SearchState {
  final String query;
  final List<Course> results;
  const SearchState({required this.query, required this.results});
}

class SearchNotifier extends Notifier<SearchState> {
  @override
  SearchState build() => const SearchState(query: '', results: []);

  void search(String query) {
    if (query.isEmpty) { state = const SearchState(query: '', results: []); return; }
    state = SearchState(query: query, results: MockData.searchCourses(query));
  }

  void clear() => state = const SearchState(query: '', results: []);
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);


class WishlistNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => HiveCacheService.wishlistIds.toSet();

  Future<void> toggle(String courseId) async {
    await HiveCacheService.toggleWishlist(courseId);
    state = HiveCacheService.wishlistIds.toSet();
  }
}

final wishlistProvider = NotifierProvider<WishlistNotifier, Set<String>>(WishlistNotifier.new);


class EnrollmentNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => HiveCacheService.enrolledCourseIds.toSet();

  Future<void> enroll(String courseId) async {
    await HiveCacheService.enrollCourse(courseId);
    state = HiveCacheService.enrolledCourseIds.toSet();
  }

  Future<void> unenroll(String courseId) async {
    await HiveCacheService.unenrollCourse(courseId);
    state = HiveCacheService.enrolledCourseIds.toSet();
  }
}

final enrollmentProvider = NotifierProvider<EnrollmentNotifier, Set<String>>(EnrollmentNotifier.new);


class FilterState {
  final List<String> selectedTopics;
  final List<String> selectedTags;
  final double minPrice;
  final double maxPrice;

  const FilterState({
    this.selectedTopics = const [],
    this.selectedTags = const [],
    this.minPrice = 0,
    this.maxPrice = 150,
  });

  FilterState copyWith({List<String>? selectedTopics, List<String>? selectedTags, double? minPrice, double? maxPrice}) =>
      FilterState(
        selectedTopics: selectedTopics ?? this.selectedTopics,
        selectedTags: selectedTags ?? this.selectedTags,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
      );

  List<Course> apply(List<Course> courses) {
    return courses.where((c) {
      if (selectedTopics.isNotEmpty &&
          !selectedTopics.any((t) => c.category.contains(t) || c.tags.contains(t))) return false;
      if (c.price < minPrice || c.price > maxPrice) return false;
      return true;
    }).toList();
  }
}

class FilterNotifier extends Notifier<FilterState> {
  @override
  FilterState build() => const FilterState();

  void toggleTopic(String topic) {
    final topics = [...state.selectedTopics];
    topics.contains(topic) ? topics.remove(topic) : topics.add(topic);
    state = state.copyWith(selectedTopics: topics);
  }

  void toggleTag(String tag) {
    final tags = [...state.selectedTags];
    tags.contains(tag) ? tags.remove(tag) : tags.add(tag);
    state = state.copyWith(selectedTags: tags);
  }

  void setPriceRange(double min, double max) => state = state.copyWith(minPrice: min, maxPrice: max);

  void applyAll({required Set<String> topics, required Set<String> tags, required double minPrice, required double maxPrice}) {
    state = FilterState(selectedTopics: topics.toList(), selectedTags: tags.toList(), minPrice: minPrice, maxPrice: maxPrice);
  }

  void reset() => state = const FilterState();
}

final filterProvider = NotifierProvider<FilterNotifier, FilterState>(FilterNotifier.new);

final bottomNavProvider = StateProvider<int>((ref) => 0);
