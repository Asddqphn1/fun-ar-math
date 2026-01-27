import 'package:flutter/material.dart';

class StaticData {
  // Data lengkap dipindahkan dari apparview.dart
  static final List<Map<String, dynamic>> rawData = [
    {
      'title': 'Pertemuan 1: Jenis-jenis Segitiga',
      'subtitle': 'Mengenali dan membedakan jenis-jenis segitiga. ',
      'icon': Icons.looks_one,
      'subbab': [
        {'name': 'Materi AR', 'isHeader': true},
        {'name': 'Segitiga sama sisi', 'model': 'assets/models/segitiga_sama_sisi.glb', 'keterangan' : ['Tiga sisi sama panjang dan tiga sudut sama besar (masing-masing 60°).']},
        {'name': 'Segitiga sama kaki', 'model': 'assets/models/segitiga_sama_kaki.glb', 'keterangan' : ['Dua sisi sama panjang, dua sudut sama besar.']},
        {'name': 'Segitiga sembarang', 'model': 'assets/models/segitiga_sembarang.glb', 'keterangan' : [' Semua sisi berbeda panjang dan semua sudut berbeda besar.']},
        {'name': 'Segitiga siku-siku', 'model': 'assets/models/segitiga_siku.glb', 'keterangan' : ['Salah satu sudutnya tepat 90° (siku-siku). ']},
        {'name': 'Segitiga Lancip', 'model': 'assets/models/segitiga_lancip.glb', 'keterangan' : [' Segitiga yang semua sudutnya kurang dari 90° ']},
        {'name': 'Segitiga tumpul', 'model': 'assets/models/segitiga_tumpul.glb', 'keterangan' : [' Segitiga yang salah satu sudutnya lebih dari 90°.']},
        {'name': 'Latihan Soal', 'isHeader': true},
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
      ],
    },
    {
      'title': 'Pertemuan 2: Keliling dan Luas Segitiga',
      'subtitle': 'Menghitung keliling dan luas segitiga dari contoh nyata',
      'icon': Icons.looks_two,
      'subbab': [
        {'name': 'Materi Keliling dan Luas Segitiga', 'isHeader': true},
        {'name': 'Keliling dan Luas Segitiga', 'keliling' : 'assets/luas-keliling/keliling-segitiga.jpg', 'luas' : 'assets/luas-keliling/luas-segitiga.jpg'},
        {'name': 'Latihan Soal', 'isHeader': true},
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
    },
    {
      'title': 'Pertemuan 3: Jenis-jenis Segiempat',
      'subtitle': 'Mengidentifikasi dan menyebutkan jenis-jenis segiempat',
      'icon': Icons.looks_3,
      'subbab': [
        {'name': 'Materi AR', 'isHeader': true},
        {'name': 'Persegi', 'model': 'assets/models/persegi.glb', 'keterangan' : ['4 sisi sama panjang', '4 sudut siku-siku','Diagonal sama panjang dan tegak lurus']},
        {'name': 'Persegi Panjang', 'model': 'assets/models/persegiPanjang.glb', 'keterangan' : ['Sisi berhadapan sama panjang dan sejajar', '4 sudut siku-siku','Diagonal sama panjang']},
        {'name': 'Jajar Genjang', 'model': 'assets/models/jajar_genjang.glb', 'keterangan' : [ 'Sisi berhadapan sama panjang dan sejajar','Sudut berhadapan sama besar', 'Diagonal membagi dua' ] },
        {'name': 'Belah Ketupat', 'model': 'assets/models/belah_ketupat.glb', 'keterangan' : [ '4 sisi sama panjang', 'Diagonal saling tegak lurus' ,'Sudut berhadapan sama besar']},
        {'name': 'Layang-layang', 'model': 'assets/models/layang.glb', 'keterangan' : ['2 pasang sisi sama panjang','Diagonal saling tegak lurus, hanya satu membagi diagonal lainnya']},
        {'name': 'Trapesium', 'model': 'assets/models/trapesium.glb', 'keterangan' : ['Hanya 1 pasang sisi sejajar', 'Bentuk bisa sembarang, sama kaki, atau siku-siku']},
        {'name': 'Latihan Soal', 'isHeader': true},
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
    },
    {
      'title': 'Pertemuan 4: Keliling dan Luas SegiEmpat',
      'subtitle': 'Menghitung keliling dan luas SegiEmpat dari contoh nyata',
      'icon': Icons.looks_4,
      'subbab': [
        {'name': 'Materi Keliling dan Luas SegiEmpat', 'isHeader': true},
        {'name': 'Keliling dan Luas Persegi', 'keliling' : 'assets/luas-keliling/keliling-persegi.jpg', 'luas' : 'assets/luas-keliling/luas-persegi.jpg'},
        {'name': 'Keliling dan Luas Persegi Panjang', 'keliling' : 'assets/luas-keliling/keliling-persegiPanjang.jpg', 'luas' : 'assets/luas-keliling/luas-persegiPanjang.jpg'},
        {'name': 'Keliling dan Luas Jajar genjang', 'keliling' : 'assets/luas-keliling/keliling-jajargenjang.jpg', 'luas' : 'assets/luas-keliling/luas-jajarGenjang.jpg'},
        {'name': 'Keliling dan Luas Belah ketupat', 'keliling' : 'assets/luas-keliling/keliling-belah-ketupat.jpg', 'luas' : 'assets/luas-keliling/luas-belahKetupat.jpg'},
        {'name': 'Keliling dan Luas Layang-layang', 'keliling' : 'assets/luas-keliling/keliling-layang-layang.jpg', 'luas' : 'assets/luas-keliling/luas-layang-layang.jpg'},
        {'name': 'Keliling dan Luas Trapesium', 'keliling' : 'assets/luas-keliling/keliling-trapesium.jpg', 'luas' : 'assets/luas-keliling/luas-trapesium.jpg'},
        {'name': 'Latihan Soal', 'isHeader': true},
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
    }
  ];

  // Fungsi Helper Tetap Ada
  static Map<String, dynamic>? findModelByName(String name) {
    for (var chapter in rawData) {
      for (var sub in chapter['subbab']) {
        if (sub['name'] == name && sub.containsKey('model')) return sub;
      }
    }
    return null;
  }

  static Map<String, dynamic>? findMateriByName(String name) {
    for (var chapter in rawData) {
      for (var sub in chapter['subbab']) {
        if ((sub['name'] as String).contains(name)) {
          if (sub.containsKey('keliling') || sub.containsKey('luas')) return sub;
        }
      }
    }
    return null;
  }

  static List<Map<String, dynamic>>? findQuizListByChapter(String chapterTitle) {
    for (var chapter in rawData) {
      if (chapter['title'] == chapterTitle) {
        return (chapter['subbab'] as List)
            .where((item) => item.containsKey('quiz'))
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
    }
    return null;
  }
}