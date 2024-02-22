import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    String? id,
    required String username,
    String? email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'phone_ids') required List<String> phones,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

class UserModel {
  final bool isLoggedIn;
  final String username;
  final String email;
  final String id;

  UserModel(
      {this.isLoggedIn = false,
      this.username = '',
      this.email = '',
      this.id = ''});

  @override
  String toString() {
    return 'UserModel(isLoggedIn: $isLoggedIn, username: $username, email: $email, id: $id)';
  }
}
