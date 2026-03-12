import 'user_model.dart';

class AuthResponseModel {
  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });

  /// Allows creating model from separate user data and token data
  /// or from a combined JSON if the API supported it directly.
  factory AuthResponseModel.fromData(
      UserModel user, Map<String, dynamic> tokenData) {
    return AuthResponseModel(
      user: user,
      accessToken: tokenData['access_token'] as String,
      tokenType: tokenData['token_type'] as String,
    );
  }
  final UserModel user;
  final String accessToken;
  final String tokenType;
}
