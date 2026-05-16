import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../core/language_provider.dart';
import '../widgets/translated_text.dart';
import '../data/static_data.dart';
import 'content_screen.dart';       // Untuk Materi & Model
import 'quiz_static_screen.dart';   // Untuk Soal Static (Offline)
import 'quiz_firestore_screen.dart';// Untuk Soal Firebase (Lama)
import 'quiz_screen.dart';          // Untuk Soal API/FastAPI (Baru)

class SubMenuScreen extends StatelessWidget {
  final String menuType;

  const SubMenuScreen({super.key, required this.menuType});

  @override
  Widget build(BuildContext context) {
    String title = "";
    List<Map<String, dynamic>> items = [];

    // --- 1. MENU UJIAN (KE API FASTAPI) ---
    if (menuType == 'soal_ujian') {
      title = "Pilih Topik Ujian";
      items = [
        // Bangun Datar
        {'name': 'Ujian Segitiga', 'ref': 'Segitiga', 'icon': Icons.change_history, 'type': 'exam'},
        {'name': 'Ujian Trapesium', 'ref': 'Trapesium', 'icon': Icons.terrain, 'type': 'exam'},
        {'name': 'Ujian Persegi', 'ref': 'Persegi', 'icon': Icons.crop_square, 'type': 'exam'},
        
        // Bangun Ruang
        {'name': 'Ujian Kubus', 'ref': 'Kubus', 'icon': Icons.crop_square, 'type': 'exam'},
        {'name': 'Ujian Balok', 'ref': 'Balok', 'icon': Icons.rectangle_outlined, 'type': 'exam'},
        {'name': 'Ujian Tabung', 'ref': 'Tabung', 'icon': Icons.circle, 'type': 'exam'},
        {'name': 'Ujian Kerucut', 'ref': 'Kerucut', 'icon': Icons.change_history, 'type': 'exam'},
        {'name': 'Ujian Bola', 'ref': 'Bola', 'icon': Icons.sports_soccer, 'type': 'exam'},
        {'name': 'Ujian Limas', 'ref': 'Limas', 'icon': Icons.details, 'type': 'exam'},
        {'name': 'Ujian Prisma', 'ref': 'Prisma', 'icon': Icons.view_in_ar, 'type': 'exam'},
      ];
    }
    // --- 2. MENU BANGUN RUANG (MODEL & SOAL FIREBASE) ---
    else if (menuType == 'model_ruang' || menuType == 'soal_ruang') {
      title = menuType == 'model_ruang' ? "Model 3D Bangun Ruang" : "Soal Bangun Ruang";

      // Tentukan tipe: Kalau menu 'soal_ruang', kita anggap tipe 'firebase'
      // Kalau model, tipe 'model' (default null/handled di bawah)
      String itemType = menuType == 'soal_ruang' ? 'firebase' : 'model';

      items = [
        {'name': 'Kubus', 'id': 'kubus', 'icon': Icons.crop_square, 'type': itemType},
        {'name': 'Balok', 'id': 'balok', 'icon': Icons.rectangle_outlined, 'type': itemType},
        {'name': 'Tabung', 'id': 'tabung', 'icon': Icons.circle, 'type': itemType},
        {'name': 'Kerucut', 'id': 'kerucut', 'icon': Icons.change_history, 'type': itemType},
        {'name': 'Bola', 'id': 'bola', 'icon': Icons.sports_soccer, 'type': itemType},
        {'name': 'Limas', 'id': 'limas_segitiga_segiempat', 'icon': Icons.details, 'type': itemType},
        {'name': 'Prisma', 'id': 'prisma_segitiga_2', 'icon': Icons.view_in_ar, 'type': itemType},
      ];
    }
    // --- 3. MENU MODEL DATAR ---
    else if (menuType == 'model_datar') {
      title = "Model 3D Bangun Datar";
      items = [
        {'name': 'Segitiga Sama Sisi', 'ref': 'Segitiga sama sisi', 'icon': Icons.change_history},
        {'name': 'Segitiga Sama Kaki', 'ref': 'Segitiga sama kaki', 'icon': Icons.change_history},
        {'name': 'Segitiga Sembarang', 'ref': 'Segitiga sembarang', 'icon': Icons.change_history},
        {'name': 'Segitiga Siku-siku', 'ref': 'Segitiga siku-siku', 'icon': Icons.change_history},
        {'name': 'Persegi', 'ref': 'Persegi', 'icon': Icons.crop_square},
        {'name': 'Persegi Panjang', 'ref': 'Persegi Panjang', 'icon': Icons.rectangle_outlined},
        {'name': 'Jajar Genjang', 'ref': 'Jajar Genjang', 'icon': Icons.transform},
        {'name': 'Belah Ketupat', 'ref': 'Belah Ketupat', 'icon': Icons.diamond_outlined},
        {'name': 'Layang-layang', 'ref': 'Layang-layang', 'icon': Icons.navigation_outlined},
        {'name': 'Trapesium', 'ref': 'Trapesium', 'icon': Icons.terrain},
      ];
    }
    // --- 4. MENU MATERI DATAR ---
    else if (menuType == 'materi_datar') {
      title = "Materi Bangun Datar";
      items = [
        {'name': 'Rumus Segitiga', 'ref': 'Keliling dan Luas Segitiga', 'icon': Icons.calculate},
        {'name': 'Rumus Persegi', 'ref': 'Persegi', 'icon': Icons.calculate},
        {'name': 'Rumus Persegi Panjang', 'ref': 'Persegi Panjang', 'icon': Icons.calculate},
        {'name': 'Rumus Jajar Genjang', 'ref': 'Jajar genjang', 'icon': Icons.calculate},
        {'name': 'Rumus Belah Ketupat', 'ref': 'Belah ketupat', 'icon': Icons.calculate},
        {'name': 'Rumus Layang-layang', 'ref': 'Layang-layang', 'icon': Icons.calculate},
        {'name': 'Rumus Trapesium', 'ref': 'Trapesium', 'icon': Icons.calculate},
      ];
    }
    // --- 5. MENU SOAL DATAR (CAMPURAN STATIC & FIREBASE) ---
    else if (menuType == 'soal_datar') {
      title = "Soal Bangun Datar";
      items = [
        // Soal Static (Offline)
        {'name': 'Soal Segitiga', 'ref': 'Pertemuan 1: Jenis-jenis Segitiga', 'icon': Icons.quiz, 'type': 'static'},
        {'name': 'Hitung Segitiga', 'ref': 'Pertemuan 2: Keliling dan Luas Segitiga', 'icon': Icons.calculate, 'type': 'static' },
        {'name': 'Soal Segi Empat', 'ref': 'Pertemuan 3: Jenis-jenis Segiempat', 'icon': Icons.quiz, 'type': 'static'},
        {'name': 'Hitung Segi Empat', 'ref': 'Pertemuan 4: Keliling dan Luas SegiEmpat', 'icon': Icons.calculate, 'type': 'static' },

        // Soal Firebase (Online)
        {'name': 'Belah Ketupat', 'id': 'belah_ketupat', 'icon': FontAwesomeIcons.gem, 'type': 'firebase'},
        {'name': 'Jajar Genjang', 'id': 'jajargenjang', 'icon': FontAwesomeIcons.linesLeaning, 'type': 'firebase'},
        {'name': 'Persegi', 'id': 'persegi', 'icon': FontAwesomeIcons.square, 'type': 'firebase'},
        {'name': 'Layang-layang', 'id': 'layang-layang', 'icon': FontAwesomeIcons.paperPlane, 'type': 'firebase'},
        {'name': 'Persegi Panjang', 'id': 'persegi_panjang', 'icon': Icons.rectangle_outlined, 'type': 'firebase'},
        {'name': 'Segitiga 2', 'id': 'segitiga', 'icon': FontAwesomeIcons.caretUp, 'type': 'firebase'},
        {'name': 'Trapesium', 'id': 'trapesium', 'icon': FontAwesomeIcons.dungeon, 'type': 'firebase'},
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: TranslatedText(title, style: const TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4FC3F7), Color(0xFF1565C0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              context.read<LanguageProvider>().toggleLanguage();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 40),
            ),
            child: Text(
              context.watch<LanguageProvider>().languageCode == 'id' ? '🇮🇩' : '🇬🇧',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[50], // Background yang lembut
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 6, offset: const Offset(0, 3)),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'], color: Colors.blue.shade700, size: 24),
                ),
                title: TranslatedText(
                  item['name'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                onTap: () => _handleNavigation(context, item),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, Map<String, dynamic> item) {
    String? type = item['type'];

    // --- 1. NAVIGASI KE API FASTAPI (UJIAN BARU) ---
    if (type == 'exam') {
      Navigator.push(context, MaterialPageRoute(
        // Kita pakai QuizScreen yang BARU (Api)
        builder: (context) => QuizScreen(topic: item['ref']),
      ));
    }

    // --- 2. NAVIGASI KE FIREBASE (KUIS LAMA) ---
    else if (type == 'firebase') {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => QuizFirestoreScreen(
          collectionId: item['id'], // ID dokumen di Firestore
          categoryDoc: menuType == 'soal_ruang' ? 'bangun_ruang' : 'bangun_datar', // Sesuaikan dengan bangun_ruang atau bangun_datar
          title: item['name'],
        ),
      ));
    }

    // --- 3. NAVIGASI KE STATIC (KUIS LOKAL) ---
    else if (type == 'static') {
      var list = StaticData.findQuizListByChapter(item['ref']);
      if (list != null && list.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => QuizStaticScreen(
                quizList: list,
                title: item['name']
            )
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data soal static tidak ditemukan")));
      }
    }

    // --- 4. FITUR COMING SOON (MODEL RUANG) ---
    // Khusus Model 3D Ruang yang belum ada datanya
    else if (menuType == 'model_ruang') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur AR Bangun Ruang sedang dikembangkan")));
    }

    // --- 5. NAVIGASI MODEL & MATERI (CONTENT SCREEN) ---
    else {
      Widget? destination;
      if (menuType == 'model_datar') {
        var data = StaticData.findModelByName(item['ref']);
        if(data != null) destination = ContentScreen(mode: ContentMode.model, data: data, title: item['name']);
      } else if (menuType == 'materi_datar') {
        var data = StaticData.findMateriByName(item['ref']);
        if(data != null) destination = ContentScreen(mode: ContentMode.rumus, data: data, title: item['name']);
      }

      if (destination != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data konten tidak ditemukan")));
      }
    }
  }
}