import 'package:hive/hive.dart';

part 'hive_models.g.dart';

@HiveType(typeId: 0)
class HiveCourse extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String instructor;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late double price;

  @HiveField(5)
  late double rating;

  @HiveField(6)
  late int reviewCount;

  @HiveField(7)
  late int durationHours;

  @HiveField(8)
  late String thumbnailUrl;

  @HiveField(9)
  late bool isFree;

  @HiveField(10)
  late bool isDiscounted;

  @HiveField(11)
  double? originalPrice;

  @HiveField(12)
  late String description;

  @HiveField(13)
  late List<String> tags;

  @HiveField(14)
  late bool isPopular;

  @HiveField(15)
  late bool isNew;

  @HiveField(16)
  late int studentsCount;

  @HiveField(17)
  late List<String> lessons;

  HiveCourse();

  factory HiveCourse.fromMap(Map<String, dynamic> map) {
    final obj = HiveCourse()
      ..id = map['id']
      ..title = map['title']
      ..instructor = map['instructor']
      ..category = map['category']
      ..price = (map['price'] as num).toDouble()
      ..rating = (map['rating'] as num).toDouble()
      ..reviewCount = map['reviewCount']
      ..durationHours = map['durationHours']
      ..thumbnailUrl = map['thumbnailUrl']
      ..isFree = map['isFree'] ?? false
      ..isDiscounted = map['isDiscounted'] ?? false
      ..originalPrice = map['originalPrice']?.toDouble()
      ..description = map['description']
      ..tags = List<String>.from(map['tags'] ?? [])
      ..isPopular = map['isPopular'] ?? false
      ..isNew = map['isNew'] ?? false
      ..studentsCount = map['studentsCount'] ?? 0
      ..lessons = List<String>.from(map['lessons'] ?? []);
    return obj;
  }

  Map<String, dynamic> toMap() => {
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
}

@HiveType(typeId: 1)
class HiveUser extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String role;

  @HiveField(4)
  late bool isLoggedIn;

  @HiveField(5)
  late List<String> enrolledCourseIds;

  @HiveField(6)
  late List<String> wishlistIds;

  HiveUser();
}

@HiveType(typeId: 2)
class HiveAppSettings extends HiveObject {
  @HiveField(0)
  late bool onboardingComplete;

  @HiveField(1)
  late String selectedRole;

  @HiveField(2)
  late String filterJson;

  HiveAppSettings();
}
