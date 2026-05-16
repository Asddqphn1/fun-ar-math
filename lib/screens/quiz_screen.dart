import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../services/api_service.dart';
import '../core/language_provider.dart';
import '../core/app_strings.dart';
import '../core/translation_service.dart';
import '../widgets/translated_text.dart';

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

  String get _lang => Provider.of<LanguageProvider>(context, listen: false).languageCode;

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
    setState(() => isLoading = true);
    
    try {
      final result = await ApiService.startExam(widget.topic);

      if (mounted) {
        // Cek resume session message
        String msg = result['message'] ?? '';
        if (msg.toLowerCase().contains('melanjutkan')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 4),
            ),
          );
        }

        setState(() {
          sessionId = result['session_id'];
          currentBatchIndex = result['batch_index'];
          currentQuestions = result['questions'];
          
          // Clear state incase of retry or returning to prior 
          userAnswers.clear();          
          thinkingTimePerQuestion.clear();
          _currentPageIndex = 0;

          // Perbaiki masalah state yang hilang saat resume
          // Jika BE mengirim data akumulasi sesi berjalan, maka set nilainya.
          if (result['past_total_correct'] != null) {
            totalCorrect = result['past_total_correct'] ?? 0;
          }
          if (result['past_total_answered'] != null) {
            totalQuestionsAnswered = result['past_total_answered'] ?? 0;
          }
          if (result['past_total_score'] != null) {
            totalFinalScore = (result['past_total_score'] as num).toDouble();
          }

          // Ambil difficulty dari soal pertama
          if (currentQuestions.isNotEmpty) {
            currentDifficulty = currentQuestions[0]['difficulty'] ?? 1;
          }

          isLoading = false;
        });
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(0);
          }
        });
        
        _startTimer();
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      
      // Auto-Cleanup 500 error AI
      if (e.toString().contains('500') || e.toString().contains('Internal Server Error')) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: 'Sistem Sibuk',
          text: 'Gagal menyiapkan soal dari AI. Jangan khawatir, sesi sebelumnya telah dibersihkan. Silakan tekan tombol Mulai Ujian lagi.',
          confirmBtnText: 'Mulai Ujian',
          cancelBtnText: 'Kembali',
          showCancelBtn: true,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            _startExamSession();
          },
          onCancelBtnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        );
      } else {
        _showErrorAndExit("${AppStrings.get('failed_start_exam', _lang)}: $e");
      }
    }
  }

  // === 2. SUBMIT BATCH → Kirim semua jawaban sekaligus ===
  Future<void> _submitBatch() async {
    // Validasi: Semua soal harus dijawab
    if (userAnswers.length != currentQuestions.length) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: AppStrings.get('not_finished', _lang),
        text:
            '${AppStrings.get('answer_all_questions', _lang)} (${currentQuestions.length})',
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
        "time_seconds": thinkingTimePerQuestion[qId] ?? 0,
      });
    });

    try {
      final result = await ApiService.submitBatch(sessionId!, answersToSend);

      // Update statistik
      int correctCount = result['correct_count'] ?? 0;
      double scoreGained = (result['score_gained'] as num?)?.toDouble() ?? 0;
      double avgTime = (result['avg_time_seconds'] as num?)?.toDouble() ?? 0;
      double timeBonus = (result['time_bonus'] as num?)?.toDouble() ?? 0;

      setState(() {
        totalFinalScore = (result['total_score'] as num?)?.toDouble() ?? 0;
        totalCorrect += correctCount;
        totalQuestionsAnswered += currentQuestions.length;
      });

      String message = result['message'] ?? '';
      
      // Translate the feedback message
      if (_lang != 'id') {
        message = await TranslationService.translate(message, _lang);
      }

      var nextBatch = result['next_batch'];

      if (!mounted) return;

      // Tampilkan hasil batch
      _showBatchResultDialog(
        correctCount: correctCount,
        totalInBatch: currentQuestions.length,
        scoreGained: scoreGained,
        message: message,
        avgTime: avgTime,
        timeBonus: timeBonus,
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
      if (mounted) setState(() => isLoading = false);
      _showError("${AppStrings.get('failed_submit', _lang)}: $e");
    }
  }

  // === DIALOG: Hasil per Batch ===
  void _showBatchResultDialog({
    required int correctCount,
    required int totalInBatch,
    required double scoreGained,
    required String message,
    required double avgTime,
    required double timeBonus,
    required VoidCallback onContinue,
  }) {
    final lang = _lang;
    String timeBonusText = timeBonus > 0
        ? '\n${AppStrings.get('time_bonus', lang)}: +${timeBonus.toStringAsFixed(0)}'
        : '';
    QuickAlert.show(
      context: context,
      type: correctCount >= (totalInBatch * 0.6)
          ? QuickAlertType.success
          : QuickAlertType.info,
      title: '${AppStrings.get('batch_label', lang)} $currentBatchIndex ${AppStrings.get('batch_completed', lang)}',
      text:
          '''
${AppStrings.get('correct_count', lang)}: $correctCount / $totalInBatch
${AppStrings.get('score_label', lang)}: +${scoreGained.toStringAsFixed(0)}$timeBonusText
${AppStrings.get('avg_time', lang)}: ${avgTime.toStringAsFixed(1)} ${AppStrings.get('seconds', lang)}
$message
      ''',
      confirmBtnText: AppStrings.get('continue_btn', lang),
      barrierDismissible: false,
      onConfirmBtnTap: onContinue,
    );
  }

  // === DIALOG: Hasil Akhir ===
  void _showFinalResultDialog() {
    final lang = _lang;
    int totalWrong = totalQuestionsAnswered - totalCorrect;
    double percentage = totalQuestionsAnswered > 0
        ? (totalCorrect / totalQuestionsAnswered * 100)
        : 0;

    String grade;
    Color gradeColor;
    String gradeLabel;
    if (percentage >= 90) {
      grade = 'A';
      gradeColor = const Color(0xFF2E7D32);
      gradeLabel = AppStrings.get('grade_excellent', lang);
    } else if (percentage >= 80) {
      grade = 'B+';
      gradeColor = const Color(0xFF388E3C);
      gradeLabel = AppStrings.get('grade_very_good', lang);
    } else if (percentage >= 70) {
      grade = 'B';
      gradeColor = const Color(0xFF1565C0);
      gradeLabel = AppStrings.get('grade_good', lang);
    } else if (percentage >= 60) {
      grade = 'C';
      gradeColor = const Color(0xFFF57F17);
      gradeLabel = AppStrings.get('grade_fair', lang);
    } else {
      grade = 'D';
      gradeColor = const Color(0xFFC62828);
      gradeLabel = AppStrings.get('grade_need_study', lang);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool isCompleting = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 40,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // === HEADER GRADIENT ===
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [gradeColor.withOpacity(0.85), gradeColor],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              percentage >= 60
                                  ? Icons.emoji_events_rounded
                                  : Icons.school_rounded,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            AppStrings.get('exam_finished', lang),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            gradeLabel,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // === SCORE SECTION ===
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: gradeColor.withOpacity(0.25),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Grade
                            Expanded(
                              child: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      grade,
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: gradeColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Grade',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey.shade200,
                            ),
                            // Score
                            Expanded(
                              child: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      totalFinalScore.toStringAsFixed(0),
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: gradeColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppStrings.get('score_label', lang),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey.shade200,
                            ),
                            // Percentage
                            Expanded(
                              child: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${percentage.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: gradeColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    AppStrings.get('accuracy', lang),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // === STATISTICS ===
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          _buildModernStatRow(
                            icon: Icons.assignment_rounded,
                            iconColor: const Color(0xFF1565C0),
                            label: AppStrings.get('total_questions', lang),
                            value: '$totalQuestionsAnswered',
                          ),
                          const SizedBox(height: 10),
                          _buildModernStatRow(
                            icon: Icons.check_circle_rounded,
                            iconColor: const Color(0xFF2E7D32),
                            label: AppStrings.get('correct_answers', lang),
                            value: '$totalCorrect',
                          ),
                          const SizedBox(height: 10),
                          _buildModernStatRow(
                            icon: Icons.cancel_rounded,
                            iconColor: const Color(0xFFC62828),
                            label: AppStrings.get('wrong_answers', lang),
                            value: '$totalWrong',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // === BUTTON ===
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isCompleting
                              ? null
                              : () async {
                                  setDialogState(() => isCompleting = true);
                                  try {
                                    if (sessionId != null) {
                                      await ApiService.completeExam(sessionId!);
                                    }
                                  } catch (e) {
                                    debugPrint('Gagal complete exam: $e');
                                  } finally {
                                    if (mounted) {
                                      Navigator.pop(ctx);
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gradeColor,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shadowColor: gradeColor.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isCompleting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.done_all_rounded, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppStrings.get('done_btn', lang),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModernStatRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: iconColor,
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
    if (mounted) setState(() => isLoading = false);
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: AppStrings.get('error_title', _lang),
      text: msg,
      confirmBtnText: AppStrings.get('back_btn', _lang),
      onConfirmBtnTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  // === BUILD UI ===
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, _) {
        final lang = langProvider.languageCode;

        if (isLoading) {
          return Scaffold(
            appBar: _buildAppBar(lang),
            body: FunLoadingIndicator(
              loadingText: AppStrings.get('loading_questions', lang),
            ),
          );
        }

        return Scaffold(
          appBar: _buildAppBar(lang),
          body: Column(
            children: [
              // === HEADER INFO ===
              _buildHeaderInfo(lang),

              // === PROGRESS BAR ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(
                  value: currentQuestions.isNotEmpty
                      ? (_currentPageIndex + 1) / currentQuestions.length
                      : 0,
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
                    return _buildQuestionCard(currentQuestions[index], index, lang);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(String lang) {
    // Translate topic for UI purposes if necessary
    return AppBar(
      title: FutureBuilder<String>(
        future: TranslationService.translate(widget.topic, lang),
        builder: (context, snapshot) {
          String displayTopic = snapshot.data ?? widget.topic;
          return Text(
            "${AppStrings.get('exam_prefix', lang)}: $displayTopic",
            style: const TextStyle(color: Colors.white),
          );
        }
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

  Widget _buildHeaderInfo(String lang) {
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
                "${AppStrings.get('batch_label', lang)} $currentBatchIndex",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "${AppStrings.get('question_label', lang)} ${_currentPageIndex + 1} / ${currentQuestions.length}",
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
                  "${AppStrings.get('level_label', lang)} $currentDifficulty",
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

  Widget _buildQuestionCard(Map<String, dynamic> questionData, int index, String lang) {
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
            child: TranslatedText(
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
                      child: TranslatedText(
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
                    label: Text(AppStrings.get('back_btn', lang)),
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
                  label: Text(isLastInBatch
                      ? AppStrings.get('send_answers', lang)
                      : AppStrings.get('next', lang)),
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

class FunLoadingIndicator extends StatefulWidget {
  final String loadingText;
  const FunLoadingIndicator({super.key, required this.loadingText});

  @override
  State<FunLoadingIndicator> createState() => _FunLoadingIndicatorState();
}

class _FunLoadingIndicatorState extends State<FunLoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -25 * Curves.easeInOut.transform(_controller.value)),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              ),
              child: const Icon(
                Icons.smart_toy_rounded, // Animasi Robot Loncat agar terkesan Ai/Gaming
                size: 80,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.shade200)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.orange),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.loadingText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
