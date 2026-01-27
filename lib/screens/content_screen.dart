import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quickalert/quickalert.dart';


enum ContentMode { model, quizLocal, rumus }

class ContentScreen extends StatefulWidget {
  final ContentMode mode;
  final Map<String, dynamic>? data;
  final List<Map<String, dynamic>>? quizList;
  final String title;

  const ContentScreen({super.key, required this.mode, this.data, this.quizList, required this.title});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  int _quizIndex = 0;
  int? _selectedQuizOption;
  bool _dialogDontShowAgain = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == ContentMode.model) _checkArWarning();
  }

  void _checkArWarning() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('showArWarning') ?? true) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showArDialog());
    }
  }

  void _showArDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: const Color(0xFF1E1C3A),
            title: const Text("Peringatan Keamanan", style: TextStyle(color: Colors.white)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text("Perhatikan lingkungan sekitar saat menggunakan AR.", style: TextStyle(color: Colors.white70)),
              Row(children: [
                Checkbox(
                    value: _dialogDontShowAgain,
                    onChanged: (v) => setDialogState(() => _dialogDontShowAgain = v!),
                    fillColor: MaterialStateProperty.all(Colors.white), checkColor: Colors.blue
                ),
                const Text("Jangan tampilkan lagi", style: TextStyle(color: Colors.white, fontSize: 12))
              ])
            ]),
            actions: [
              TextButton(
                child: const Text("Saya Mengerti"),
                onPressed: () async {
                  if (_dialogDontShowAgain) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('showArWarning', false);
                  }
                  Navigator.pop(context);
                },
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4FC3F7), Color(0xFF1565C0)])),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (widget.mode) {
      case ContentMode.model:
        return Column(children: [
          Padding(padding: const EdgeInsets.all(16), child: Text("Ciri-ciri: ${(widget.data!['keterangan'] as List).join('\n')}")),
          Expanded(child: ModelViewer(src: widget.data!['model'], alt: "AR Model", ar: true, autoRotate: true, cameraControls: true))
        ]);
      case ContentMode.rumus:
        List<Widget> sliders = [];
        if (widget.data!['keliling'] != null) sliders.add(Image.asset(widget.data!['keliling'], fit: BoxFit.contain));
        if (widget.data!['luas'] != null) sliders.add(Image.asset(widget.data!['luas'], fit: BoxFit.contain));
        return CarouselSlider(items: sliders, options: CarouselOptions(height: MediaQuery.of(context).size.height, viewportFraction: 1.0));
      case ContentMode.quizLocal:
        if (widget.quizList == null || widget.quizList!.isEmpty) return const Center(child: Text("Soal Kosong"));
        final item = widget.quizList![_quizIndex]['quiz'];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text("Soal ${_quizIndex + 1} / ${widget.quizList!.length}", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)), child: Text(item['question'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            const SizedBox(height: 20),
            ...(item['options'] as List).asMap().entries.map((e) => RadioListTile(
              title: Text(e.value), value: e.key, groupValue: _selectedQuizOption,
              onChanged: (v) => setState(() => _selectedQuizOption = v),
            )),
            ElevatedButton(
                onPressed: _selectedQuizOption == null ? null : () {
                  bool correct = _selectedQuizOption == item['correctAnswerIndex'];
                  QuickAlert.show(context: context, type: correct ? QuickAlertType.success : QuickAlertType.error,
                      title: correct ? "Benar" : "Salah", confirmBtnText: "Lanjut",
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        if (correct && _quizIndex < widget.quizList!.length - 1) {
                          setState(() { _quizIndex++; _selectedQuizOption = null; });
                        }
                      }
                  );
                },
                child: const Text("Jawab")
            )
          ]),
        );
    }
  }
}