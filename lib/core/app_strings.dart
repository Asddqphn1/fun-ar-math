/// Centralized translation dictionary for all UI strings.
/// Access via: AppStrings.get('key', languageCode)
class AppStrings {
  static final Map<String, Map<String, String>> _strings = {
    // ============================================
    // LOGIN PAGE
    // ============================================
    'app_title': {
      'id': 'Fun AR Matematika',
      'en': 'Fun AR Math',
    },
    'login_subtitle': {
      'id': 'Belajar Bangun Ruang dan bangun datar Jadi Nyata',
      'en': 'Make 3D & 2D Shapes Come to Life',
    },
    'welcome': {
      'id': 'Selamat Datang!',
      'en': 'Welcome!',
    },
    'login_instruction': {
      'id': 'Silahkan masuk untuk memulai perjalanan AR kamu.',
      'en': 'Please sign in to start your AR journey.',
    },
    'sign_in_google': {
      'id': 'Masuk dengan Google',
      'en': 'Sign in with Google',
    },
    'login_failed': {
      'id': 'Gagal Masuk',
      'en': 'Login Failed',
    },

    // ============================================
    // HOME SCREEN
    // ============================================
    'greeting': {
      'id': 'Halo, Pelajar!',
      'en': 'Hello, Learner!',
    },
    'augmented_reality': {
      'id': 'Augmented Reality',
      'en': 'Augmented Reality',
    },
    'menu_model_ruang': {
      'id': 'Model\n3D Ruang',
      'en': '3D Solid\nModels',
    },
    'menu_model_datar': {
      'id': 'Model\n3D Datar',
      'en': '2D Shape\nModels',
    },
    'menu_materi_ruang': {
      'id': 'Materi\nB. Ruang',
      'en': 'Solid\nMaterials',
    },
    'menu_materi_datar': {
      'id': 'Materi\nB. Datar',
      'en': '2D Shape\nMaterials',
    },
    'menu_soal_ruang': {
      'id': 'Soal\nB. Ruang',
      'en': 'Solid\nQuiz',
    },
    'menu_soal_ujian': {
      'id': 'Soal\nUjian',
      'en': 'Exam\nQuiz',
    },
    'coming_soon': {
      'id': 'Segera Hadir!',
      'en': 'Coming Soon!',
    },
    'coming_soon_desc': {
      'id': 'Fitur ini sedang dalam pengembangan.',
      'en': 'This feature is under development.',
    },

    // ============================================
    // INFO BUTTON (Tips Dialog)
    // ============================================
    'tips_title': {
      'id': 'Tips Penggunaan AR',
      'en': 'AR Usage Tips',
    },
    'tip_1': {
      'id': 'Arahkan kamera ke permukaan datar untuk hasil terbaik.',
      'en': 'Point the camera at a flat surface for the best result.',
    },
    'tip_2': {
      'id': 'Gunakan di ruangan dengan pencahayaan yang cukup.',
      'en': 'Use in a room with adequate lighting.',
    },
    'tip_3': {
      'id': 'Gerakkan perangkat perlahan untuk pemindaian optimal.',
      'en': 'Move the device slowly for optimal scanning.',
    },
    'tip_4': {
      'id': 'Pastikan selalu ada pengawasan orang tua saat anak menggunakan AR.',
      'en': 'Ensure parental supervision when children use AR.',
    },
    'understood': {
      'id': 'Mengerti',
      'en': 'Got it',
    },

    // ============================================
    // SUB MENU SCREEN
    // ============================================
    'pick_exam_topic': {
      'id': 'Pilih Topik Ujian',
      'en': 'Pick Exam Topic',
    },
    'model_3d_solid': {
      'id': 'Model 3D Bangun Ruang',
      'en': '3D Solid Models',
    },
    'quiz_solid': {
      'id': 'Soal Bangun Ruang',
      'en': 'Solid Shape Quiz',
    },
    'model_3d_flat': {
      'id': 'Model 3D Bangun Datar',
      'en': '2D Shape Models',
    },
    'materi_flat': {
      'id': 'Materi Bangun Datar',
      'en': '2D Shape Materials',
    },
    'quiz_flat': {
      'id': 'Soal Bangun Datar',
      'en': '2D Shape Quiz',
    },
    'adaptive_ai': {
      'id': 'Adaptif AI (Server)',
      'en': 'Adaptive AI (Server)',
    },
    'static_data_not_found': {
      'id': 'Data soal static tidak ditemukan',
      'en': 'Static quiz data not found',
    },
    'ar_solid_developing': {
      'id': 'Fitur AR Bangun Ruang sedang dikembangkan',
      'en': 'AR Solid Shapes feature is under development',
    },
    'content_not_found': {
      'id': 'Data konten tidak ditemukan',
      'en': 'Content data not found',
    },

    // Sub-menu item names (Exam Topics)
    'exam_segitiga': {
      'id': 'Ujian Segitiga',
      'en': 'Triangle Exam',
    },
    'exam_trapesium': {
      'id': 'Ujian Trapesium',
      'en': 'Trapezoid Exam',
    },
    'exam_persegi': {
      'id': 'Ujian Persegi',
      'en': 'Square Exam',
    },

    // Sub-menu item names (3D Solids)
    'kubus': {
      'id': 'Kubus',
      'en': 'Cube',
    },
    'balok': {
      'id': 'Balok',
      'en': 'Cuboid',
    },
    'tabung': {
      'id': 'Tabung',
      'en': 'Cylinder',
    },
    'kerucut': {
      'id': 'Kerucut',
      'en': 'Cone',
    },
    'bola': {
      'id': 'Bola',
      'en': 'Sphere',
    },
    'limas': {
      'id': 'Limas',
      'en': 'Pyramid',
    },
    'prisma': {
      'id': 'Prisma',
      'en': 'Prism',
    },

    // Sub-menu item names (2D Shapes - Models)
    'segitiga_sama_sisi': {
      'id': 'Segitiga Sama Sisi',
      'en': 'Equilateral Triangle',
    },
    'segitiga_sama_kaki': {
      'id': 'Segitiga Sama Kaki',
      'en': 'Isosceles Triangle',
    },
    'segitiga_sembarang': {
      'id': 'Segitiga Sembarang',
      'en': 'Scalene Triangle',
    },
    'segitiga_siku': {
      'id': 'Segitiga Siku-siku',
      'en': 'Right Triangle',
    },
    'persegi': {
      'id': 'Persegi',
      'en': 'Square',
    },
    'persegi_panjang': {
      'id': 'Persegi Panjang',
      'en': 'Rectangle',
    },
    'jajar_genjang': {
      'id': 'Jajar Genjang',
      'en': 'Parallelogram',
    },
    'belah_ketupat': {
      'id': 'Belah Ketupat',
      'en': 'Rhombus',
    },
    'layang_layang': {
      'id': 'Layang-layang',
      'en': 'Kite',
    },
    'trapesium': {
      'id': 'Trapesium',
      'en': 'Trapezoid',
    },

    // Sub-menu item names (2D Shapes - Materi/Rumus)
    'rumus_segitiga': {
      'id': 'Rumus Segitiga',
      'en': 'Triangle Formulas',
    },
    'rumus_persegi': {
      'id': 'Rumus Persegi',
      'en': 'Square Formulas',
    },
    'rumus_persegi_panjang': {
      'id': 'Rumus Persegi Panjang',
      'en': 'Rectangle Formulas',
    },
    'rumus_jajar_genjang': {
      'id': 'Rumus Jajar Genjang',
      'en': 'Parallelogram Formulas',
    },
    'rumus_belah_ketupat': {
      'id': 'Rumus Belah Ketupat',
      'en': 'Rhombus Formulas',
    },
    'rumus_layang_layang': {
      'id': 'Rumus Layang-layang',
      'en': 'Kite Formulas',
    },
    'rumus_trapesium': {
      'id': 'Rumus Trapesium',
      'en': 'Trapezoid Formulas',
    },

    // Sub-menu item names (2D quiz - static)
    'soal_segitiga': {
      'id': 'Soal Segitiga',
      'en': 'Triangle Quiz',
    },
    'hitung_segitiga': {
      'id': 'Hitung Segitiga',
      'en': 'Calculate Triangle',
    },
    'soal_segi_empat': {
      'id': 'Soal Segi Empat',
      'en': 'Quadrilateral Quiz',
    },
    'hitung_segi_empat': {
      'id': 'Hitung Segi Empat',
      'en': 'Calculate Quadrilateral',
    },

    // Sub-menu item names (Firebase quiz)
    'segitiga_2': {
      'id': 'Segitiga 2',
      'en': 'Triangle 2',
    },

    // ============================================
    // CONTENT SCREEN (Model 3D & Materi)
    // ============================================
    'ar_warning_title': {
      'id': 'Peringatan Keamanan',
      'en': 'Safety Warning',
    },
    'ar_warning_text': {
      'id': 'Perhatikan lingkungan sekitar saat menggunakan AR.',
      'en': 'Be aware of your surroundings when using AR.',
    },
    'dont_show_again': {
      'id': 'Jangan tampilkan lagi',
      'en': "Don't show again",
    },
    'i_understand': {
      'id': 'Saya Mengerti',
      'en': 'I Understand',
    },
    'characteristics': {
      'id': 'Ciri-ciri',
      'en': 'Characteristics',
    },
    'quiz_empty': {
      'id': 'Soal Kosong',
      'en': 'No Questions',
    },
    'question_of': {
      'id': 'Soal',
      'en': 'Question',
    },
    'correct': {
      'id': 'Benar',
      'en': 'Correct',
    },
    'incorrect': {
      'id': 'Salah',
      'en': 'Incorrect',
    },
    'next': {
      'id': 'Lanjut',
      'en': 'Next',
    },
    'answer_btn': {
      'id': 'Jawab',
      'en': 'Answer',
    },

    // ============================================
    // QUIZ SCREEN (API / Exam)
    // ============================================
    'exam_prefix': {
      'id': 'Ujian',
      'en': 'Exam',
    },
    'loading_questions': {
      'id': 'Memuat soal...',
      'en': 'Loading questions...',
    },
    'batch_label': {
      'id': 'Batch',
      'en': 'Batch',
    },
    'question_label': {
      'id': 'Soal',
      'en': 'Question',
    },
    'level_label': {
      'id': 'Level',
      'en': 'Level',
    },
    'not_finished': {
      'id': 'Belum Selesai',
      'en': 'Not Finished',
    },
    'answer_all_questions': {
      'id': 'Harap jawab semua soal sebelum lanjut!',
      'en': 'Please answer all questions before continuing!',
    },
    'batch_completed': {
      'id': 'Selesai!',
      'en': 'Completed!',
    },
    'correct_count': {
      'id': 'Benar',
      'en': 'Correct',
    },
    'score_label': {
      'id': 'Skor',
      'en': 'Score',
    },
    'time_bonus': {
      'id': 'Bonus Waktu',
      'en': 'Time Bonus',
    },
    'avg_time': {
      'id': 'Rata-rata Waktu',
      'en': 'Average Time',
    },
    'seconds': {
      'id': 'detik',
      'en': 'seconds',
    },
    'continue_btn': {
      'id': 'Lanjut',
      'en': 'Continue',
    },
    'exam_finished': {
      'id': 'UJIAN SELESAI',
      'en': 'EXAM FINISHED',
    },
    'grade_excellent': {
      'id': 'Luar Biasa!',
      'en': 'Excellent!',
    },
    'grade_very_good': {
      'id': 'Sangat Baik!',
      'en': 'Very Good!',
    },
    'grade_good': {
      'id': 'Baik',
      'en': 'Good',
    },
    'grade_fair': {
      'id': 'Cukup',
      'en': 'Fair',
    },
    'grade_need_study': {
      'id': 'Perlu Belajar Lagi',
      'en': 'Need More Study',
    },
    'accuracy': {
      'id': 'Akurasi',
      'en': 'Accuracy',
    },
    'total_questions': {
      'id': 'Total Soal',
      'en': 'Total Questions',
    },
    'correct_answers': {
      'id': 'Jawaban Benar',
      'en': 'Correct Answers',
    },
    'wrong_answers': {
      'id': 'Jawaban Salah',
      'en': 'Wrong Answers',
    },
    'done_btn': {
      'id': 'Selesai',
      'en': 'Done',
    },
    'error_title': {
      'id': 'Terjadi Kesalahan',
      'en': 'An Error Occurred',
    },
    'back_btn': {
      'id': 'Kembali',
      'en': 'Back',
    },
    'send_answers': {
      'id': 'Kirim Jawaban',
      'en': 'Submit Answers',
    },
    'failed_start_exam': {
      'id': 'Gagal memulai ujian',
      'en': 'Failed to start exam',
    },
    'failed_submit': {
      'id': 'Gagal mengirim jawaban',
      'en': 'Failed to submit answers',
    },

    // ============================================
    // QUIZ STATIC & FIRESTORE SCREEN
    // ============================================
    'quiz_data_empty': {
      'id': 'Data soal kosong.',
      'en': 'No quiz data available.',
    },
    'quiz_result': {
      'id': 'Hasil Kuis',
      'en': 'Quiz Result',
    },
    'final_score': {
      'id': 'Skor Akhir',
      'en': 'Final Score',
    },
    'correct_label': {
      'id': 'Benar',
      'en': 'Correct',
    },
    'wrong_label': {
      'id': 'Salah',
      'en': 'Wrong',
    },
    'finish_and_back': {
      'id': 'Selesai & Kembali',
      'en': 'Finish & Back',
    },
    'correct_answer_is': {
      'id': 'Jawaban yang benar',
      'en': 'The correct answer is',
    },
    'next_question': {
      'id': 'Lanjut ke soal berikutnya?',
      'en': 'Continue to the next question?',
    },
    'questions_not_available': {
      'id': 'belum tersedia di server.',
      'en': 'not yet available on server.',
    },

    // ============================================
    // ADAPTIVE EXAM SCREEN
    // ============================================
    'failed_start': {
      'id': 'Gagal memulai ujian',
      'en': 'Failed to start exam',
    },
    'answer_all_batch': {
      'id': 'Harap jawab semua soal di batch ini sebelum lanjut!',
      'en': 'Please answer all questions in this batch before continuing!',
    },
    'failed_send_batch': {
      'id': 'Gagal mengirim batch',
      'en': 'Failed to submit batch',
    },
    'exam_done_emoji': {
      'id': '🏁 Ujian Selesai!',
      'en': '🏁 Exam Done!',
    },
    'total_soal': {
      'id': 'Total Soal',
      'en': 'Total Questions',
    },
    'level_journey': {
      'id': 'Perjalanan Level:',
      'en': 'Level Journey:',
    },
    'close_btn': {
      'id': 'Tutup',
      'en': 'Close',
    },
    'send_batch': {
      'id': 'Kirim Batch',
      'en': 'Submit Batch',
    },
    'next_btn': {
      'id': 'Selanjutnya',
      'en': 'Next',
    },
    'connection_failed': {
      'id': 'Tidak dapat terhubung ke server',
      'en': 'Cannot connect to server',
    },
    'connection_timeout': {
      'id': 'Koneksi timeout',
      'en': 'Connection timeout',
    },

    // ============================================
    // STATIC DATA — Keterangan (Characteristics)
    // ============================================
    // Segitiga
    'char_segitiga_sama_sisi': {
      'id': 'Tiga sisi sama panjang dan tiga sudut sama besar (masing-masing 60°).',
      'en': 'Three equal sides and three equal angles (60° each).',
    },
    'char_segitiga_sama_kaki': {
      'id': 'Dua sisi sama panjang, dua sudut sama besar.',
      'en': 'Two equal sides, two equal angles.',
    },
    'char_segitiga_sembarang': {
      'id': 'Semua sisi berbeda panjang dan semua sudut berbeda besar.',
      'en': 'All sides have different lengths and all angles are different.',
    },
    'char_segitiga_siku': {
      'id': 'Salah satu sudutnya tepat 90° (siku-siku).',
      'en': 'One angle is exactly 90° (right angle).',
    },
    'char_segitiga_lancip': {
      'id': 'Segitiga yang semua sudutnya kurang dari 90°.',
      'en': 'A triangle where all angles are less than 90°.',
    },
    'char_segitiga_tumpul': {
      'id': 'Segitiga yang salah satu sudutnya lebih dari 90°.',
      'en': 'A triangle where one angle is greater than 90°.',
    },
    // Segiempat
    'char_persegi': {
      'id': '4 sisi sama panjang\n4 sudut siku-siku\nDiagonal sama panjang dan tegak lurus',
      'en': '4 equal sides\n4 right angles\nEqual diagonals that are perpendicular',
    },
    'char_persegi_panjang': {
      'id': 'Sisi berhadapan sama panjang dan sejajar\n4 sudut siku-siku\nDiagonal sama panjang',
      'en': 'Opposite sides are equal and parallel\n4 right angles\nEqual diagonals',
    },
    'char_jajar_genjang': {
      'id': 'Sisi berhadapan sama panjang dan sejajar\nSudut berhadapan sama besar\nDiagonal membagi dua',
      'en': 'Opposite sides are equal and parallel\nOpposite angles are equal\nDiagonals bisect each other',
    },
    'char_belah_ketupat': {
      'id': '4 sisi sama panjang\nDiagonal saling tegak lurus\nSudut berhadapan sama besar',
      'en': '4 equal sides\nDiagonals are perpendicular\nOpposite angles are equal',
    },
    'char_layang_layang': {
      'id': '2 pasang sisi sama panjang\nDiagonal saling tegak lurus, hanya satu membagi diagonal lainnya',
      'en': '2 pairs of equal adjacent sides\nDiagonals are perpendicular, only one bisects the other',
    },
    'char_trapesium': {
      'id': 'Hanya 1 pasang sisi sejajar\nBentuk bisa sembarang, sama kaki, atau siku-siku',
      'en': 'Only 1 pair of parallel sides\nCan be scalene, isosceles, or right-angled',
    },

    // ============================================
    // LANGUAGE SWITCH
    // ============================================
    'language': {
      'id': 'Bahasa',
      'en': 'Language',
    },
    'indonesian': {
      'id': 'Indonesia',
      'en': 'Indonesian',
    },
    'english': {
      'id': 'Inggris',
      'en': 'English',
    },
  };

  /// Get a translated string by key and language code
  static String get(String key, String langCode) {
    return _strings[key]?[langCode] ?? _strings[key]?['id'] ?? key;
  }
}
