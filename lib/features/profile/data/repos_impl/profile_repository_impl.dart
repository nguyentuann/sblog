import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:sblog/features/auth/data/models/user_model.dart';
import 'package:sblog/features/auth/domain/entities/user.dart';
import 'package:sblog/features/profile/data/sources/profile_api.dart';
import 'package:sblog/features/profile/domain/repositories/profile_repository.dart';
import 'package:sblog/service_locator.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  
  final profileApi = sl<ProfileAPI>();
  @override
  Future<Either<String, User>> getProfile({required int userId}) async {
    try {
      final result = await profileApi.getProfile(userId);
      return result.fold((l) => Left(l), (r) => Right(r.toEntity()));
    } catch (e) {
      return const Left("Không thể lấy profile");
    }
  }

  @override
  Future<Either<String, String>> updateProfile({required User user}) async {
    try {
      final result = await profileApi.updateProfile(UserModel.fromEntity(user));
      return result.fold((l) => Left(l), (r) => Right(r));
    } catch (e) {
      return const Left("Không thể update profile");
    }
  }

  @override
  Future<Either<String, String>> changePassword({
    required String newPassword,
  }) async {
    try {
      final result = await profileApi.changePassword(newPassword);
      return result.fold((l) => Left(l), (r) => Right(r));
    } catch (e) {
      return const Left("Không thể thay đổi mật khẩu");
    }
  }

  @override
  Future<void> followUser(
      {required int userId, required bool isFollowing}) async {
    try {
      await profileApi.followUser(userId, isFollowing);
    } catch (e) {
      log("Lỗi khi theo dõi người dùng repository: $e");
    }
  }
}
