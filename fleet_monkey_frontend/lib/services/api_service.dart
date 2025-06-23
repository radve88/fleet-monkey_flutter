import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // ✅ for kIsWeb

class ApiService {
  static final String baseUrl = kIsWeb
      ? 'http://localhost:3000'     // Web/Chrome
      : 'http://10.0.2.2:3000';     // Android Emulator

  static Future<List<Map<String, dynamic>>> getStatuses() async {
    final url = Uri.parse('$baseUrl/status');
    print('🔍 Fetching from: $url');

    try {
      final res = await http.get(url);
      print('📦 Response status: ${res.statusCode}');
      print('📦 Response body: ${res.body}');

      if (res.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(res.body);
        final result = List<Map<String, dynamic>>.from(jsonData);
        print('✅ Parsed statuses: $result');
        return result;
      } else {
        print('❌ Server returned error: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('💥 Exception during fetchStatuses: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getLoads({
    required DateTime startDate,
    required DateTime endDate,
    required int statusId,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/loads'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'statusId': statusId,
      }),
    );
    return List<Map<String, dynamic>>.from(json.decode(res.body));
  }

  static Future<Map<String, dynamic>> getLoadDetails(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/loads/$id'));
    return Map<String, dynamic>.from(json.decode(res.body));
  }
}
