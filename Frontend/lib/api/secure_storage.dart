import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:convert';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: "jwt", value: token);
  }

  static Future<String?> getToken() async {
    final token = await _storage.read(key: "jwt");
    if (token == null) return null;

    
    if (_isExpired(token)) {
      await deleteToken();
      return null;
    }
    return token;
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: "jwt");
  }
    static Future<String?> getUserId() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
      );

      return payload[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'
      ] as String?;
    } catch (_) {
      return null;
    }
  }
  static bool _isExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
      );

      final exp = payload['exp'] as int?;
      if (exp == null) return true;

      return DateTime.now().isAfter(
        DateTime.fromMillisecondsSinceEpoch(exp * 1000)
      );
    } catch (_) {
      return true;
    }
  }
}