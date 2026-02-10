import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  final String topic;

  const QuizScreen({super.key, required this.topic});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // === STATE DATA ===
  bool isLoading = true;
  int? sessionId;
  int currentBatchIndex = 1;
  int currentDifficulty = 1;

  // Data Batch Saat Ini (Berisi beberapa soal sekaligus)
  List<dynamic> currentQuestions = [];

  // Jawaban User (Key: exam_question_id, Value: answer_label)
  Map<int, String> userAnswers = {};

  // Timer untuk hitung waktu per soal
  Map<int, int> thinkingTimePerQuestion = {};
  Timer? _timer;
  int _currentSeconds = 0;

  // PageView untuk navigasi antar soal dalam 1 batch
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // Statistik Akhir
  double totalFinalScore = 0;
  int totalCorrect = 0;
  int totalQuestionsAnswered = 0;

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

  // === TIMER LOGIC ===
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
    thinkingTimePerQuestion[questionId] = _currentSeconds;
    _startTimer();
  }

  // === 1. START EXAM → Dapat Batch 1 langsung ===
  Future<void> _startExamSession() async {
    try {
      final result = await ApiService.startExam(widget.topic);

      if (mounted) {
        setState(() {
          sessionId = result['session_id'];
          currentBatchIndex = result['batch_index'];
          currentQuestions = result['questions'];

          // Ambil difficulty dari soal pertama
          if (currentQuestions.isNotEmpty) {
            currentDifficulty = currentQuestions[0]['difficulty'] ?? 1;
          }

          isLoading = false;
        });
        _startTimer();
      }
    } catch (e) {
      _showErrorAndExit("Gagal memulai ujian: $e");
    }
  }

  // === 2. SUBMIT BATCH → Kirim semua jawaban sekaligus ===
  Future<void> _submitBatch() async {
    // Validasi: Semua soal harus dijawab
    if (userAnswers.length != currentQuestions.length) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Belum Selesai',
        text:
            'Harap jawab semua ${currentQuestions.length} soal sebelum lanjut!',
      );
      return;
    }

    // Rekam waktu soal terakhir
    if (currentQuestions.isNotEmpty) {
      int lastQId = currentQuestions.last['exam_question_id'];
      thinkingTimePerQuestion[lastQId] = _currentSeconds;
    }

    setState(() => isLoading = true);

    // Format data untuk dikirim
    List<Map<String, dynamic>> answersToSend = [];
    userAnswers.forEach((qId, label) {
      answersToSend.add({
        "exam_question_id": qId,
        "answer_label": label,
        "thinking_time": thinkingTimePerQuestion[qId] ?? 0,
      });
    });

    try {
      final result = await ApiService.submitBatch(sessionId!, answersToSend);

      // Update statistik
      int correctCount = result['correct_count'] ?? 0;
      double scoreGained = (result['score_gained'] as num?)?.toDouble() ?? 0;

      setState(() {
        totalFinalScore = (result['total_score'] as num?)?.toDouble() ?? 0;
        totalCorrect += correctCount;
        totalQuestionsAnswered += currentQuestions.length;
      });

      String message = result['message'] ?? '';
      var nextBatch = result['next_batch'];

      // Tampilkan hasil batch
      _showBatchResultDialog(
        correctCount: correctCount,
        totalInBatch: currentQuestions.length,
        scoreGained: scoreGained,
        message: message,
        onContinue: () {
          Navigator.pop(context); // Tutup dialog

          if (nextBatch != null) {
            // === LANJUT KE BATCH BERIKUTNYA ===
            setState(() {
              currentBatchIndex = nextBatch['batch_index'];
              currentQuestions = nextBatch['questions'];
              currentDifficulty = currentQuestions.isNotEmpty
                  ? (currentQuestions[0]['difficulty'] ?? 1)
                  : 1;

              // Reset state untuk batch baru
              userAnswers.clear();
              thinkingTimePerQuestion.clear();
              _currentPageIndex = 0;
              isLoading = false;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_pageController.hasClients) {
                _pageController.jumpToPage(0);
              }
            });
            _startTimer();
          } else {
            // === UJIAN SELESAI ===
            setState(() => isLoading = false);
            _showFinalResultDialog();
          }
        },
      );
    } catch (e) {
      setState(() => isLoading = false);
      _showError("Gagal mengirim jawaban: $e");
    }
  }

  // === DIALOG: Hasil per Batch ===
  void _showBatchResultDialog({
    required int correctCount,
    required int totalInBatch,
    required double scoreGained,
    required String message,
    required VoidCallback onContinue,
  }) {
    QuickAlert.show(
      context: context,
      type: correctCount >= (totalInBatch * 0.6)
          ? QuickAlertType.success
          : QuickAlertType.info,
      title: 'Batch $currentBatchIndex Selesai!',
      text:
          '''
Benar: $correctCount / $totalInBatch
Skor: +${scoreGained.toStringAsFixed(0)}
$message
      ''',
      confirmBtnText: 'Lanjut',
      barrierDismissible: false,
      onConfirmBtnTap: onContinue,
    );
  }

  // === DIALOG: Hasil Akhir ===
  void _showFinalResultDialog() {
    int totalWrong = totalQuestionsAnswered - totalCorrect;
    double percentage = totalQuestionsAnswered > 0
        ? (totalCorrect / totalQuestionsAnswered * 100)
        : 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("🏁 Ujian Selesai!", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                percentage >= 60
                    ? Icons.emoji_events
                    : Icons.sentiment_satisfied,
                size: 60,
                color: percentage >= 60 ? Colors.amber : Colors.blue,
              ),
              const SizedBox(height: 15),
              Text(
                "Skor: ${totalFinalScore.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "${percentage.toStringAsFixed(0)}%",
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
              const Divider(height: 30),
              _buildStatRow("Total Soal", "$totalQuestionsAnswered"),
              _buildStatRow("Benar", "$totalCorrect", color: Colors.green),
              _buildStatRow("Salah", "$totalWrong", color: Colors.red),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text("Kembali ke Menu"),
              ),
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
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
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
      },
    );
  }

  // === BUILD UI ===
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Memuat soal..."),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // === HEADER INFO ===
          _buildHeaderInfo(),

          // === PROGRESS BAR ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressIndicator(
              value: (_currentPageIndex + 1) / currentQuestions.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // === SOAL (PageView) ===
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        "Ujian: ${widget.topic}",
        style: const TextStyle(color: Colors.white),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4FC3F7), Color(0xFF1565C0)],
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Batch & Soal Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Batch $currentBatchIndex",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "Soal ${_currentPageIndex + 1} / ${currentQuestions.length}",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          // Level Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade300, Colors.orange.shade600],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bar_chart, color: Colors.white, size: 18),
                const SizedBox(width: 4),
                Text(
                  "Level $currentDifficulty",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> questionData, int index) {
    int qId = questionData['exam_question_id'];
    String text = questionData['text'];
    List<dynamic> options = questionData['options'];
    bool isLastInBatch = index == currentQuestions.length - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // === KOTAK SOAL ===
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 17, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // === PILIHAN JAWABAN ===
          ...options.map((opt) {
            String label = opt['label'];
            String optText = opt['text'];
            bool isSelected = userAnswers[qId] == label;

            return GestureDetector(
              onTap: () {
                setState(() {
                  userAnswers[qId] = label;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade50 : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: isSelected
                          ? Colors.blue
                          : Colors.grey.shade200,
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        optText,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: Colors.blue),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 30),

          // === TOMBOL NAVIGASI ===
          Row(
            children: [
              // Tombol Kembali
              if (index > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _recordThinkingTime(qId);
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Kembali"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

              if (index > 0) const SizedBox(width: 12),

              // Tombol Lanjut / Submit
              Expanded(
                flex: index > 0 ? 1 : 2,
                child: ElevatedButton.icon(
                  onPressed: userAnswers[qId] == null
                      ? null
                      : () {
                          _recordThinkingTime(qId);
                          if (isLastInBatch) {
                            _submitBatch();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                  icon: Icon(isLastInBatch ? Icons.send : Icons.arrow_forward),
                  label: Text(isLastInBatch ? "Kirim Jawaban" : "Lanjut"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLastInBatch ? Colors.green : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
