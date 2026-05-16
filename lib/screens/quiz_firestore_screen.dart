import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../models/question_model.dart';
import '../services/firebase_service.dart';
import '../core/language_provider.dart';
import '../core/app_strings.dart';
import '../core/translation_service.dart';

class QuizFirestoreScreen extends StatefulWidget {
  final String collectionId;
  final String title;
  final String categoryDoc;

  const QuizFirestoreScreen({
    super.key,
    required this.collectionId,
    required this.categoryDoc,
    required this.title,
  });

  @override
  State<QuizFirestoreScreen> createState() => _QuizFirestoreScreenState();
}

class _QuizFirestoreScreenState extends State<QuizFirestoreScreen> {
  int _currentIndex = 0;
  int? _selectedOptionIndex;

  // --- VARIABEL TAMBAHAN UNTUK SKOR ---
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, _) {
        final lang = langProvider.languageCode;

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
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseService.getQuestions(widget.categoryDoc, widget.collectionId),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.folder_off, size: 60, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(
                        "${widget.collectionId} ${AppStrings.get('questions_not_available', lang)}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              final questions = docs.map((doc) {
                return QuestionModel.fromFirestore(doc.data() as Map<String, dynamic>);
              }).toList();

              return _buildQuizContent(questions, lang);
            },
          ),
        );
      },
    );
  }

  Widget _buildQuizContent(List<QuestionModel> questions, String lang) {
    // --- JIKA KUIS SELESAI, TAMPILKAN HASIL SKOR ---
    if (_currentIndex >= questions.length) {
      return _buildResultScreen(questions.length, lang);
    }

    final question = questions[_currentIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Bar sederhana
          LinearProgressIndicator(
            value: (_currentIndex + 1) / questions.length,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 10),
          Text("${AppStrings.get('question_of', lang)} ${_currentIndex + 1} / ${questions.length}", textAlign: TextAlign.center),
          const SizedBox(height: 20),
          
          // Translated Question
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue.shade100),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
            ),
            child: FutureBuilder<String>(
              future: TranslationService.translate(question.question, lang),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                return Text(snapshot.data!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center);
              }
            ),
          ),
          const SizedBox(height: 20),
          
          // Translated Options
          ...List.generate(question.options.length, (index) {
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
                    Expanded(
                      child: FutureBuilder<String>(
                        future: TranslationService.translate(question.options[index], lang),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const Text('...');
                          return Text(snapshot.data!);
                        }
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
            onPressed: _selectedOptionIndex == null ? null : () async {
              bool isCorrect = _selectedOptionIndex == question.correctAnswerIndex;

              // --- LOGIKA HITUNG SKOR ---
              if (isCorrect) {
                _correctAnswers++;
              } else {
                _wrongAnswers++;
              }

              // Translate the correct answer explanation if wrong
              String correctAnsText = question.options[question.correctAnswerIndex];
              if (!isCorrect && lang != 'id') {
                correctAnsText = await TranslationService.translate(correctAnsText, lang);
              }

              if (!mounted) return;

              QuickAlert.show(
                  context: context,
                  type: isCorrect ? QuickAlertType.success : QuickAlertType.error,
                  title: isCorrect
                      ? '${AppStrings.get('correct', lang)}!'
                      : AppStrings.get('incorrect', lang),
                  text: isCorrect
                      ? AppStrings.get('next_question', lang)
                      : '${AppStrings.get('correct_answer_is', lang)}: \n$correctAnsText',
                  confirmBtnText: AppStrings.get('next', lang),
                  onConfirmBtnTap: () {
                    Navigator.pop(context); // Tutup Alert
                    setState(() {
                      _currentIndex++;
                      _selectedOptionIndex = null; // Reset pilihan
                    });
                  }
              );
            },
            child: Text(AppStrings.get('answer_btn', lang)),
          )
        ],
      ),
    );
  }

  // --- WIDGET TAMPILAN HASIL AKHIR ---
  Widget _buildResultScreen(int totalQuestions, String lang) {
    // Hitung Skor (Skala 0 - 100)
    double score = totalQuestions > 0 ? (_correctAnswers / totalQuestions) * 100 : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('quiz_result', lang),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
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
                Text(AppStrings.get('final_score', lang), style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Statistik Benar/Salah
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(AppStrings.get('correct_label', lang), _correctAnswers, Colors.green),
              _buildStatCard(AppStrings.get('wrong_label', lang), _wrongAnswers, Colors.red),
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
              child: Text(AppStrings.get('finish_and_back', lang), style: const TextStyle(fontSize: 16, color: Colors.white)),
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