import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum ProfileType { family, individual }

@freezed
class User with _$User {
  const factory User({
    String? id,
    required String username,
    String? email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'phone_ids') required List<String> phones,
    @JsonKey(name: 'profile') UserProfile? userProfile,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'avatar') String? avatar,
    @JsonKey(name: 'type') ProfileType? profileType,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
class UserAvatar with _$UserAvatar {
  const factory UserAvatar({
    String? id,
    @JsonKey(name: 'location') String? location,
  }) = _UserAvatar;

  factory UserAvatar.fromJson(Map<String, dynamic> json) =>
      _$UserAvatarFromJson(json);
}

class UserModel {
  final bool isLoggedIn;
  final bool isFamily;
  final String username;
  final String email;
  final String id;

  UserModel(
      {this.isLoggedIn = false,
      this.isFamily = true,
      this.username = '',
      this.email = '',
      this.id = ''});

  @override
  String toString() {
    return 'UserModel(isLoggedIn: $isLoggedIn, username: $username, email: $email, id: $id, Invidual: $isFamily)';
  }
}
