class Course {
  final String id;
  final String title;
  final String instructor;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final int durationHours;
  final String thumbnailUrl;
  final bool isFree;
  final bool isDiscounted;
  final double? originalPrice;
  final String description;
  final List<String> tags;
  final bool isPopular;
  final bool isNew;
  final int studentsCount;
  final List<String> lessons;

  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.durationHours,
    required this.thumbnailUrl,
    this.isFree = false,
    this.isDiscounted = false,
    this.originalPrice,
    required this.description,
    this.tags = const [],
    this.isPopular = false,
    this.isNew = false,
    this.studentsCount = 0,
    this.lessons = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'instructor': instructor,
    'category': category,
    'price': price,
    'rating': rating,
    'reviewCount': reviewCount,
    'durationHours': durationHours,
    'thumbnailUrl': thumbnailUrl,
    'isFree': isFree,
    'isDiscounted': isDiscounted,
    'originalPrice': originalPrice,
    'description': description,
    'tags': tags,
    'isPopular': isPopular,
    'isNew': isNew,
    'studentsCount': studentsCount,
    'lessons': lessons,
  };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'],
    title: json['title'],
    instructor: json['instructor'],
    category: json['category'],
    price: (json['price'] as num).toDouble(),
    rating: (json['rating'] as num).toDouble(),
    reviewCount: json['reviewCount'],
    durationHours: json['durationHours'],
    thumbnailUrl: json['thumbnailUrl'],
    isFree: json['isFree'] ?? false,
    isDiscounted: json['isDiscounted'] ?? false,
    originalPrice: json['originalPrice']?.toDouble(),
    description: json['description'],
    tags: List<String>.from(json['tags'] ?? []),
    isPopular: json['isPopular'] ?? false,
    isNew: json['isNew'] ?? false,
    studentsCount: json['studentsCount'] ?? 0,
    lessons: List<String>.from(json['lessons'] ?? []),
  );
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String role; // 'student' or 'instructor'
  final List<String> enrolledCourseIds;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
    this.enrolledCourseIds = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'role': role,
    'enrolledCourseIds': enrolledCourseIds,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    avatarUrl: json['avatarUrl'],
    role: json['role'],
    enrolledCourseIds: List<String>.from(json['enrolledCourseIds'] ?? []),
  );

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? role,
    List<String>? enrolledCourseIds,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    role: role ?? this.role,
    enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
  );
}

class Instructor {
  final String id;
  final String name;
  final String specialty;
  final String avatarUrl;
  final double rating;
  final int studentsCount;
  final int coursesCount;

  const Instructor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.avatarUrl,
    required this.rating,
    required this.studentsCount,
    required this.coursesCount,
  });
}
