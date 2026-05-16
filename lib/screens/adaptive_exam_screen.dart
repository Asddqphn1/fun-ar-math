import 'dart:async'; // Untuk Timer
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../services/api_service.dart';

class AdaptiveExamScreen extends StatefulWidget {
  final String topic;

  const AdaptiveExamScreen({super.key, required this.topic});

  @override
  State<AdaptiveExamScreen> createState() => _AdaptiveExamScreenState();
}

class _AdaptiveExamScreenState extends State<AdaptiveExamScreen> {
  // State Data
  bool isLoading = true;
  int? sessionId;
  int currentBatchIndex = 1;

  // Data Batch Saat Ini
  List<dynamic> currentQuestions = [];

  // Jawaban User (Disimpan Lokal dulu sebelum dikirim)
  // Key: exam_question_id, Value: Label Jawaban (A, B, C, D)
  Map<int, String> userAnswers = {};

  // Timer Logic (Opsional: Hitung waktu per soal)
  Map<int, int> thinkingTimePerQuestion = {}; // Key: ID Soal, Value: Detik
  Timer? _timer;
  int _currentSeconds = 0;

  // PageView Controller
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // Statistik Akhir (Dikumpulkan dari response backend)
  double totalFinalScore = 0;
  int totalCorrect = 0;
  int totalQuestionsAnswered = 0;
  List<String> difficultyHistory = []; // Melacak level tiap batch

  @override
  void initState() {
    super.initState();
    _startExamSession();
  }

  @override
  void dispose() {
    _stopTimer();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _stopTimer();
    _currentSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentSeconds++;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _recordThinkingTime(int questionId) {
    // Simpan waktu untuk soal sebelumnya saat pindah halaman
    thinkingTimePerQuestion[questionId] = _currentSeconds;
    _startTimer(); // Reset timer untuk soal berikutnya
  }

  // --- 1. START EXAM (BATCH 1) ---
  void _startExamSession() async {
    try {
      final result = await ApiService.startExam(widget.topic);
      if (mounted) {
        setState(() {
          sessionId = result['session_id'];
          currentBatchIndex = result['batch_index'];
          currentQuestions = result['questions'];
          isLoading = false;

          // Catat history level batch 1
          if (currentQuestions.isNotEmpty) {
            difficultyHistory.add("Level ${currentQuestions[0]['difficulty']}");
          }
        });
        _startTimer();
      }
    } catch (e) {
      _showError("Gagal memulai ujian: $e");
      Navigator.pop(context);
    }
  }

  // --- 2. SUBMIT BATCH ---
  void _submitBatch() async {
    // Validasi: Pastikan semua soal di batch ini sudah dijawab
    if (userAnswers.length != currentQuestions.length) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Belum Selesai',
        text: 'Harap jawab semua soal di batch ini sebelum lanjut!',
      );
      return;
    }

    // Stop timer soal terakhir
    int lastQId = currentQuestions.last['exam_question_id'];
    thinkingTimePerQuestion[lastQId] = _currentSeconds;

    setState(() => isLoading = true);

    // Format data untuk dikirim ke Backend
    List<Map<String, dynamic>> answersToSend = [];
    userAnswers.forEach((qId, label) {
      answersToSend.add({
        "exam_question_id": qId,
        "answer_label": label,
        "time_seconds": thinkingTimePerQuestion[qId] ?? 0,
      });
    });

