import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoarappv1/page/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/language_provider.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup UI System
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  // CEK LOGIN STATUS
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('access_token');

  // [TAMBAHAN 2]: Inisialisasi LanguageProvider dan load preferensi bahasa
  final languageProvider = LanguageProvider();
  await languageProvider.loadLanguage();

  // [TAMBAHAN 3]: Bungkus MyApp dengan MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageProvider),
      ],
      child: MyApp(initialRoute: token != null ? '/home' : '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute; // Terima rute awal

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fun AR Matematika",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      // Tentukan rute
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}