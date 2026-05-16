import 'package:flutter/material.dart';
import 'package:geoarappv1/screens/quiz_screen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/menu_card.dart';
import '../widgets/info_button.dart';
import '../widgets/translated_text.dart';
import '../core/language_provider.dart';
import 'sub_menu_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4FC3F7), Color(0xFF1565C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              TranslatedText("Halo, Pelajar!", style: TextStyle(fontSize: 18, color: Colors.white70)),
                              SizedBox(height: 4),
                              TranslatedText("Fun AR Matematika", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                        // Action Buttons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            IconButton(
                              icon: const Icon(Icons.person, color: Colors.white, size: 28),
                              tooltip: "Profil",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                );
                              },
                            ),
                            const InfoButton(),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // GAMBAR AR
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/bangun_datar_image.png'),
                          fit: BoxFit.cover,
                          opacity: 0.3,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Augmented Reality',
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              // BAGIAN GRID MENU
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2, // --- UBAH DISINI: JADI 2 KOLOM ---
                    crossAxisSpacing: 16, // Sedikit diperlebar jaraknya agar rapi
                    mainAxisSpacing: 16, // Sedikit diperlebar jaraknya agar rapi
                    childAspectRatio: 1.1, // --- UBAH DISINI: Disesuaikan agar proporsional (tidak terlalu tinggi) ---
                    children: [
                      _buildMenuItem(context, "Model\n3D Ruang", Icons.view_in_ar, Colors.orange, 'model_ruang', isComingSoon: true),
                      _buildMenuItem(context, "Model\n3D Datar", Icons.change_history, Colors.blue, 'model_datar'),
                      _buildMenuItem(context, "Materi\nB. Ruang", Icons.menu_book, Colors.green, 'materi_ruang', isComingSoon: true),
                      _buildMenuItem(context, "Materi\nB. Datar", Icons.auto_stories, Colors.purple, 'materi_datar'),
                      _buildMenuItem(context, "Soal\nB. Ruang", Icons.quiz, Colors.red, 'soal_ruang'),
                      _buildMenuItem(context, "Soal\nB. Datar", Icons.quiz, Colors.deepPurple, 'soal_datar'),
                      _buildMenuItem(context, "Soal\nUjian", Icons.assignment, Colors.teal, 'soal_ujian'),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  // Widget pembantu menu item
  Widget _buildMenuItem(
      BuildContext context,
      String title,
      IconData icon,
      Color iconColor,
      String menuType, {
        bool isComingSoon = false,
      }) {
    return GestureDetector(
      onTap: isComingSoon
          ? () => QuickAlert.show(context: context, type: QuickAlertType.info, title: 'Segera Hadir!', text: 'Fitur ini sedang dalam pengembangan.')
          : () => _navigateToSubMenu(context, menuType),
      child: Container(
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: iconColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Icon(icon, size: 32, color: iconColor),
            ),
            const SizedBox(height: 12),
            TranslatedText(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
            if (isComingSoon)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: TranslatedText(
                  'Segera Hadir!',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToSubMenu(BuildContext context, String type) {
    // Arahkan semua ke SubMenuScreen agar user bisa pilih topik dulu
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => SubMenuScreen(menuType: type)
    ));
  }

}