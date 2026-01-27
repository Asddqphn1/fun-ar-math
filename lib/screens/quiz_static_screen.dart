import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class QuizStaticScreen extends StatefulWidget {
  final List<Map<String, dynamic>> quizList;
  final String title;

  const QuizStaticScreen({
    super.key,
    required this.quizList,
    required this.title,
  });

  @override
  State<QuizStaticScreen> createState() => _QuizStaticScreenState();
}

class _QuizStaticScreenState extends State<QuizStaticScreen> {
  int _currentIndex = 0;
  int? _selectedOptionIndex;

  // --- VARIABEL SKOR ---
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF4FC3F7), Color(0xFF1565C0)]),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: widget.quizList.isEmpty
          ? const Center(child: Text("Data soal kosong."))
          : _buildQuizContent(),
    );
  }

  Widget _buildQuizContent() {
    // --- JIKA KUIS SELESAI, TAMPILKAN HASIL SKOR ---
    if (_currentIndex >= widget.quizList.length) {
      return _buildResultScreen(widget.quizList.length);
    }

    // Ambil data dari static_data.dart
    // Struktur data: { 'name': 'Soal 1', 'quiz': { 'question': '...', ... } }
    final currentItem = widget.quizList[_currentIndex];
    final quizData = currentItem['quiz'] as Map<String, dynamic>;

    final String questionText = quizData['question'];
    final List<String> options = List<String>.from(quizData['options']);
    final int correctAnswerIndex = quizData['correctAnswerIndex'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.quizList.length,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 10),
          Text("Soal ${_currentIndex + 1} / ${widget.quizList.length}", textAlign: TextAlign.center),
          const SizedBox(height: 20),

          // Container Soal
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue.shade100),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
            ),
            child: Text(
              questionText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // Pilihan Jawaban
          ...List.generate(options.length, (index) {
            final isSelected = _selectedOptionIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedOptionIndex = index),
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
                    Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(child: Text(options[index])),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          // Tombol Jawab
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16)
            ),
            onPressed: _selectedOptionIndex == null ? null : () {
              bool isCorrect = _selectedOptionIndex == correctAnswerIndex;

              // --- LOGIKA HITUNG SKOR ---
              if (isCorrect) {
                _correctAnswers++;
              } else {
                _wrongAnswers++;
              }

              QuickAlert.show(
                  context: context,
                  type: isCorrect ? QuickAlertType.success : QuickAlertType.error,
                  title: isCorrect ? 'Benar!' : 'Salah',
                  text: isCorrect
                      ? 'Lanjut ke soal berikutnya?'
                      : 'Jawaban yang benar: \n${options[correctAnswerIndex]}',
                  confirmBtnText: 'Lanjut',
                  onConfirmBtnTap: () {
                    Navigator.pop(context); // Tutup Alert
                    setState(() {
                      _currentIndex++;
                      _selectedOptionIndex = null; // Reset pilihan
                    });
                  }
              );
            },
            child: const Text("Jawab"),
          )
        ],
      ),
    );
  }

  // --- WIDGET TAMPILAN HASIL AKHIR (Sama persis dengan Firestore) ---
  Widget _buildResultScreen(int totalQuestions) {
    // Hitung Skor (Skala 0 - 100)
    double score = totalQuestions > 0 ? (_correctAnswers / totalQuestions) * 100 : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Hasil Kuis",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: score >= 70 ? Colors.green : Colors.orange, width: 8),
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Text(
                  score.toStringAsFixed(0), // Hilangkan desimal
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: score >= 70 ? Colors.green : Colors.orange,
                  ),
                ),
                const Text("Skor Akhir", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Statistik Benar/Salah
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard("Benar", _correctAnswers, Colors.green),
              _buildStatCard("Salah", _wrongAnswers, Colors.red),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context); // Kembali ke menu sebelumnya
              },
              child: const Text("Selesai & Kembali", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}