    try {
      final result = await ApiService.submitBatch(sessionId!, answersToSend);

      // Update Statistik dari Response
      double avgTime = (result['avg_time_seconds'] as num?)?.toDouble() ?? 0;
      double timeBonus = (result['time_bonus'] as num?)?.toDouble() ?? 0;
      setState(() {
        totalFinalScore = (result['total_score'] as num).toDouble();
        totalCorrect += (result['correct_count'] as int);
        totalQuestionsAnswered += currentQuestions.length;
      });

      String message = result['message']; // "Level Naik!", etc.
      var nextBatch = result['next_batch'];

      if (nextBatch != null) {
        // --- MASIH ADA BATCH LANJUTAN ---
        setState(() {
          currentBatchIndex = nextBatch['batch_index'];
          currentQuestions = nextBatch['questions'];

          // Reset State untuk Batch Baru
          userAnswers.clear();
          thinkingTimePerQuestion.clear();
          _currentPageIndex = 0;
          _pageController.jumpToPage(0);
          isLoading = false;

          // Catat history level
          if (currentQuestions.isNotEmpty) {
            difficultyHistory.add("Level ${currentQuestions[0]['difficulty']}");
          }
        });
        _startTimer();

        // Tampilkan Info progress
        String bonusInfo = timeBonus > 0
            ? ' | Bonus Waktu: +${timeBonus.toStringAsFixed(0)}'
            : '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "$message. Rata-rata: ${avgTime.toStringAsFixed(1)}s$bonusInfo. Lanjut ke Batch $currentBatchIndex",
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        // --- UJIAN SELESAI (Next Batch NULL) ---
        setState(() => isLoading = false);
        _showFinalResultDialog();
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError("Gagal mengirim batch: $e");
    }
  }

  // --- UI HASIL AKHIR ---
  void _showFinalResultDialog() {
    int totalWrong = totalQuestionsAnswered - totalCorrect;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("🏁 Ujian Selesai!", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 60, color: Colors.amber),
              const SizedBox(height: 10),
              Text(
                "Skor Akhir: ${totalFinalScore.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Divider(),
              _buildStatRow("Total Soal", "$totalQuestionsAnswered"),
              _buildStatRow("Benar", "$totalCorrect", color: Colors.green),
              _buildStatRow("Salah", "$totalWrong", color: Colors.red),
              const SizedBox(height: 10),
              const Text(
                "Perjalanan Level:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                difficultyHistory.join(" ➡ "),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // Tutup Dialog
                Navigator.pop(context); // Kembali ke Home
              },
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Batch $currentBatchIndex (${widget.topic})"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Indikator Soal (1/3, 2/3, dst)
          Padding(
            padding: const EdgeInsets.all(10),
            child: LinearProgressIndicator(
              value: (_currentPageIndex + 1) / currentQuestions.length,
              backgroundColor: Colors.grey[200],
              color: Colors.orange,
            ),
          ),

          // AREA SOAL (PageView)
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // User wajib jawab/klik next, ga boleh swipe sembarangan
              itemCount: currentQuestions.length,
              onPageChanged: (index) {
                setState(() => _currentPageIndex = index);
              },
              itemBuilder: (context, index) {
                return _buildQuestionCard(currentQuestions[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> questionData, int index) {
    int qId = questionData['exam_question_id'];
    String text = questionData['text'];
    int difficulty = questionData['difficulty'];
    List<dynamic> options = questionData['options'];

    // Cek apakah ini soal terakhir di batch
    bool isLastInBatch = index == currentQuestions.length - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Badge Level
          Align(
            alignment: Alignment.centerRight,
            child: Chip(
              label: Text("Level $difficulty"),
              backgroundColor: Colors.blue.shade100,
              avatar: const Icon(Icons.bar_chart, size: 16),
            ),
          ),

          // Teks Soal
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),

          // Pilihan Ganda
          ...options.map((opt) {
            String label = opt['label'];
            bool isSelected = userAnswers[qId] == label;

            return GestureDetector(
              onTap: () {
                setState(() {
                  userAnswers[qId] = label;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade50 : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isSelected
                          ? Colors.blue
                          : Colors.grey.shade200,
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        opt['text'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 30),

          // Tombol Navigasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol Back (Hilang di soal pertama)
              index > 0
                  ? ElevatedButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      ),
                      child: const Text("Kembali"),
                    )
                  : const SizedBox(),

              // Tombol Next atau Submit
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLastInBatch ? Colors.green : Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Rekam waktu sebelum pindah
                  _recordThinkingTime(qId);

                  if (isLastInBatch) {
                    _submitBatch(); // Kirim ke Backend
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Text(isLastInBatch ? "Kirim Batch" : "Selanjutnya"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
