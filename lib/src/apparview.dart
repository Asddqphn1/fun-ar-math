import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class WidgetDasar extends StatelessWidget {
  const WidgetDasar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fun AR Matematika",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Recommended for modern UI
      ),
      home: const WidgetBody(),
    );
  }
}

class WidgetBody extends StatefulWidget {
  const WidgetBody({super.key});

  @override
  State<WidgetBody> createState() => _WidgetBodyState();
}

enum AppState { welcome, modelView, quizView }

class _WidgetBodyState extends State<WidgetBody> {
  AppState _currentAppState = AppState.welcome;
  String titleSidebar = 'Silahkan pilih materi';
  String? _selectedModel;

  // --- STATE BARU UNTUK NAVIGASI KUIS ---
  List<Map<String, dynamic>>? _currentQuizList;
  int _currentQuizIndex = 0;

  int? _selectedOptionIndex; // Untuk melacak jawaban yang dipilih user

  bool isLoading = false;
  int? _expandedIndex;

  // Updated menu items with subtitles
  final List<Map<String, dynamic>> menuitems = [
    {
      'title': 'Pertemuan 1: Jenis-jenis Segitiga',
      'subtitle': 'Mengenali dan membedakan jenis-jenis segitiga. ',
      'icon': Icons.looks_one, // Kept for logic, not displayed
      'subbab': [
        {'name': 'Segitiga sama sisi', 'model': 'assets/models/segitiga_sama_sisi.glb'},
        {'name': 'Segitiga sama kaki', 'model': 'assets/models/segitiga_sama_kaki.glb'},
        {'name': 'Segitiga sembarang', 'model': 'assets/models/segitiga_sembarang.glb'},
        {'name': 'Segitiga siku-siku', 'model': 'assets/models/segitiga_siku.glb'},
        {'name': 'Segitiga Lancip', 'model': 'assets/models/segitiga_lancip.glb'},
        {'name': 'Segitiga tumpul', 'model': 'assets/models/segitiga_tumpul.glb'},
      ]
    },
    {
      'title': 'Pertemuan 2: Latihan soal',
      'subtitle': 'Latihan dan Praktik SegiTiga',
      'icon': Icons.looks_two,
      'subbab': [
        // Soal ditambahkan di sini
        {
          'name': 'Soal 1',
          'quiz': {
            'question': 'Sebuah segitiga memiliki tiga sisi yang sama panjang.',
            'options': ['Sama Kaki', 'Sama Sisi', 'Siku-siku'],
            'correctAnswerIndex': 1,
          }
        },
        {
          'name': 'Soal 2',
          'quiz': {
            'question': 'Sebuah segitiga memiliki dua sisi sama panjang dan satu berbeda.',
            'options': ['Sama Sisi', 'Sama Kaki', 'Sembarang'],
            'correctAnswerIndex': 1,
          }
        },
        {
          'name': 'Soal 3',
          'quiz': {
            'question': 'Sebuah segitiga memiliki semua sisi berbeda panjang.',
            'options': ['Sembarang', 'Sama Kaki', 'Sama Sisi'],
            'correctAnswerIndex': 0,
          }
        },
      ]
    },
    {
      'title': 'Pertemuan 3: Jenis-jenis Segiempat',
      'subtitle': 'Mengidentifikasi dan menyebutkan jenis-jenis segiempat',
      'icon': Icons.looks_3,
      'subbab': [
        {'name': 'Persegi', 'model': 'assets/models/persegi.glb'},
        {'name': 'Persegi Panjang', 'model': 'assets/models/persegiPanjang.glb'},
        {'name': 'Jajar Genjang', 'model': 'assets/models/jajar_genjang.glb'},
        {'name': 'Belah Ketupat', 'model': 'assets/models/belah_ketupat.glb'},
        {'name': 'Layang-layang', 'model': 'assets/models/layang_layang.glb'},
        {'name': 'Trapesium', 'model': 'assets/models/trapesium.glb'},
      ]
    },
    {
      'title': 'Pertemuan 4: Latihan soal',
      'subtitle': 'Latihan dan Praktik SegiEmpat',
      'icon': Icons.looks_two,
      'subbab': [
        // Soal ditambahkan di sini
        {
          'name': 'Soal 1',
          'quiz': {
            'question': 'Sebuah segiempat memiliki empat sisi sama panjang dan empat sudut siku-siku. Apa nama segiempat ini?',
            'options': ['Persegi Panjang', 'Persegi', 'Jajar Genjang'],
            'correctAnswerIndex': 1,
          }
        },
        {
          'name': 'Soal 2',
          'quiz': {
            'question': 'Sebuah segiempat memiliki dua pasang sisi yang sama panjang dan empat sudut siku-siku. Jenis segiempat ini?',
            'options': ['Persegi Panjang', 'Trapesium', 'Layang-layang'],
            'correctAnswerIndex': 0,
          }
        },
        {
          'name': 'Soal 3',
          'quiz': {
            'question': 'Segiempat dengan empat sisi sama panjang tetapi sudut tidak siku-siku. Jenisnya?',
            'options': ['Belah Ketupat', 'Persegi Panjang', 'Layang-layang'],
            'correctAnswerIndex': 0,
          }
        },
      ]
    },

  ];

