// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String?,
      username: json['username'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      phones:
          (json['phone_ids'] as List<dynamic>).map((e) => e as String).toList(),
      userProfile: json['profile'] == null
          ? null
          : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'phone_ids': instance.phones,
      'profile': instance.userProfile,
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      avatar: json['avatar'] as String?,
      profileType: $enumDecodeNullable(_$ProfileTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'type': _$ProfileTypeEnumMap[instance.profileType],
    };

const _$ProfileTypeEnumMap = {
  ProfileType.family: 'family',
  ProfileType.individual: 'individual',
};

_$UserAvatarImpl _$$UserAvatarImplFromJson(Map<String, dynamic> json) =>
    _$UserAvatarImpl(
      id: json['id'] as String?,
      location: json['location'] as String?,
      isDefaultAvatar: json['isDefaultAvatar'] as bool?,
    );

Map<String, dynamic> _$$UserAvatarImplToJson(_$UserAvatarImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'isDefaultAvatar': instance.isDefaultAvatar,
    };
