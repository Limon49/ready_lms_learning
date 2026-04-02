import '../models/course.dart';

class MockData {
  static const List<Course> courses = [
    Course(
      id: '1',
      title: 'UX Design for Businesses',
      instructor: 'Sophia Khan',
      category: 'Design',
      price: 20.00,
      rating: 4.5,
      reviewCount: 450,
      durationHours: 24,
      thumbnailUrl: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?w=400',
      isDiscounted: false,
      description: 'Master UX design principles and create compelling user experiences for businesses. Learn wireframing, prototyping, and user research techniques.',
      tags: ['UX', 'Design', 'Business'],
      isPopular: true,
      studentsCount: 4500,
      lessons: ['Introduction to UX', 'User Research', 'Wireframing', 'Prototyping', 'Usability Testing'],
    ),
    Course(
      id: '2',
      title: 'Python for Data Science',
      instructor: 'James Miller',
      category: 'Python',
      price: 35.00,
      rating: 4.8,
      reviewCount: 1200,
      durationHours: 40,
      thumbnailUrl: 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400',
      isPopular: true,
      isNew: false,
      description: 'Comprehensive Python course covering data analysis, visualization, and machine learning fundamentals.',
      tags: ['Python', 'Data Science', 'ML'],
      studentsCount: 12000,
      lessons: ['Python Basics', 'NumPy', 'Pandas', 'Matplotlib', 'Scikit-learn'],
    ),
    Course(
      id: '3',
      title: 'Web Design Masterclass',
      instructor: 'Sarah Johnson',
      category: 'Design',
      price: 0.00,
      rating: 4.3,
      reviewCount: 780,
      durationHours: 18,
      thumbnailUrl: 'https://images.unsplash.com/photo-1547658719-da2b51169166?w=400',
      isFree: true,
      description: 'Learn modern web design from scratch. HTML, CSS, responsive design and more.',
      tags: ['Web Design', 'HTML', 'CSS'],
      isNew: true,
      studentsCount: 8900,
      lessons: ['HTML Fundamentals', 'CSS Styling', 'Responsive Design', 'Flexbox & Grid'],
    ),
    Course(
      id: '4',
      title: 'Flutter App Development',
      instructor: 'Alex Chen',
      category: 'Mobile',
      price: 45.00,
      originalPrice: 90.00,
      rating: 4.9,
      reviewCount: 620,
      durationHours: 32,
      thumbnailUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400',
      isDiscounted: true,
      description: 'Build beautiful cross-platform mobile apps with Flutter and Dart. From basics to advanced state management.',
      tags: ['Flutter', 'Dart', 'Mobile'],
      isPopular: true,
      isNew: true,
      studentsCount: 6200,
      lessons: ['Dart Basics', 'Flutter Widgets', 'State Management', 'Navigation', 'API Integration'],
    ),
    Course(
      id: '5',
      title: 'Graphic Design Fundamentals',
      instructor: 'Maria Garcia',
      category: 'Design',
      price: 0.00,
      rating: 4.4,
      reviewCount: 330,
      durationHours: 15,
      thumbnailUrl: 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=400',
      isFree: true,
      description: 'Master the fundamentals of graphic design including typography, color theory, and composition.',
      tags: ['Graphics', 'Typography', 'Color'],
      studentsCount: 3300,
      lessons: ['Design Principles', 'Typography', 'Color Theory', 'Composition'],
    ),
    Course(
      id: '6',
      title: 'React & Node.js Full Stack',
      instructor: 'David Park',
      category: 'Web Development',
      price: 55.00,
      originalPrice: 110.00,
      rating: 4.7,
      reviewCount: 890,
      durationHours: 50,
      thumbnailUrl: 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400',
      isDiscounted: true,
      isPopular: true,
      description: 'Complete full-stack development with React frontend and Node.js backend. Build real-world projects.',
      tags: ['React', 'Node.js', 'JavaScript'],
      studentsCount: 8900,
      lessons: ['React Basics', 'Hooks', 'Redux', 'Node.js', 'Express', 'MongoDB'],
    ),
    Course(
      id: '7',
      title: 'Digital Marketing Strategy',
      instructor: 'Emma Wilson',
      category: 'Marketing',
      price: 25.00,
      rating: 4.2,
      reviewCount: 410,
      durationHours: 20,
      thumbnailUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400',
      isNew: true,
      description: 'Learn digital marketing strategies including SEO, social media, email marketing, and analytics.',
      tags: ['Marketing', 'SEO', 'Social Media'],
      studentsCount: 4100,
      lessons: ['SEO Basics', 'Social Media Marketing', 'Email Campaigns', 'Analytics'],
    ),
    Course(
      id: '8',
      title: 'Product Design with Figma',
      instructor: 'Lucas Brown',
      category: 'Design',
      price: 30.00,
      rating: 4.6,
      reviewCount: 560,
      durationHours: 22,
      thumbnailUrl: 'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=400',
      isPopular: true,
      description: 'Design stunning products using Figma. Learn components, auto-layout, prototyping, and design systems.',
      tags: ['Product Design', 'Figma', 'UI'],
      studentsCount: 5600,
      lessons: ['Figma Basics', 'Components', 'Auto Layout', 'Prototyping', 'Design Systems'],
    ),
  ];

