import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  final String topic; // Menerima topik dari SubMenuScreen

  const QuizScreen({super.key, required this.topic});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Variabel Data
  int? sessionId;
  int? examQuestionId; // ID unik soal untuk validasi jawaban ke server
  String questionText = "";
  List<Map<String, dynamic>> answers = [];
  String? currentDifficulty;

  // Variabel UI
  bool isLoading = true;
  String? _selectedOptionLabel; // Menyimpan jawaban yang dipilih user (A/B/C/D)
  int _currentQuestionIndex = 1; // Sekadar angka visual untuk user

  @override
  void initState() {
    super.initState();
    _startExam(); // Otomatis mulai ujian saat halaman dibuka
  }

  // 1. Mulai Sesi Ujian ke Server
  Future<void> _startExam() async {
    try {
      final response = await ApiService.startExam(widget.topic);
      setState(() {
        sessionId = response['session_id'];
      });
      // Setelah dapat Session ID, langsung minta soal pertama
      _getNextQuestion();
    } catch (e) {
      _showErrorAndExit("Gagal memulai ujian: $e");
    }
  }

  // 2. Ambil Soal Berikutnya dari AI
  Future<void> _getNextQuestion() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      _selectedOptionLabel = null; // Reset pilihan
    });

    if (sessionId != null) {
      try {
        final response = await ApiService.getNextQuestion(sessionId!);

        final qData = response['question'];

        setState(() {
          examQuestionId = response['exam_question_id']; // Penting untuk submit
          questionText = qData['text'];
          // Konversi dynamic list ke Map yang aman
          answers = List<Map<String, dynamic>>.from(qData['options']);
          currentDifficulty = qData['difficulty']?.toString() ?? "1";
          isLoading = false;
        });
      } catch (e) {
        // Jika error mengandung kata "selesai" atau status code tertentu
        if (e.toString().toLowerCase().contains("selesai")) {
          _showCompletionDialog();
        } else {
          _showErrorAndExit("Gagal mengambil soal: $e");
        }
      }
    }
  }

  // 3. Kirim Jawaban ke Server
  Future<void> _submitAnswer() async {
    if (_selectedOptionLabel == null || examQuestionId == null) return;

    // Tampilkan loading sebentar saat mengirim
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(child: CircularProgressIndicator())
    );

    try {
      final response = await ApiService.submitAnswer(examQuestionId!, _selectedOptionLabel!);
      Navigator.pop(context); // Tutup loading dialog

      bool isCorrect = response['is_correct'];
      String message = response['message'];
      String correctLabel = response['correct_label']; // Jawaban benar dari server

      // Tampilkan Alert Hasil (Sama seperti Firestore)
      QuickAlert.show(
        context: context,
        type: isCorrect ? QuickAlertType.success : QuickAlertType.error,
        title: isCorrect ? 'Benar!' : 'Salah',
        text: isCorrect
            ? '$message\n(Level Kamu: ${response['next_level']})'
            : 'Jawaban salah.\nYang benar adalah: $correctLabel\n$message',
        confirmBtnText: 'Lanjut',
        barrierDismissible: false,
        onConfirmBtnTap: () {
          Navigator.pop(context); // Tutup Alert
          setState(() {
            _currentQuestionIndex++; // Naikkan counter soal visual
          });
          _getNextQuestion(); // Load soal baru
        },
      );

    } catch (e) {
      Navigator.pop(context); // Tutup loading dialog
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _showErrorAndExit(String msg) {
    setState(() => isLoading = false);
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Terjadi Kesalahan',
        text: msg,
        confirmBtnText: 'Kembali',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        }
    );
  }

  void _showCompletionDialog() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Selesai!',
        text: 'Selamat! Sesi ujian untuk topik ${widget.topic} telah selesai.',
        confirmBtnText: 'Kembali ke Menu',
        barrierDismissible: false,
        onConfirmBtnTap: () {
          Navigator.pop(context); // Tutup alert
          Navigator.pop(context); // Tutup screen
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ujian: ${widget.topic}", style: const TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF4FC3F7), Color(0xFF1565C0)]),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Indikator Level (Fitur Tambahan Adaptif)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Soal ke-$_currentQuestionIndex", style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                      "Level $currentDifficulty",
                      style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 12)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress Bar Visual (Opsional, statis karena soal unlimited/dynamic)
            LinearProgressIndicator(
              value: (_currentQuestionIndex % 10) / 10, // Loop tiap 10 soal
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 20),

            // --- KOTAK SOAL (Style Firestore) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
                  border: Border.all(color: Colors.blue.shade100)
              ),
              child: Text(
                questionText,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // --- PILIHAN JAWABAN (Style Firestore) ---
            ...answers.map((ans) {
              String label = ans['label'];
              String text = ans['text'];
              bool isSelected = _selectedOptionLabel == label;

              return GestureDetector(
                onTap: () => setState(() => _selectedOptionLabel = label),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade50 : Colors.white,
                      border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: Colors.blue
                      ),
                      const SizedBox(width: 12),
                      // Label (A/B/C)
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
                        child: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(text)),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            // --- TOMBOL JAWAB ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              onPressed: _selectedOptionLabel == null ? null : _submitAnswer,
              child: const Text("Jawab", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}