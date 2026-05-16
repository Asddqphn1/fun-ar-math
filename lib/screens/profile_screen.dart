import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/translated_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Pelajar';
  String _userEmail = '';
  String _userPhoto = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Pelajar';
      _userEmail = prefs.getString('user_email') ?? '';
      _userPhoto = prefs.getString('user_photo') ?? '';
    });
  }

  Future<void> _logout() async {
    // Show confirmation dialog before logout
    final bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const TranslatedText('Konfirmasi Keluar'),
        content: const TranslatedText('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const TranslatedText('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const TranslatedText('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all saved session data
      
      // Clear Google Auth caching to prompt for selecting account next time
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.disconnect();
      } catch (e) {
        // Just catch silently if error logging out
      }
      
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TranslatedText('Profil Saya', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: _userPhoto.isNotEmpty ? NetworkImage(_userPhoto) : null,
                child: _userPhoto.isEmpty
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                _userName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _userEmail,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              // Custom Logout Button Full Width
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const TranslatedText(
                    'Keluar Akun',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

