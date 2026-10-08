import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String displayName,
    required String email,
    @Default('') String photoUrl,
    @Default('') String specialty,
    @Default('') String bio,
    @Default('') String instagram,
    @Default('') String tiktok,
    @Default('') String youtube,
    @Default('viewer') String role,
    @Default(false) bool isFeatured,
    @Default(false) bool isBanned,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
