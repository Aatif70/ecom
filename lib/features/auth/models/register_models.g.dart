// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      data: json['Data'] == null
          ? null
          : RegisterData.fromJson(json['Data'] as Map<String, dynamic>),
      success: json['Success'] as bool,
      message: json['Message'] as String,
      statusCode: (json['StatusCode'] as num).toInt(),
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'Data': instance.data,
      'Success': instance.success,
      'Message': instance.message,
      'StatusCode': instance.statusCode,
    };

RegisterData _$RegisterDataFromJson(Map<String, dynamic> json) => RegisterData(
  success: json['Success'] as bool,
  message: json['Message'] as String,
  token: json['Token'] as String?,
  refreshToken: json['RefreshToken'] as String?,
  expiresAt: json['ExpiresAt'] as String?,
  user: json['User'] == null
      ? null
      : RegisteredUser.fromJson(json['User'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegisterDataToJson(RegisterData instance) =>
    <String, dynamic>{
      'Success': instance.success,
      'Message': instance.message,
      'Token': instance.token,
      'RefreshToken': instance.refreshToken,
      'ExpiresAt': instance.expiresAt,
      'User': instance.user,
    };

RegisteredUser _$RegisteredUserFromJson(Map<String, dynamic> json) =>
    RegisteredUser(
      id: json['Id'] as String,
      email: json['Email'] as String,
      userName: json['UserName'] as String,
      userId: (json['UserId'] as num).toInt(),
      name: json['Name'] as String,
      phoneNumber: json['PhoneNumber'] as String,
      createdAt: json['CreatedAt'] as String,
    );

Map<String, dynamic> _$RegisteredUserToJson(RegisteredUser instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Email': instance.email,
      'UserName': instance.userName,
      'UserId': instance.userId,
      'Name': instance.name,
      'PhoneNumber': instance.phoneNumber,
      'CreatedAt': instance.createdAt,
    };
