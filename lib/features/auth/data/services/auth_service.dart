import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_constants.dart';

class AuthService {
  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<void> login({required String email, required String password}) async {
    final response = await _post(
      ApiConstants.login,
      {'email': email, 'password': password},
    );
    final data = _decode(response);

    if (_isSuccess(response)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access_token']);
      await prefs.setString('refresh_token', data['refresh_token']);
    } else if (response.statusCode == 401) {
      throw Exception('Wrong email or password');
    } else {
      throw Exception(_errorMessage(data, 'Login failed'));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _post(ApiConstants.register, {
      'name': name,
      'email': email,
      'password': password,
      'avatar': ApiConstants.defaultAvatar,
    });

    if (!_isSuccess(response)) {
      throw Exception(_errorMessage(_decode(response), 'Sign up failed'));
    }
  }

  // ---------- دوال مساعدة ----------

  Future<http.Response> _post(String url, Map<String, dynamic> body) async {
    try {
      return await http.post(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(body),
      );
    } on http.ClientException {
      throw Exception('Network error, check your internet connection');
    }
  }

  bool _isSuccess(http.Response r) =>
      r.statusCode >= 200 && r.statusCode < 300;

  Map<String, dynamic> _decode(http.Response r) {
    try {
      final decoded = jsonDecode(r.body);
      return decoded is Map<String, dynamic> ? decoded : {};
    } catch (_) {
      return {};
    }
  }

  // الـ API ساعات بيرجع message كنص وساعات كقائمة
  String _errorMessage(Map<String, dynamic> data, String fallback) {
    final message = data['message'];
    if (message is List && message.isNotEmpty) return message.join('\n');
    if (message is String && message.isNotEmpty) return message;
    return fallback;
  }
}