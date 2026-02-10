import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.18.205:8000';

  // Mendapatkan token JWT dari shared_preferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Fungsi login menggunakan Google
  static Future<Map<String, dynamic>> loginWithGoogle(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/google-login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'token': token}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  /// Memulai ujian - Langsung dapat Batch 1 (3 Soal)
  static Future<Map<String, dynamic>> startExam(String topic) async {
    final token = await getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ujian/start'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'topic': topic}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['detail'] ?? 'Failed to start exam');
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server');
    } on TimeoutException {
      throw Exception('Koneksi timeout');
    }
  }

  /// Submit semua jawaban dalam 1 batch sekaligus
  static Future<Map<String, dynamic>> submitBatch(
      int sessionId,
      List<Map<String, dynamic>> answers
      ) async {
    final token = await getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ujian/submit-batch'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'session_id': sessionId,
          'answers': answers,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['detail'] ?? 'Failed to submit batch');
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server');
    } on TimeoutException {
      throw Exception('Koneksi timeout');
    }
  }
}
