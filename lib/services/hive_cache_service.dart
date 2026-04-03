import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive_models.dart';
import '../models/course.dart';


class HiveCacheService {
  // Box names
  static const _coursesBox = 'courses';
  static const _userBox = 'user';
  static const _settingsBox = 'settings';

  // Singleton keys
  static const _userKey = 'current';
  static const _settingsKey = 'app';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(HiveCourseAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(HiveUserAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(HiveAppSettingsAdapter());

    await Hive.openBox<HiveCourse>(_coursesBox);
    await Hive.openBox<HiveUser>(_userBox);
    await Hive.openBox<HiveAppSettings>(_settingsBox);

    final settingsBox = Hive.box<HiveAppSettings>(_settingsBox);
    if (!settingsBox.containsKey(_settingsKey)) {
      settingsBox.put(
        _settingsKey,
        HiveAppSettings()
          ..onboardingComplete = false
          ..selectedRole = 'student'
          ..filterJson = '',
      );
    }

    final userBox = Hive.box<HiveUser>(_userBox);
    if (!userBox.containsKey(_userKey)) {
      userBox.put(
        _userKey,
        HiveUser()
          ..id = ''
          ..name = ''
          ..email = ''
          ..role = 'student'
          ..isLoggedIn = false
          ..enrolledCourseIds = []
          ..wishlistIds = [],
      );
    }
  }

  static Box<HiveCourse> get _courses => Hive.box<HiveCourse>(_coursesBox);
  static Box<HiveUser> get _users => Hive.box<HiveUser>(_userBox);
  static Box<HiveAppSettings> get _settings => Hive.box<HiveAppSettings>(_settingsBox);

  static HiveUser get _user => _users.get(_userKey)!;
  static HiveAppSettings get _appSettings => _settings.get(_settingsKey)!;

  //Onboarding
  static bool get isOnboardingComplete => _appSettings.onboardingComplete;

  static Future<void> setOnboardingComplete() async {
    final s = _appSettings;
    s.onboardingComplete = true;
    await s.save();
  }

  //Role
  static String get userRole => _appSettings.selectedRole;

  static Future<void> setUserRole(String role) async {
    final s = _appSettings;
    s.selectedRole = role;
    await s.save();
    final u = _user;
    u.role = role;
    await u.save();
  }

  // ── Auth / User ──────────────────────────────────────────────────
  static bool get isLoggedIn => _user.isLoggedIn;
  static String get userName => _user.name;
  static String get userEmail => _user.email;

  static Future<void> setLoggedIn(bool value) async {
    final u = _user;
    u.isLoggedIn = value;
    await u.save();
  }

  static Future<void> setUserName(String name) async {
    final u = _user;
    u.name = name;
    await u.save();
  }

  static Future<void> setUserEmail(String email) async {
    final u = _user;
    u.email = email;
    await u.save();
  }

  static Future<void> saveUserSession({
    required String name,
    required String email,
    required String role,
  }) async {
    final u = _user;
    u.name = name;
    u.email = email;
    u.role = role;
    u.isLoggedIn = true;
    await u.save();

    final s = _appSettings;
    s.selectedRole = role;
    await s.save();
  }

  static Future<void> cacheCourses(List<Course> courses) async {
    await _courses.clear();
    final entries = {
      for (final c in courses)
        c.id: HiveCourse.fromMap(c.toJson()),
    };
    await _courses.putAll(entries);
  }

  static List<Course>? getCachedCourses() {
    if (_courses.isEmpty) return null;
    return _courses.values
        .map((hc) => Course.fromJson(hc.toMap()))
        .toList();
  }

  static Future<void> cacheSingleCourse(Course course) async {
    await _courses.put(course.id, HiveCourse.fromMap(course.toJson()));
  }

  // ── Enrolled Courses ─────────────────────────────────────────────
  static List<String> get enrolledCourseIds =>
      List<String>.from(_user.enrolledCourseIds);

  static Future<void> enrollCourse(String courseId) async {
    final u = _user;
    final enrolled = List<String>.from(u.enrolledCourseIds);
    if (!enrolled.contains(courseId)) {
      enrolled.add(courseId);
      u.enrolledCourseIds = enrolled;
      await u.save();
    }
  }

  static Future<void> unenrollCourse(String courseId) async {
    final u = _user;
    final enrolled = List<String>.from(u.enrolledCourseIds);
    enrolled.remove(courseId);
    u.enrolledCourseIds = enrolled;
    await u.save();
  }

  // ── Wishlist ─────────────────────────────────────────────────────
  static List<String> get wishlistIds =>
      List<String>.from(_user.wishlistIds);

  static Future<void> toggleWishlist(String courseId) async {
    final u = _user;
    final wishlist = List<String>.from(u.wishlistIds);
    wishlist.contains(courseId) ? wishlist.remove(courseId) : wishlist.add(courseId);
    u.wishlistIds = wishlist;
    await u.save();
  }

  static bool isWishlisted(String courseId) => wishlistIds.contains(courseId);

  // ── Filter Cache ─────────────────────────────────────────────────
  static String get filterJson => _appSettings.filterJson;

  static Future<void> saveFilterJson(String json) async {
    final s = _appSettings;
    s.filterJson = json;
    await s.save();
  }

  // ── Clear ────────────────────────────────────────────────────────
  static Future<void> clearAll() async {
    await _courses.clear();

    // Reset user (keep box open, just wipe data)
    await _users.put(
      _userKey,
      HiveUser()
        ..id = ''
        ..name = ''
        ..email = ''
        ..role = 'student'
        ..isLoggedIn = false
        ..enrolledCourseIds = []
        ..wishlistIds = [],
    );

    // Reset settings
    await _settings.put(
      _settingsKey,
      HiveAppSettings()
        ..onboardingComplete = false
        ..selectedRole = 'student'
        ..filterJson = '',
    );
  }

  static Future<void> closeAll() async {
    await Hive.close();
  }
}
