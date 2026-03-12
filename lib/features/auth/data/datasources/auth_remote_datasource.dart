import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String phoneNumber, String password);
  Future<AuthResponseModel> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role,
    String? email,
  });
  Future<void> logout();
  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<AuthResponseModel> login(String phoneNumber, String password) async {
    // 1. Login to get token
    final tokenData = await _apiClient.post(
      ApiEndpoints.authLogin,
      {
        'phone_or_email': phoneNumber,
        'password': password,
      },
    );
    final accessToken = tokenData['access_token'];

    // 2. Get User Profile using the new token
    // We manually pass the header because the token isn't in storage yet
    final userData = await _apiClient.get(
      ApiEndpoints.authMe,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    final user = UserModel.fromJson(userData);

    return AuthResponseModel.fromData(user, tokenData);
  }

  @override
  Future<AuthResponseModel> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role,
    String? email,
  }) async {
    // 1. Register User
    await _apiClient.post(
      ApiEndpoints.authRegister,
      {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'email': email,
        'password': password,
        'role': role,
      },
    );

    // 2. Auto Login to return the headers
    return login(phoneNumber, password);
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.authLogout, {});
    } catch ( e) {
      // Ignore errors on logout (e.g. 401 if already token expired)
    }
  }

  @override
  Future<UserModel> getMe() async {
    final data = await _apiClient.get(ApiEndpoints.authMe);
    return UserModel.fromJson(data);
  }
}

