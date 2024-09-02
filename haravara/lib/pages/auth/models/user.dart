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
    @JsonKey(name: 'phone_ids') @Default([]) List<String> phones,
    @JsonKey(name: 'profile') UserProfile? userProfile,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'avatar') String? avatar,
    @JsonKey(name: 'type') ProfileType? profileType,
    @JsonKey(name: 'children') int? children,
    @JsonKey(name: 'location') String? location,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
class UserAvatar with _$UserAvatar {
  const factory UserAvatar({
    String? id,
    @JsonKey(name: 'location') String? location,
    bool? isDefaultAvatar,
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
  final String location;
  final int children;

  UserModel(
      {this.isLoggedIn = false,
      this.isFamily = false,   // changed from true to fasle
      this.username = '',
      this.location = '',
      this.email = '',
      this.children = -1,
      this.id = ''});

  @override
  String toString() {
    return 'UserModel(isLoggedIn: $isLoggedIn, username: $username,  children: $children location: $location email: $email, id: $id, Invidual: $isFamily)';
  }

  UserModel copyWith({
    bool? isLoggedIn,
    String? username,
    String? email,
    String? location,
    String? id,
    int? children,
    bool? isFamily,
  }) {
    return UserModel(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      username: username ?? this.username,
      email: email ?? this.email,
      id: id ?? this.id,
      children: children ?? this.children,
      location: location ?? this.location,
      isFamily: isFamily ?? this.isFamily,
    );
  }
}
