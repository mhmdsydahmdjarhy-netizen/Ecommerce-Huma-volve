import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_constants.dart';
import '../models/auth_tokens_model.dart';

class AuthRemoteDataSource {
  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _post(
      ApiConstants.login,
      {'email': email, 'password': password},
    );
    final data = _decode(response);

    if (_isSuccess(response)) return AuthTokensModel.fromJson(data);
    if (response.statusCode == 401) {
      throw Exception('Wrong email or password');
    }
    throw Exception(_errorMessage(data, 'Login failed'));
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

  String _errorMessage(Map<String, dynamic> data, String fallback) {
    final message = data['message'];
    if (message is List && message.isNotEmpty) return message.join('\n');
    if (message is String && message.isNotEmpty) return message;
    return fallback;
  }
}