  void _onSubTopicSelected(Map<String, dynamic> subTopic, String parentTitle, List<Map<String, dynamic>> topicList, int startIndex) {
    setState(() {
      isLoading = true;
      _selectedOptionIndex = null; // Reset pilihan jawaban

      // Cek apakah yang dipilih adalah model 3D atau kuis
      if (subTopic.containsKey('model') && subTopic['model'] != null) {
        _currentAppState = AppState.modelView;
        _selectedModel = subTopic['model'];
        _currentQuizList = null;
        titleSidebar = 'Anda memilih: $parentTitle > ${subTopic['name']}';

      } else if (subTopic.containsKey('quiz')) {
        _currentAppState = AppState.quizView;
        _currentQuizList = topicList; // Simpan seluruh daftar soal
        _currentQuizIndex = startIndex; // Tentukan indeks awal
        _selectedModel = null;
        // titleSidebar akan di-handle di buildQuizView

      } else {
        // Jika tidak ada model atau kuis, kembali ke halaman utama
        _resetToWelcomeScreen();
      }
    });

    Navigator.of(context).pop(); // Tutup drawer

    // Simulasi loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void _resetToWelcomeScreen() {
    setState(() {
      _currentAppState = AppState.welcome;
      _selectedModel = null;
      _currentQuizList = null;
      _currentQuizIndex = 0;
      titleSidebar = 'Silahkan pilih materi';
    });
  }

  // --- FUNGSI NAVIGASI KUIS ---
  void _goToNextQuestion() {
    if (_currentQuizList != null && _currentQuizIndex < _currentQuizList!.length - 1) {
      setState(() {
        _currentQuizIndex++;
        _selectedOptionIndex = null; // Reset pilihan jawaban untuk soal baru
      });
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuizIndex > 0) {
      setState(() {
        _currentQuizIndex--;
        _selectedOptionIndex = null; // Reset pilihan jawaban
      });
    }
  }

