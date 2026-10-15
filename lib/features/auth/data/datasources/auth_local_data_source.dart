import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_tokens_model.dart';

class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokensModel tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', tokens.accessToken);
    await prefs.setString('refresh_token', tokens.refreshToken);
  }
}