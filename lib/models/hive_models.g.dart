// GENERATED CODE - DO NOT MODIFY BY HAND
// This is a manually written adapter since build_runner is not available at codegen time.
// In a real project, run: flutter pub run build_runner build

part of 'hive_models.dart';

// TypeAdapterGenerator

class HiveCourseAdapter extends TypeAdapter<HiveCourse> {
  @override
  final int typeId = 0;

  @override
  HiveCourse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCourse()
      ..id = fields[0] as String
      ..title = fields[1] as String
      ..instructor = fields[2] as String
      ..category = fields[3] as String
      ..price = fields[4] as double
      ..rating = fields[5] as double
      ..reviewCount = fields[6] as int
      ..durationHours = fields[7] as int
      ..thumbnailUrl = fields[8] as String
      ..isFree = fields[9] as bool
      ..isDiscounted = fields[10] as bool
      ..originalPrice = fields[11] as double?
      ..description = fields[12] as String
      ..tags = (fields[13] as List).cast<String>()
      ..isPopular = fields[14] as bool
      ..isNew = fields[15] as bool
      ..studentsCount = fields[16] as int
      ..lessons = (fields[17] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, HiveCourse obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.instructor)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.reviewCount)
      ..writeByte(7)
      ..write(obj.durationHours)
      ..writeByte(8)
      ..write(obj.thumbnailUrl)
      ..writeByte(9)
      ..write(obj.isFree)
      ..writeByte(10)
      ..write(obj.isDiscounted)
      ..writeByte(11)
      ..write(obj.originalPrice)
      ..writeByte(12)
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.tags)
      ..writeByte(14)
      ..write(obj.isPopular)
      ..writeByte(15)
      ..write(obj.isNew)
      ..writeByte(16)
      ..write(obj.studentsCount)
      ..writeByte(17)
      ..write(obj.lessons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCourseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveUserAdapter extends TypeAdapter<HiveUser> {
  @override
  final int typeId = 1;

  @override
  HiveUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveUser()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..email = fields[2] as String
      ..role = fields[3] as String
      ..isLoggedIn = fields[4] as bool
      ..enrolledCourseIds = (fields[5] as List).cast<String>()
      ..wishlistIds = (fields[6] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, HiveUser obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.isLoggedIn)
      ..writeByte(5)
      ..write(obj.enrolledCourseIds)
      ..writeByte(6)
      ..write(obj.wishlistIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveAppSettingsAdapter extends TypeAdapter<HiveAppSettings> {
  @override
  final int typeId = 2;

  @override
  HiveAppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAppSettings()
      ..onboardingComplete = fields[0] as bool
      ..selectedRole = fields[1] as String
      ..filterJson = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, HiveAppSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.onboardingComplete)
      ..writeByte(1)
      ..write(obj.selectedRole)
      ..writeByte(2)
      ..write(obj.filterJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
