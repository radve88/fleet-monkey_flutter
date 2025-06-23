
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'http://10.0.2.2:3000';

  static const baseUrl = 'http://127.0.0.1:3000';

  static Future<List<Map<String, dynamic>>> getStatuses() async {
    final res = await http.get(Uri.parse('$baseUrl/status'));
    return List<Map<String, dynamic>>.from(json.decode(res.body));
  }

  static Future<List<Map<String, dynamic>>> getLoads({required DateTime startDate, required DateTime endDate, required int statusId}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/loads'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'statusId': statusId
      })
    );
    return List<Map<String, dynamic>>.from(json.decode(res.body));
  }

  static Future<Map<String, dynamic>> getLoadDetails(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/loads/$id'));
    return Map<String, dynamic>.from(json.decode(res.body));
  }
}
