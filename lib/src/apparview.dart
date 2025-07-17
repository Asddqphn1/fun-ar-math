import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quickalert/quickalert.dart';

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

enum AppState { welcome, modelView, quizView, rumusView }

class _WidgetBodyState extends State<WidgetBody> {
  AppState _currentAppState = AppState.welcome;
  String titleSidebar = 'Silahkan pilih materi';
  String? _selectedModel;

  List<Map<String, dynamic>>? _currentQuizList;
  int _currentQuizIndex = 0;
  int? _selectedOptionIndex;

  bool isLoading = false;
  int? _expandedIndex;

  // --- VARIABEL BARU UNTUK STATE CHECKBOX DIALOG ---
  bool _dialogDontShowAgain = false;


  final List<Map<String, dynamic>> menuitems = [
    {
      'title': 'Pertemuan 1: Jenis-jenis Segitiga',
      'subtitle': 'Mengenali dan membedakan jenis-jenis segitiga. ',
      'icon': Icons.looks_one,
      'subbab': [
        {'name': 'Materi AR', 'isHeader': true},
        ...[
        {'name': 'Segitiga sama sisi', 'model': 'assets/models/segitiga_sama_sisi.glb', 'keterangan' : ['Tiga sisi sama panjang dan tiga sudut sama besar (masing-masing 60°).']},
        {'name': 'Segitiga sama kaki', 'model': 'assets/models/segitiga_sama_kaki.glb', 'keterangan' : ['Dua sisi sama panjang, dua sudut sama besar.']},
        {'name': 'Segitiga sembarang', 'model': 'assets/models/segitiga_sembarang.glb', 'keterangan' : [' Semua sisi berbeda panjang dan semua sudut berbeda besar.']},
        {'name': 'Segitiga siku-siku', 'model': 'assets/models/segitiga_siku.glb', 'keterangan' : ['Salah satu sudutnya tepat 90° (siku-siku). ']},
        {'name': 'Segitiga Lancip', 'model': 'assets/models/segitiga_lancip.glb', 'keterangan' : [' Segitiga yang semua sudutnya kurang dari 90° ']},
        {'name': 'Segitiga tumpul', 'model': 'assets/models/segitiga_tumpul.glb', 'keterangan' : [' Segitiga yang salah satu sudutnya lebih dari 90°.']},
        ],
        {'name': 'Latihan Soal', 'isHeader': true},
        ...[
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
          {
            'name': 'Soal 4',
            'quiz': {
              'question': 'Segitiga dengan satu sudut 90°.',
              'options': ['Tumpul', 'Lancip', 'Siku-siku'],
              'correctAnswerIndex': 2,
            }
          },
          {
            'name': 'Soal 5',
            'quiz': {
              'question': 'Semua sudutnya kurang dari 90°. ',
              'options': [ 'Lancip','Tumpul','Siku-siku' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 6',
            'quiz': {
              'question': 'Salah satu sudutnya lebih dari 90°.',
              'options': ['Tumpul','Lancip', 'Sama Kaki'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 7',
            'quiz': {
              'question': 'Jika panjang sisi-sisi segitiga adalah 5 cm, 5 cm, dan 8 cm.',
              'options': [ 'Sama Sisi','Sama Kaki','Sembarang'],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 8',
            'quiz': {
              'question': 'Jika panjang sisi-sisi segitiga adalah 6 cm, 7 cm, dan 8 cm. ',
              'options': ['Sama Kaki','Sembarang','Sama Sisi'],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 9',
            'quiz': {
              'question': 'Segitiga dengan sudut-sudut 60°, 60°, dan 60°',
              'options': ['Siku-siku','Sama Sisi','Tumpul' ],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 10',
            'quiz': {
              'question': 'Sudut-sudut segitiga adalah 30°, 60°, dan 90°.',
              'options': [ 'Siku-siku','Tumpul','Sama Kaki'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 11',
            'quiz': {
              'question': 'Segitiga dengan dua sudut sama besar. ',
              'options': [ 'Sama Kaki','Sembarang','Lancip' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 12',
            'quiz': {
              'question': 'Sudut terbesar pada segitiga adalah 110°. ',
              'options': ['Tumpul','Lancip','Siku-siku'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 13',
            'quiz': {
              'question': 'Segitiga dengan panjang sisi 7 cm, 7 cm, dan 7 cm.',
              'options': [ 'Sama Sisi','Sama Kaki', 'Sembarang'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 14',
            'quiz': {
              'question': 'Segitiga dengan sudut 80°, 50°, dan 50°.',
              'options': [ 'Siku-siku','Sama Kaki','Tumpul' ],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 15',
            'quiz': {
              'question': ' Sisi dan sudut tidak ada yang sama.',
              'options': ['Sembaran','Sama Kaki','Sama Sisi'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 16',
            'quiz': {
              'question': 'Tiga sudutnya: 89°, 45°, dan 46°.',
              'options': ['Lancip','Tumpul', 'Siku-siku'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 17',
            'quiz': {
              'question': 'Tiga sudutnya: 100°, 40°, 40°.',
              'options': [ 'Siku-siku','Tumpul','Lancip' ],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 18',
            'quiz': {
              'question': 'Segitiga dengan satu sudut 90° dan dua sisi sama panjang.',
              'options': [ 'Sama Kaki dan Siku-siku','Sama Sisi dan Tumpul','Sembarang dan Lancip'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 19',
            'quiz': {
              'question': 'Segitiga dengan satu sudut lebih dari 90° dan semua sisi berbeda.',
              'options': ['Sembarang dan Tumpul', 'Sama Sisi dan Lancip', 'Sama Kaki dan Siku-siku'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 20',
            'quiz': {
              'question': 'Segitiga dengan semua sudut kurang dari 90° dan semua sisi berbeda.',
              'options': ['Sembarang dan Lancip', 'Sama Sisi dan Tumpul', 'Sama Kaki dan Siku-siku'],
              'correctAnswerIndex': 0,
            }
          },
        ]
      ],

    },
    {
      'title': 'Pertemuan 2: Keliling dan Luas Segitiga',
      'subtitle': 'Menghitung keliling dan luas segitiga dari contoh nyata',
      'icon': Icons.looks_two,
      'subbab': [
        {'name': 'Materi Keliling dan Luas Segitiga', 'isHeader': true},
        ...[
          {'name': 'Keliling dan Luas Segitiga', 'keliling' : 'assets/luas-keliling/keliling-segitiga.jpg', 'luas' : 'assets/luas-keliling/luas-segitiga.jpg'},
        ],
        {'name': 'Latihan Soal', 'isHeader': true},
        ...[
          {
            'name': 'Soal 1',
            'quiz': {
              'question': 'Sebuah segitiga memiliki sisi 5 cm, 7 cm, dan 10 cm. Hitung keliling segitiga tersebut!',
              'options': ['22 cm','17 cm','25 cm' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 2',
            'quiz': {
              'question': 'Segitiga dengan alas 8 cm dan tinggi 5 cm. Hitung luasnya!',
              'options': ['20 cm²','40 cm²', '13 cm²'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 3',
            'quiz': {
              'question': 'Segitiga sama sisi dengan sisi 6 cm. Hitung kelilingnya!',
              'options': ['18 cm','12 cm', '36 cm'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 4',
            'quiz': {
              'question': 'Segitiga sama sisi dengan panjang sisi 4 cm dan tinggi 3,46 cm. Hitung luasnya!',
              'options': ['6,92 cm²','8 cm²','12 cm²' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 5',
            'quiz': {
              'question': 'Sebuah segitiga siku-siku dengan alas 6 cm dan tinggi 4 cm. Hitung luasnya!',
              'options': ['12 cm²','7 cm²','14 cm²' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 6',
            'quiz': {
              'question': 'Segitiga dengan sisi 7 cm, 9 cm, dan 12 cm. Hitung kelilingnya!',
              'options': ['28 cm','18 cm','30 cm'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 7',
            'quiz': {
              'question': 'Segitiga dengan alas 10 cm dan tinggi 6 cm. Hitung luasnya!',
              'options': ['30 cm²','60 cm²','40 cm²'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 8',
            'quiz': {
              'question': 'Segitiga sama kaki dengan sisi kaki 5 cm dan alas 6 cm. Tinggi segitiga adalah 4 cm. Hitung luasnya!',
              'options': ['12 cm²','24 cm²','20 cm²'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 9',
            'quiz': {
              'question': 'Segitiga dengan panjang sisi 5 cm, 5 cm, dan 8 cm. Hitung kelilingnya!',
              'options': ['18 cm','20 cm','16 cm' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 10',
            'quiz': {
              'question': 'Segitiga dengan alas 12 cm dan tinggi 7 cm. Hitung luasnya!',
              'options': ['42 cm²','84 cm²','19 cm²'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 11',
            'quiz': {
              'question': 'Sebuah segitiga sama sisi dengan keliling 24 cm. Berapa panjang sisi segitiga itu?',
              'options': ['6 cm','8 cm', '12 cm' ],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 12',
            'quiz': {
              'question': 'Segitiga dengan alas 9 cm dan tinggi 5 cm. Hitung luasnya!',
              'options': ['22,5 cm²','45 cm²','14 cm²'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 13',
            'quiz': {
              'question': 'Segitiga dengan sisi 3 cm, 4 cm, dan 5 cm. Hitung kelilingnya!',
              'options': ['12 cm','10 cm','15 cm' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 14',
            'quiz': {
              'question': 'Segitiga dengan alas 15 cm dan tinggi 10 cm. Hitung luasnya!',
              'options': [ '75 cm²', '150 cm²','50 cm²'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 15',
            'quiz': {
              'question': 'Segitiga sama kaki dengan sisi kaki 7 cm dan alas 10 cm, tinggi 6 cm. Hitung luasnya!',
              'options': ['30 cm²','42 cm²','36 cm²'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 16',
            'quiz': {
              'question': 'Segitiga dengan sisi 8 cm, 6 cm, dan 10 cm. Hitung kelilingnya!',
              'options': ['24 cm', '20 cm','18 cm' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 17',
            'quiz': {
              'question': 'Segitiga dengan alas 14 cm dan tinggi 9 cm. Hitung luasnya!',
              'options': ['63 cm²','126 cm²', '42 cm²' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 18',
            'quiz': {
              'question': 'Segitiga dengan sisi 9 cm, 12 cm, dan 15 cm. Hitung kelilingnya!',
              'options': ['36 cm','27 cm','30 cm' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 19',
            'quiz': {
              'question': 'Segitiga dengan alas 7 cm dan tinggi 8 cm. Hitung luasnya!',
              'options': ['28 cm²','56 cm²', '15 cm²'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 20',
            'quiz': {
              'question': 'Segitiga sama sisi dengan panjang sisi 10 cm. Hitung keliling dan luasnya (tinggi ≈ 8,66 cm)!',
              'options': ['Keliling = 30 cm, Luas = 43,3 cm²','Keliling = 20 cm, Luas = 50 cm²','Keliling = 30 cm, Luas = 50 cm²'],
              'correctAnswerIndex': 0,
            }
          },
        ]

      ]
    },
    {
      'title': 'Pertemuan 3: Jenis-jenis Segiempat',
      'subtitle': 'Mengidentifikasi dan menyebutkan jenis-jenis segiempat',
      'icon': Icons.looks_3,
      'subbab': [
        {'name': 'Materi AR', 'isHeader': true},
        ...[
          {'name': 'Persegi', 'model': 'assets/models/persegi.glb', 'keterangan' : ['4 sisi sama panjang', '4 sudut siku-siku','Diagonal sama panjang dan tegak lurus']},
          {'name': 'Persegi Panjang', 'model': 'assets/models/persegiPanjang.glb', 'keterangan' : ['Sisi berhadapan sama panjang dan sejajar', '4 sudut siku-siku','Diagonal sama panjang']},
          {'name': 'Jajar Genjang', 'model': 'assets/models/jajar_genjang.glb', 'keterangan' : [ 'Sisi berhadapan sama panjang dan sejajar','Sudut berhadapan sama besar', 'Diagonal membagi dua' ] },
          {'name': 'Belah Ketupat', 'model': 'assets/models/belah_ketupat.glb', 'keterangan' : [ '4 sisi sama panjang', 'Diagonal saling tegak lurus' ,'Sudut berhadapan sama besar']},
          {'name': 'Layang-layang', 'model': 'assets/models/layang.glb', 'keterangan' : ['2 pasang sisi sama panjang','Diagonal saling tegak lurus, hanya satu membagi diagonal lainnya']},
          {'name': 'Trapesium', 'model': 'assets/models/trapesium.glb', 'keterangan' : ['Hanya 1 pasang sisi sejajar', 'Bentuk bisa sembarang, sama kaki, atau siku-siku']},
        ],
        {'name': 'Latihan Soal', 'isHeader': true},
        ...[
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
              'question': 'Segiempat dengan dua pasang sisi sejajar, sisi yang berhadapan sama panjang, dan sudut tidak siku-siku. Apa namanya?',
              'options': [ 'Jajar Genjang','Persegi','Trapesium'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 4',
            'quiz': {
              'question': 'Segiempat dengan empat sisi sama panjang tetapi sudut tidak siku-siku. Jenisnya?',
              'options': ['Belah Ketupat', 'Persegi Panjang', 'Layang-layang'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 5',
            'quiz': {
              'question': 'Segiempat yang hanya memiliki satu pasang sisi sejajar. Nama segiempat ini?',
              'options': [ 'Jajar Genjang','Trapesium','Persegi' ],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 6',
            'quiz': {
              'question': 'Segiempat dengan dua pasang sisi sama panjang yang berdekatan, tetapi tidak sejajar. Jenis segiempat apa ini?',
              'options': ['Layang-layang', 'Belah Ketupat','Persegi Panjang'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 7',
            'quiz': {
              'question': 'Segiempat yang sudutnya semuanya 90°, tetapi sisi tidak semua sama panjang. Apa namanya?',
              'options': ['Persegi','Persegi Panjang','Trapesium'],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 8',
            'quiz': {
              'question': 'Segiempat yang memiliki diagonal sama panjang dan saling tegak lurus, serta sisi-sisinya sama panjang. Jenis segiempat?',
              'options': ['Persegi','Belah Ketupat','Jajar Genjang' ],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 9',
            'quiz': {
              'question': 'Sebuah segiempat memiliki dua sisi sejajar yang panjangnya berbeda. Apa jenis segiempat ini?',
              'options': ['Trapesium','Persegi','Jajar Genjang'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 10',
            'quiz': {
              'question': 'Segiempat yang memiliki dua pasang sisi sejajar dan sudutnya tidak semua siku-siku. Apa namanya?',
              'options': ['Persegi','Jajar Genjang','Layang-layang' ],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 11',
            'quiz': {
              'question': 'Segiempat dengan empat sisi sama panjang dan empat sudut sama besar. Jenis segiempat ini?',
              'options': ['Persegi', 'Belah Ketupat','Layang-layang' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 12',
            'quiz': {
              'question': 'Segiempat dengan dua pasang sisi sama panjang, sisi bersebelahan sama panjang, dan diagonal saling tegak lurus tapi tidak sama panjang. Jenis segiempat ini?',
              'options': ['Layang-layang','Persegi','Jajar Genjang'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 13',
            'quiz': {
              'question': 'Sebuah segiempat memiliki diagonal yang sama panjang dan berpotongan tegak lurus. Segiempat ini bisa disebut?',
              'options': ['Persegi Panjang','Persegi','Layang-layang' ],
              'correctAnswerIndex': 1,
            }
          },
          {
            'name': 'Soal 14',
            'quiz': {
              'question': 'Segiempat dengan sisi yang berhadapan sama panjang dan sudut berhadapan sama besar, tetapi sudut bukan 90°. Jenis segiempat?',
              'options': [ 'Jajar Genjang','Persegi','Trapesium'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 15',
            'quiz': {
              'question': ' Segiempat yang memiliki satu pasang sisi sejajar, sisi lain tidak sejajar. Nama segiempat ini?',
              'options': ['Trapesium','Belah Ketupat','Persegi Panjang' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 16',
            'quiz': {
              'question': 'Segiempat dengan diagonal yang tidak sama panjang dan tidak saling tegak lurus. Apa jenis segiempat ini?',
              'options': ['Jajar Genjang','Persegi','Layang-layang' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 17',
            'quiz': {
              'question': 'Segiempat yang sisi-sisinya tidak sama panjang, tetapi memiliki dua pasang sisi sejajar. Jenis segiempat?',
              'options': ['Jajar Genjang','Persegi Panjang','Trapesium' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 18',
            'quiz': {
              'question': 'Segiempat dengan empat sisi sama panjang dan diagonal saling tegak lurus. Jenis segiempat ini?',
              'options': [ 'Belah Ketupat','Persegi Panjang','Layang-layang'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 19',
            'quiz': {
              'question': 'Sebuah segiempat memiliki empat sudut sama besar dan sisi yang berbeda panjang. Apa nama segiempat ini?',
              'options': ['Persegi Panjang','Persegi','Trapesium'],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 20',
            'quiz': {
              'question': 'Segiempat yang memiliki dua pasang sisi sama panjang dan diagonal saling tegak lurus, tetapi sudut tidak siku-siku. Jenis segiempat?',
              'options': ['Layang-layang','Belah Ketupat','Persegi'],
              'correctAnswerIndex': 1,
            }
          },
        ]
      ]
    },
    {
      'title': 'Pertemuan 4: Keliling dan Luas SegiEmpat',
      'subtitle': 'Menghitung keliling dan luas SegiEmpat dari contoh nyata',
      'icon': Icons.looks_4,
      'subbab': [
        {'name': 'Materi Keliling dan Luas SegiEmpat', 'isHeader': true},
        ...[
          {'name': 'Keliling dan Luas Persegi', 'keliling' : 'assets/luas-keliling/keliling-persegi.jpg', 'luas' : 'assets/luas-keliling/luas-persegi.jpg'},
          {'name': 'Keliling dan Luas Persegi Panjang', 'keliling' : 'assets/luas-keliling/keliling-persegiPanjang.jpg', 'luas' : 'assets/luas-keliling/luas-persegiPanjang.jpg'},
          {'name': 'Keliling dan Luas Jajar genjang', 'keliling' : 'assets/luas-keliling/keliling-jajargenjang.jpg', 'luas' : 'assets/luas-keliling/luas-jajarGenjang.jpg'},
          {'name': 'Keliling dan Luas Belah ketupat', 'keliling' : 'assets/luas-keliling/keliling-belah-ketupat.jpg', 'luas' : 'assets/luas-keliling/luas-belahKetupat.jpg'},
          {'name': 'Keliling dan Luas Layang-layang', 'keliling' : 'assets/luas-keliling/keliling-layang-layang.jpg', 'luas' : 'assets/luas-keliling/luas-layang-layang.jpg'},
          {'name': 'Keliling dan Luas Trapesium', 'keliling' : 'assets/luas-keliling/keliling-trapesium.jpg', 'luas' : 'assets/luas-keliling/luas-trapesium.jpg'},

        ],
        {'name': 'Latihan Soal', 'isHeader': true},
        ...[
          {
            'name': 'Soal 1',
            'quiz': {
              'question': 'Sebuah persegi memiliki sisi 6 cm. Berapa kelilingnya?',
              'options': ['24 cm','12 cm','36 cm' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            'name': 'Soal 2',
            'quiz': {
              'question': 'Sebuah persegi panjang memiliki panjang 8 cm dan lebar 5 cm. Berapa luasnya?',
              'options': ['40 cm²','13 cm²','26 cm²' ],
              'correctAnswerIndex': 0,
            }
          },
          {
            "name": "Soal 3",
            "quiz": {
              "question": "Sisi sebuah persegi adalah 9 cm. Berapa luasnya?",
              "options": ["81 cm²", "18 cm²", "36 cm²"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 4",
            "quiz": {
              "question": "Panjang dan lebar persegi panjang adalah 12 cm dan 4 cm. Hitung kelilingnya!",
              "options": ["32 cm", "16 cm", "48 cm"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 5",
            "quiz": {
              "question": "Sebuah jajar genjang memiliki alas 10 cm dan tinggi 6 cm. Berapa luasnya?",
              "options": ["60 cm²", "16 cm²", "80 cm²"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 6",
            "quiz": {
              "question": "Jajar genjang dengan dua sisi masing-masing 7 cm dan 12 cm. Hitung kelilingnya!",
              "options": ["38 cm", "40 cm", "42 cm"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 7",
            "quiz": {
              "question": "Sebuah belah ketupat memiliki diagonal 10 cm dan 8 cm. Hitung luasnya!",
              "options": ["40 cm²", "80 cm²", "48 cm²"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 8",
            "quiz": {
              "question": "Belah ketupat dengan sisi 9 cm. Berapa kelilingnya?",
              "options": ["36 cm", "18 cm", "20 cm"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 9",
            "quiz": {
              "question": "Trapesium memiliki sisi sejajar 10 cm dan 6 cm, serta tinggi 4 cm. Berapa luasnya?",
              "options": ["32 cm²", "20 cm²", "64 cm²"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 10",
            "quiz": {
              "question": "Trapesium memiliki keempat sisi: 10 cm, 6 cm, 5 cm, 7 cm. Hitung kelilingnya!",
              "options": ["28 cm", "25 cm", "30 cm"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 11",
            "quiz": {
              "question": "Sebuah layang-layang memiliki diagonal 6 cm dan 10 cm. Hitung luasnya!",
              "options": ["30 cm²", "40 cm²", "60 cm²"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 12",
            "quiz": {
              "question": "Layang-layang memiliki sisi 5 cm dan 7 cm (sepasang). Berapa kelilingnya?",
              "options": ["24 cm", "20 cm", "28 cm"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 13",
            "quiz": {
              "question": "Persegi panjang dengan panjang 15 cm dan lebar 3 cm. Berapa luasnya?",
              "options": ["45 cm²", "30 cm²", "18 cm²"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 14",
            "quiz": {
              "question": "Persegi dengan keliling 36 cm. Berapa panjang sisinya?",
              "options": ["9 cm", "6 cm", "12 cm"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 15",
            "quiz": {
              "question": "Trapesium dengan sisi sejajar 12 cm dan 8 cm, serta tinggi 5 cm. Hitung luasnya!",
              "options": ["50 cm²", "60 cm²", "40 cm²"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 16",
            "quiz": {
              "question": "Sebuah belah ketupat memiliki sisi 10 cm. Berapa kelilingnya?",
              "options": ["40 cm", "20 cm", "30 cm"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 17",
            "quiz": {
              "question": "Jajar genjang dengan alas 7 cm dan tinggi 5 cm. Berapa luasnya?",
              "options": ["35 cm²", "14 cm²", "12 cm²"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 18",
            "quiz": {
              "question": "Persegi panjang dengan panjang 20 cm dan lebar 6 cm. Berapa kelilingnya?",
              "options": ["52 cm", "26 cm", "60 cm"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 19",
            "quiz": {
              "question": "Sebuah layang-layang memiliki diagonal 14 cm dan 6 cm. Berapa luasnya?",
              "options": ["42 cm²", "84 cm²", "56 cm²"],
              "correctAnswerIndex": 0
            }
          },
          {
            "name": "Soal 20",
            "quiz": {
              "question": "Persegi dengan luas 64 cm². Berapa panjang sisinya?",
              "options": ["8 cm", "6 cm", "10 cm"],
              "correctAnswerIndex": 0
            }
          }

        ]

      ]
    },
  ];

  // --- FUNGSI DIALOG DIMODIFIKASI DENGAN CHECKBOX ---
  void _showArSafetyWarning(BuildContext context, VoidCallback onConfirm) {
    _dialogDontShowAgain = false; // Reset state setiap kali dialog dibuka

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // StatefulBuilder digunakan agar checkbox bisa di-update
        // tanpa perlu me-rebuild seluruh halaman.
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1C3A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFFFE0B2),
                      child: Icon(Icons.warning_amber_rounded, color: Color(0xFFE65100), size: 28),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Peringatan Keamanan",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Untuk menggunakan AR dengan aman, harap perhatikan:",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    _buildSafetyPoint("Pastikan selalu ada pengawasan orang tua."),
                    const SizedBox(height: 12),
                    _buildSafetyPoint("Waspadai lingkungan sekitarmu agar tidak menabrak atau terjatuh."),
                    const SizedBox(height: 24),

                    // --- CHECKBOX BARU DITAMBAHKAN DI SINI ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _dialogDontShowAgain,
                          onChanged: (bool? value) {
                            setDialogState(() {
                              _dialogDontShowAgain = value ?? false;
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: const Color(0xFF6A1B9A),
                          side: const BorderSide(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              _dialogDontShowAgain = !_dialogDontShowAgain;
                            });
                          },
                          child: const Text(
                            "Jangan tampilkan lagi",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tombol "Saya Mengerti"
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        // jadikan async untuk menunggu proses simpan
                        onPressed: () async {
                          // Jika checkbox dicentang, simpan preferensi
                          if (_dialogDontShowAgain) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('showArWarning', false);
                          }
                          Navigator.of(dialogContext).pop();
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A1B9A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Saya Mengerti",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSafetyPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4.0, right: 8.0),
          child: CircleAvatar(
            radius: 4,
            backgroundColor: Colors.white30,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }

  // --- FUNGSI onSubTopicSelected DIMODIFIKASI UNTUK CEK PREFERENSI ---
  void _onSubTopicSelected(Map<String, dynamic> subTopic, String parentTitle, List<Map<String, dynamic>> topicList, int startIndex) async {

    Navigator.of(context).pop();

    // Fungsi untuk menampilkan model
    void showModel() {

      final List<String> keteranganList = subTopic['keterangan'];

      final String formattedKeterangan = keteranganList
          .asMap()
          .entries
          .map((entry) => '${entry.key + 1}. ${entry.value}')
          .join('\n');


      setState(() {
        isLoading = true;
        _currentAppState = AppState.modelView;
        _selectedModel = subTopic['model'];
        _currentQuizList = null;
        titleSidebar = '$parentTitle > ${subTopic['name']}\n'
            'Ciri - ciri :\n'
            '$formattedKeterangan';
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }

    if (subTopic.containsKey('model') && subTopic['model'] != null) {
      final prefs = await SharedPreferences.getInstance();
      // Baca preferensi, jika belum ada, default-nya adalah true (tampilkan dialog)
      final bool shouldShowWarning = prefs.getBool('showArWarning') ?? true;

      if (shouldShowWarning) {
        _showArSafetyWarning(context, showModel);
      } else {
        // Jika tidak perlu tampilkan warning, langsung panggil fungsi showModel
        showModel();
      }

    } else if (subTopic.containsKey('quiz')) {
      final List<Map<String, dynamic>> allQuizzes =
      topicList.where((item) => item.containsKey('quiz')).toList();

      // 2. Cari indeks kuis yang dipilih di dalam daftar yang sudah disaring.
      final int newQuizIndex = allQuizzes.indexWhere((quizItem) => quizItem == subTopic);

      setState(() {
        isLoading = true;
        _currentAppState = AppState.quizView;
        _currentQuizList = allQuizzes;      // Gunakan daftar kuis yang sudah bersih
        _currentQuizIndex = newQuizIndex;   // Gunakan indeks yang benar
        _selectedModel = null;
        _selectedOptionIndex = null;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    } else if (subTopic.containsKey('keliling') && subTopic.containsKey('luas')) {
      setState(() {
        isLoading = true;
        _currentAppState = AppState.rumusView;
        _selectedModel = null;
        _currentQuizList = null;
        titleSidebar = '${subTopic['name']}';
        _currentRumusData = subTopic; // Simpan data keliling dan luas
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }else {
      _resetToWelcomeScreen();
    }
  }
  Map<String, dynamic>? _currentRumusData;

  void _resetToWelcomeScreen() {
    setState(() {
      _currentAppState = AppState.welcome;
      _selectedModel = null;
      _currentQuizList = null;
      _currentQuizIndex = 0;
      titleSidebar = 'Silahkan pilih materi';
    });
  }

  void _goToNextQuestion() {
    if (_currentQuizList != null && _currentQuizIndex < _currentQuizList!.length - 1) {
      setState(() {
        _currentQuizIndex++;
        _selectedOptionIndex = null;
      });
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuizIndex > 0) {
      setState(() {
        _currentQuizIndex--;
        _selectedOptionIndex = null;
      });
    }
  }

  // Sisa kode di bawah ini tidak ada perubahan.
  // Cukup salin semuanya.

  Widget _buildQuizView() {
    if (_currentQuizList == null || _currentQuizList!.isEmpty) {
      return const Center(child: Text("Soal tidak ditemukan."));
    }

    final currentQuizItem = _currentQuizList![_currentQuizIndex];
    final quiz = currentQuizItem['quiz'] as Map<String, dynamic>;
    final options = quiz['options'] as List<String>;
    final quizTitle = "Latihan soal > ${currentQuizItem['name']}";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            quizTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black54),
          ),
          const SizedBox(height: 24),
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
          ElevatedButton(
            onPressed: _selectedOptionIndex == null
                ? null
                : () {
              final bool isCorrect = _selectedOptionIndex == quiz['correctAnswerIndex'];
              if (isCorrect) {
                // Tampilan dialog SUKSES
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: 'Success',
                  text: 'Jawaban kamu benar, keren!',
                  confirmBtnText: 'Okay',
                  onConfirmBtnTap: () {
                    Navigator.of(context).pop();
                    // Jika ingin otomatis ke soal berikutnya, hapus komentar di bawah
                    if (_currentQuizIndex < _currentQuizList!.length - 1) {
                      _goToNextQuestion();
                    }
                  },
                );
              } else {
                // Tampilan dialog GAGAL
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: 'Oops...',
                  text: 'Jawaban kamu salah, coba lagi ya!',
                  confirmBtnText: 'Coba Lagi',
                  onConfirmBtnTap: () {
                    Navigator.of(context).pop();
                  }
                );
              }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.blue.shade100),
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue.shade800),
                onPressed: _currentQuizIndex > 0 ? _goToPreviousQuestion : null,
              ),
              Text(
                "Soal ${_currentQuizIndex + 1} dari ${_currentQuizList!.length}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.blue.shade100),
                icon: Icon(Icons.arrow_forward_ios, color: Colors.blue.shade800),
                onPressed: _currentQuizIndex < _currentQuizList!.length - 1 ? _goToNextQuestion : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

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
                      // Menggunakan icon dari data, jika tidak ada, gunakan nomor
                      child: item['icon'] != null
                          ? Icon(item['icon'], size: 20)
                          : Text('${index + 1}'),
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
                    // ---- AWAL PERUBAHAN ----
                    ...subTopics.asMap().entries.map((entry) {
                      int subIndex = entry.key;
                      Map<String, dynamic> subTopic = entry.value;

                      // Jika item adalah header, tampilkan teks biasa
                      if (subTopic['isHeader'] == true) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 8.0),
                          child: Text(
                            subTopic['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }

                      // Jika bukan header, tampilkan ListTile seperti biasa
                      return ListTile(
                        contentPadding: const EdgeInsets.only(left: 30.0, right: 16.0),
                        leading: Icon(
                          subTopic.containsKey('model') ? Icons.view_in_ar_outlined
                              : subTopic.containsKey('quiz') ? Icons.quiz_outlined
                              : Icons.image_outlined,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        title: Text(subTopic['name']),
                        onTap: () => _onSubTopicSelected(subTopic, item['title'], subTopics, subIndex),
                        dense: true,
                      );
                    }).toList(),
                    // ---- AKHIR PERUBAHAN ----
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
      canPop: _currentAppState == AppState.welcome,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        _resetToWelcomeScreen();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: _currentAppState != AppState.welcome
              ? IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _resetToWelcomeScreen,
          )
              : null,
          title: Text(
              _currentAppState == AppState.rumusView ? titleSidebar : 'Fun AR Math',
              style: const TextStyle(color: Colors.white)
          ),
          backgroundColor: Colors.blue.shade700,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          backgroundColor: Colors.grey,
          child: Column(
            children: [
              AppBar(
                title: const Text("Daftar Pertemuan", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.blue.shade700,
                automaticallyImplyLeading: false,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8.0),
                  itemCount: menuitems.length,
                  itemBuilder: (context, index) {
                    final item = menuitems[index];
                    return _buildMenuItem(item, index);
                  },
                ),
              ),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : switch (_currentAppState) {
          AppState.welcome => _buildWelcomeScreen(),
          AppState.modelView => _buildModelViewer(),
          AppState.quizView => _buildQuizView(),
          AppState.rumusView => _buildRumusSegitiga(_currentRumusData!, context), // Panggil widget rumus
        },
      ),
    );
  }

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
                src: _selectedModel!,
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
  Widget _buildRumusSegitiga(Map<String, dynamic> subTopic, BuildContext context) {
    final kelilingImage = subTopic['keliling'] as String?;
    final luasImage = subTopic['luas'] as String?;

    final double screenHeight = MediaQuery.of(context).size.height;
    List<Widget> imageSliders = [];

    if (kelilingImage != null && kelilingImage.isNotEmpty) {
      imageSliders.add(
        SizedBox(
          height: screenHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // --- AWAL PERUBAHAN ---
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(kelilingImage, fit: BoxFit.contain),
              ),
              // --- AKHIR PERUBAHAN ---
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),

                ),
              ),
            ],
          ),
        ),
      );
    }

    if (luasImage != null && luasImage.isNotEmpty) {
      imageSliders.add(
        SizedBox(
          height: screenHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // --- AWAL PERUBAHAN ---
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(luasImage, fit: BoxFit.contain),
              ),
              // --- AKHIR PERUBAHAN ---
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return imageSliders.isNotEmpty
        ? CarouselSlider(
      options: CarouselOptions(
        height: screenHeight,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        autoPlay: false,
      ),
      items: imageSliders,
    )
        : const Center(child: Text("Materi keliling dan luas tidak ditemukan."));
  }
}