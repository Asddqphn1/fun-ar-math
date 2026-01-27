import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // kategori bisa 'bangun_ruang' atau 'bangun_datar'
  static Stream<QuerySnapshot> getQuestions(String category, String collectionId) {
    return FirebaseFirestore.instance
        .collection('materi_belajar')
        .doc(category) // <-- Dinamis: bisa bangun_ruang atau bangun_datar
        .collection(collectionId) // ID: balok, layang-layang, dll
        .snapshots();
  }
}