import 'api_client.dart';

class TestService {
  // POST

  static Future<void> savePVT({
    required String userId,
    required int reactionTime,
  }) async {
    await ApiClient.post("/tests/pvt", {
      "userId": userId,
      "reactionTime": reactionTime,
    });
  }

  static Future<void> saveGoNoGo({
    required String userId,
    required int hits,
    required int misses,
    required int falseAlarms,
    required int correctRejections,
  }) async {
    await ApiClient.post("/tests/gonogo", {
      "userId": userId,
      "hits": hits,
      "misses": misses,
      "falseAlarms": falseAlarms,
      "correctRejections": correctRejections,
    });
  }

  static Future<void> saveNBack({
    required String userId,
    required int hits,
    required int misses,
    required int falseAlarms,
  }) async {
    await ApiClient.post("/tests/nback", {
      "userId": userId,
      "hits": hits,
      "misses": misses,
      "falseAlarms": falseAlarms,
    });
  }

  static Future<void> saveStroop({
    required String userId,
    required int correct,
    required int incorrect,
  }) async {
    await ApiClient.post("/tests/stroop", {
      "userId": userId,
      "correct": correct,
      "incorrect": incorrect,
    });
  }

  static Future<void> saveKSS({
    required String userId,
    required int sleepinessLevel,
  }) async {
    await ApiClient.post("/tests/kss", {
      "userId": userId,
      "sleepinessLevel": sleepinessLevel,
    });
  }

  // GET 

  static Future<List<dynamic>> getPVTResults(String userId) async {
    return await ApiClient.get("/tests/pvt/user/$userId");
  }

  static Future<List<dynamic>> getGoNoGoResults(String userId) async {
    return await ApiClient.get("/tests/gonogo/user/$userId");
  }

  static Future<List<dynamic>> getNBackResults(String userId) async {
    return await ApiClient.get("/tests/nback/user/$userId");
  }

  static Future<List<dynamic>> getStroopResults(String userId) async {
    return await ApiClient.get("/tests/stroop/user/$userId");
  }

  static Future<List<dynamic>> getKSSResults(String userId) async {
    return await ApiClient.get("/tests/kss/user/$userId");
  }
}