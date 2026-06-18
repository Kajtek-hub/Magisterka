import 'dart:convert';
import 'package:http/http.dart' as http;
class ApiClient {
  static const baseUrl = "http://10.0.2.2:5157/api";

  static Future<Map<String, dynamic>> post(String path, Map body) async {
    final res = await http.post(
      Uri.parse("$baseUrl$path"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return jsonDecode(res.body);
  }
}