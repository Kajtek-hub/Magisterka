import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'secure_storage.dart';
import 'dart:convert';

class BioSignalService {
  static const _base = "http://10.0.2.2:5157/api/biosignal";

  // Upload pliku do backendu
  static Future<void> uploadRecording({
    required String userId,
    required String deviceType,   // "Movesense" lub "BITalino"
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    final token = await SecureStorage.getToken();
    final uri = Uri.parse("$_base/upload");

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['userId'] = userId
      ..fields['deviceType'] = deviceType
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      ));

    final response = await request.send();
    if (response.statusCode >= 400) {
      throw Exception("Upload failed: ${response.statusCode}");
    }
  }

  // Lista nagrań użytkownika (metadane + metryki)
  static Future<List<dynamic>> getRecordings(String userId) async {
    final token = await SecureStorage.getToken();
    final res = await http.get(
      Uri.parse("$_base/user/$userId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode >= 400) throw Exception("Błąd ${res.statusCode}");
    return jsonDecode(res.body) as List<dynamic>;
  }

  // Surowe próbki do wykresu
  static Future<Map<String, dynamic>> getRawSamples(String recordingId) async {
    final token = await SecureStorage.getToken();
    final res = await http.get(
      Uri.parse("$_base/raw/$recordingId"),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode >= 400) throw Exception("Błąd ${res.statusCode}");
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}