  // --- WIDGET TAMPILAN KUIS DIPERBARUI ---
  Widget _buildQuizView() {
    if (_currentQuizList == null || _currentQuizList!.isEmpty) {
      return const Center(child: Text("Soal tidak ditemukan."));
    }

    // Ambil data soal yang sedang aktif
    final currentQuizItem = _currentQuizList![_currentQuizIndex];
    final quiz = currentQuizItem['quiz'] as Map<String, dynamic>;
    final options = quiz['options'] as List<String>;
    final quizTitle = "Pertemuan 2: Latihan soal > ${currentQuizItem['name']}";


    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            quizTitle, // Judul dinamis berdasarkan soal saat ini
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          // Kotak Pertanyaan
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              quiz['question'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
            ),
          ),
          const SizedBox(height: 32),
          // Pilihan Jawaban
          ...List.generate(options.length, (index) {
            final isSelected = _selectedOptionIndex == index;
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedOptionIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade100 : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? Colors.blue.shade700 : Colors.grey.shade500,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      options[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
          // Tombol Periksa Jawaban
          ElevatedButton(
            onPressed: _selectedOptionIndex == null
                ? null // Tombol non-aktif jika belum ada jawaban
                : () {
              // Logika untuk memeriksa jawaban
              final bool isCorrect = _selectedOptionIndex == quiz['correctAnswerIndex'];
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(isCorrect ? "Jawaban Benar! 🎉" : "Jawaban Salah", style: TextStyle(color: isCorrect ? Colors.green.shade800 : Colors.red.shade800)),
                  content: Text(isCorrect ? "Kerja bagus! Anda telah memilih jawaban yang tepat." : "Jangan menyerah, coba pelajari lagi materinya."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Periksa Jawaban", style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 24),

          // --- BAGIAN BARU: NAVIGASI SOAL ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol Kembali
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.blue.shade100),
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue.shade800),
                // Tombol non-aktif jika ini soal pertama
                onPressed: _currentQuizIndex > 0 ? _goToPreviousQuestion : null,
              ),
              // Indikator nomor soal
              Text(
                "Soal ${ _currentQuizIndex + 1 } dari ${ _currentQuizList!.length }",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // Tombol Selanjutnya
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.blue.shade100),
                icon: Icon(Icons.arrow_forward_ios, color: Colors.blue.shade800),
                // Tombol non-aktif jika ini soal terakhir
                onPressed: _currentQuizIndex < _currentQuizList!.length - 1 ? _goToNextQuestion : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET MENU DIPERBARUI UNTUK MENGIRIM INFO LEBIH ---
  Widget _buildMenuItem(Map<String, dynamic> item, int index) {
    final bool isExpanded = _expandedIndex == index;
    final List<Map<String, dynamic>> subTopics = item['subbab'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _expandedIndex = isExpanded ? null : index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      child: Text('${index + 1}'),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
            // Animated visibility for the sub-topics
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                color: Colors.grey.shade50,
                width: double.infinity,
                child: !isExpanded
                    ? const SizedBox.shrink()
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Text(
                        'Klik untuk melihat detail materi pembelajaran ini.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ),
                    // Menggunakan asMap().entries.map untuk mendapatkan indeks
                    ...subTopics.asMap().entries.map((entry) {
                      int subIndex = entry.key;
                      Map<String, dynamic> subTopic = entry.value;
                      return ListTile(
                        contentPadding: const EdgeInsets.only(left: 30.0, right: 16.0),
                        title: Text(subTopic['name']),
                        onTap: () => _onSubTopicSelected(subTopic, item['title'], subTopics, subIndex),
                        dense: true,
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Logika kembali disesuaikan untuk state yang baru
      canPop: _currentAppState == AppState.welcome,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        _resetToWelcomeScreen();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // Tombol kembali muncul di halaman model & kuis
          leading: _currentAppState != AppState.welcome
              ? IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _resetToWelcomeScreen,
          )
              : null,
          title: const Text('Fun AR Math', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue.shade700,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          backgroundColor: Colors.grey[100],
          child: Column(
            children: [
              AppBar(
                title: const Text("Daftar Pertemuan", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.blue.shade700,
                automaticallyImplyLeading: false, // Menghilangkan tombol kembali di dalam drawer
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8.0),
                  itemCount: menuitems.length,
                  itemBuilder: (context, index) {
                    final item = menuitems[index];
                    // Panggil fungsi _buildMenuItem yang akan kita tambahkan lagi
                    return _buildMenuItem(item, index);
                  },
                ),
              ),
            ],
          ),
        ),
        // --- LOGIKA BODY DIPERBARUI MENGGUNAKAN SWITCH ---
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : switch (_currentAppState) {
          AppState.welcome => _buildWelcomeScreen(),
          AppState.modelView => _buildModelViewer(),
          AppState.quizView => _buildQuizView(),
        },
      ),
    );
  }


  // Welcome screen widget
  Widget _buildWelcomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Silahkan pilih materi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buka menu samping dan pilih model 3D untuk memulai pengalaman AR',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/images/bangun_datar_image.png'),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            child: const Center(
              child: Text(
                'AR',
                style: TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFFF1F8E9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tips Penggunaan',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 12),
                _buildTipItem('Arahkan kamera ke permukaan datar untuk hasil terbaik.'),
                const SizedBox(height: 8),
                _buildTipItem('Gunakan di ruangan dengan pencahayaan yang cukup.'),
                const SizedBox(height: 8),
                _buildTipItem('Gerakkan perangkat perlahan untuk pemindaian optimal.'),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // Model viewer widget
  Widget _buildModelViewer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            titleSidebar,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: ModelViewer(
                src: _selectedModel!, // The '!' is safe here because we check for null before calling this builder
                alt: "Model 3D",
                ar: true,
                arModes: const ['scene-viewer', 'webxr', 'quick-look'],
                autoRotate: true,
                arScale: ArScale.fixed,
                cameraControls: true,
                shadowIntensity: 1,
                backgroundColor: const Color(0xFFFAFAFA),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for tips
  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}