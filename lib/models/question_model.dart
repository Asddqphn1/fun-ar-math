class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  // Factory untuk mengubah data JSON/Map dari Firestore ke Object QuestionModel
  factory QuestionModel.fromFirestore(Map<String, dynamic> data) {
    // Handle jika field pilihan_ganda berupa Map (A,B,C,D) atau List
    List<String> optionsList = [];

    if (data['pilihan_ganda'] is Map) {
      final choices = data['pilihan_ganda'] as Map<String, dynamic>;
      optionsList = [
        choices['A'].toString(),
        choices['B'].toString(),
        choices['C'].toString(),
        choices['D'].toString(),
      ];
    } else if (data['pilihan_ganda'] is List) {
      optionsList = List<String>.from(data['pilihan_ganda']);
    }

    // Handle kunci jawaban (bisa berupa index int atau string "A","B")
    int correctIndex = 0;
    var key = data['kunci_jawaban'];
    if (key is String) {
      // Konversi "C" -> 2
      correctIndex = key.toUpperCase().codeUnitAt(0) - 'A'.codeUnitAt(0);
    } else if (key is int) {
      correctIndex = key;
    }

    return QuestionModel(
      question: data['pertanyaan'] ?? 'Pertanyaan kosong',
      options: optionsList,
      correctAnswerIndex: correctIndex,
    );
  }
}