  static const List<Instructor> instructors = [
    Instructor(
      id: '1',
      name: 'Sophia Khan',
      specialty: 'UX Design',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      rating: 4.8,
      studentsCount: 14500,
      coursesCount: 8,
    ),
    Instructor(
      id: '2',
      name: 'James Miller',
      specialty: 'Data Science',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      rating: 4.9,
      studentsCount: 22000,
      coursesCount: 12,
    ),
    Instructor(
      id: '3',
      name: 'Sarah Johnson',
      specialty: 'Web Design',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      rating: 4.7,
      studentsCount: 18900,
      coursesCount: 6,
    ),
    Instructor(
      id: '4',
      name: 'Alex Chen',
      specialty: 'Mobile Dev',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
      rating: 4.9,
      studentsCount: 9200,
      coursesCount: 5,
    ),
    Instructor(
      id: '5',
      name: 'Maria Garcia',
      specialty: 'Graphic Design',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      rating: 4.5,
      studentsCount: 7300,
      coursesCount: 4,
    ),
  ];

  static List<String> get categories => [
    'All',
    'UX Design',
    'Python',
    'Design',
    'Mobile',
    'Web Development',
    'Marketing',
  ];

  static List<Course> getCoursesByCategory(String category) {
    if (category == 'All') return courses;
    return courses.where((c) => c.category == category || c.tags.contains(category)).toList();
  }

  static List<Course> get topRatedCourses =>
      [...courses]..sort((a, b) => b.rating.compareTo(a.rating));

  static List<Course> get freeCourses =>
      courses.where((c) => c.isFree).toList();

  static List<Course> get discountedCourses =>
      courses.where((c) => c.isDiscounted).toList();

  static List<Course> get popularCourses =>
      courses.where((c) => c.isPopular).toList();

  static Course? getCourseById(String id) {
    try {
      return courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<Course> searchCourses(String query) {
    final q = query.toLowerCase();
    return courses.where((c) =>
      c.title.toLowerCase().contains(q) ||
      c.instructor.toLowerCase().contains(q) ||
      c.category.toLowerCase().contains(q) ||
      c.tags.any((t) => t.toLowerCase().contains(q))
    ).toList();
  }

  static List<Course> filterCourses({
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? isFree,
    bool? isPopular,
    bool? isNew,
    bool? isDiscounted,
  }) {
    return courses.where((c) {
      if (category != null && category != 'All' && c.category != category) return false;
      if (minPrice != null && c.price < minPrice) return false;
      if (maxPrice != null && c.price > maxPrice) return false;
      if (isFree == true && !c.isFree) return false;
      if (isPopular == true && !c.isPopular) return false;
      if (isNew == true && !c.isNew) return false;
      if (isDiscounted == true && !c.isDiscounted) return false;
      return true;
    }).toList();
  }
}
