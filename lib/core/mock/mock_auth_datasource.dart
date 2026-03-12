/// Mock implementation of Auth Remote Data Source for testing without backend.
library;

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/models/auth_response_model.dart';
import '../../features/auth/data/models/user_model.dart';
import 'mock_data.dart';

/// Mock auth data source that uses local mock data instead of API calls.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<AuthResponseModel> login(String phoneNumber, String password) async {
    // Simulate network delay
    await MockData.simulateDelay();

    // Find user by phone
    final user = MockData.getUserByPhone(phoneNumber);

    if (user == null) {
      throw Exception('User not found');
    }

    // In mock mode, accept any password
    // Generate mock token
    final token = MockData.generateMockToken();

    // Set current user in mock data
    MockData.login(user.id, user.role, token);

    return AuthResponseModel(
      user: user,
      accessToken: token,
      tokenType: 'Bearer',
    );
  }

  @override
  Future<AuthResponseModel> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role,
    String? email,
  }) async {
    // Simulate network delay
    await MockData.simulateDelay();

    // Check if user already exists
    final existingUser = MockData.getUserByPhone(phoneNumber);
    if (existingUser != null) {
      throw Exception('User with this phone number already exists');
    }

    // Create new user
    final newUser = UserModel(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      role: role,
      isActive: true,
      isVerified: false,
      createdAt: DateTime.now(),
    );

    // Add to mock data
    MockData.users.add(newUser);

    // Generate token
    final token = MockData.generateMockToken();

    // Set current user
    MockData.login(newUser.id, newUser.role, token);

    return AuthResponseModel(
      user: newUser,
      accessToken: token,
      tokenType: 'Bearer',
    );
  }

  @override
  Future<void> logout() async {
    // Simulate network delay
    await MockData.simulateDelay(milliseconds: 200);

    // Clear current user
    MockData.logout();
  }

  @override
  Future<UserModel> getMe() async {
    // Simulate network delay
    await MockData.simulateDelay(milliseconds: 300);

    if (!MockData.isLoggedIn) {
      throw Exception('Not authenticated');
    }

    final user = MockData.getUserById(MockData.currentUserId!);

    if (user == null) {
      throw Exception('User not found');
    }

    return user;
  }
}
