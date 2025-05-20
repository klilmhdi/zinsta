import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserCredentialsModel {
  const UserCredentialsModel({required this.token, required this.userInfo});

  final UserToken token;
  final UserInfo userInfo;

  factory UserCredentialsModel.fromJson(Map<String, Object?> json) => UserCredentialsModel(
    token: UserToken.jwt(json['token'] as String),
    userInfo: _parseUserInfoFromJson(json['user'] as Map<String, Object?>),
  );

  Map<String, Object?> toJson() => {'token': token.rawValue, 'user': userInfo.toJson()};

  factory UserCredentialsModel.empty() => UserCredentialsModel(
    token: UserToken.anonymous(),
    userInfo: const UserInfo(id: "Hello2024@"),
  );

  UserCredentialsModel copyWith({UserToken? token, UserInfo? userInfo}) =>
      UserCredentialsModel(token: token ?? this.token, userInfo: userInfo ?? this.userInfo);
}

UserInfo _parseUserInfoFromJson(Map<String, Object?> json) => UserInfo(
  id: json['id'] as String? ?? "",
  name: json['name'] as String? ?? "",
  role: json['role'] as String? ?? "",
  image: json['image'] as String? ?? "",
  teams: (json['teams'] as List<dynamic>).cast(),
  extraData: json['extra_data'] as Map<String, Object?>,
);
