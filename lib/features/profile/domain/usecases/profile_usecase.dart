import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/profile/domain/repositories/profile_repository.dart';
import 'package:sblog/service_locator.dart';

class ProfileUsecase {
  final repository = sl<ProfileRepository>();
  Future<Either<String, String>> profileUpdate(User user) async {
    try {
      log("user: ${user.avatar}");
      final result = await repository.updateProfile(user: user);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return const Left("Không thể cập nhật profile");
    }
  }

  Future<Either<String, User>> getProfile(int userId) async {
    try {
      final result = await repository.getProfile(userId: userId);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return const Left("Không thể cập nhật profile");
    }
  }

  Future<Either<String, String>> changePassword(String newPassword) async {
    try {
      final result = await repository.changePassword(newPassword: newPassword);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return const Left("Không thể thay đổi mật khẩu");
    }
  }

  Future<void> followUser(int userId, bool isFollowing) async {
    try {
      await repository.followUser(userId: userId, isFollowing: isFollowing);
    } catch (e) {
      log("Lỗi khi theo dõi người dùng: $e");
    }
  }
}
