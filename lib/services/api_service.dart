import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.2.31.125:8000';  // Ganti dengan URL FastAPI

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
      return json.decode(response.body); // Return response jika sukses
    } else {
      throw Exception('Failed to login');
    }
  }

  // Memulai ujian
  static Future<Map<String, dynamic>> startExam(String topic) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/ujian/start'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'topic': topic}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Response sukses
    } else {
      throw Exception('Failed to start exam');
    }
  }

  // Mendapatkan soal berikutnya
  static Future<Map<String, dynamic>> getNextQuestion(int sessionId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/ujian/next'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'session_id': sessionId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Response soal
    } else {
      throw Exception('Failed to get next question');
    }
  }

  // Mengirimkan jawaban soal
  static Future<Map<String, dynamic>> submitAnswer(int examQuestionId, String answerLabel) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/ujian/submit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'exam_question_id': examQuestionId,
        'answer_label': answerLabel,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Response setelah submit
    } else {
      throw Exception('Failed to submit answer');
    }
  }

  static Future<Map<String, dynamic>> submitBatch(int sessionId, List<Map<String, dynamic>> answers) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/ujian/submit-batch'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'session_id': sessionId,
        'answers': answers, 
        // Format answers: [{ "exam_question_id": 1, "answer_label": "A", "thinking_time": 10 }]
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
      // Response berisi: score_gained, correct_count, next_batch (bisa null), message
    } else {
      throw Exception('Failed to submit batch: ${response.body}');
    }
  }

}