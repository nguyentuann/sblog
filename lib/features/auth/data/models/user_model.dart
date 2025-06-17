import 'package:sblog/features/auth/domain/entities/user.dart';

// todo Dữ liệu API
class UserModel {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String? avatar;
  final String? bio;
  final int follower;
  final int following;
  final String? accessToken;
  final String? refreshToken;
  final bool isFollowing;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.follower,
    required this.following,
    this.avatar,
    this.bio,
    this.accessToken,
    this.refreshToken,
    required this.isFollowing,
  });

  /// Chuyển đổi `UserModel` sang `User`
  User toEntity() {
    return User(
      id: id,
      email: email,
      firstname: firstname,
      lastname: lastname,
      follower: follower,
      following: following,
      avatar: avatar,
      bio: bio,
      isFollowing: isFollowing,
    );
  }

  /// Chuyển đổi từ JSON sang `UserModel`
  factory UserModel.fromJson(Map<String, dynamic> json) {
    var user = json["user"] ?? json["data"] ?? json;
    return UserModel(
      id: user["id"],
      firstname: user["first_name"],
      lastname: user["last_name"],
      email: user["email"],
      follower: user["followers_count"] ?? 0,
      following: user["following_count"] ?? 0,
      avatar: user["avatar"] ?? "",
      bio: user["bio"] ?? "",
      accessToken: json["access_token"] ?? "",
      refreshToken: json["refresh_token"] ?? "",
      isFollowing: user["is_following"] ?? false,
    );
  }

  /// Chuyển đổi từ `User` sang `UserModel`
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email,
      follower: user.follower,
      following: user.following,
      avatar: user.avatar,
      bio: user.bio,
      isFollowing: user.isFollowing,
    );
  }

  /// Chuyển đổi `UserModel` sang JSON
  Map<String, dynamic> toJson() {
    return {
      "user": {
        "first_name": firstname,
        "last_name": lastname,
        "email": email,
        "avatar": avatar,
        "bio": bio,
      },
      "access_token": accessToken,
      "refresh_token": refreshToken,
    };
  }
}
