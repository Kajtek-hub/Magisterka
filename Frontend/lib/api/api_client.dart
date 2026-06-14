import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_storage.dart';

class ApiClient {
  static const baseUrl = "http://10.0.2.2:5157/api"; //Emulator android studio
 // static const baseUrl = "http://192.168.0.131:5157/api"; //Real device

static Future<Map<String, dynamic>> post(
  String path,
  Map<String, dynamic> body,
) async {
  final token = await SecureStorage.getToken();

  try {
    final res = await http.post(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    ).timeout(
      const Duration(seconds: 10),           
      onTimeout: () => throw Exception("Server is not responding"),
    );

    if (res.statusCode >= 400) {
      throw Exception("Error ${res.statusCode}: ${res.body}");
    }

    return jsonDecode(res.body) as Map<String, dynamic>;

  } on Exception {
    rethrow;                                  
  }
}
    static Future<List<dynamic>> get(String path) async {
    final token = await SecureStorage.getToken();

    try {
      final res = await http
          .get(
            Uri.parse("$baseUrl$path"),
            headers: {
              "Content-Type": "application/json",
              if (token != null) "Authorization": "Bearer $token",
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception("Serwer nie odpowiada"),
          );

      if (res.statusCode >= 400) {
        throw Exception("Błąd ${res.statusCode}: ${res.body}");
      }

      return jsonDecode(res.body) as List<dynamic>;
    } on Exception {
      rethrow;
    }
  }
}