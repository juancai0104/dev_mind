import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class THttpHelper {
  static final String? _baseUrl = dotenv.env['API_URL'];

  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'content-Type': 'application/json'},
        body: json.encode(data)
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    final response = await http.put(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'content-Type': 'application/json'},
        body: json.encode(data)
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse is List) {
          return decodedResponse;
        } else if (decodedResponse is Map) {
          return decodedResponse;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        return {};
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}