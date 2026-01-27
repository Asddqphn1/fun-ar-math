import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline, color: Colors.white, size: 28),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.amber.shade700),
                  const SizedBox(width: 10),
                  const Text('Tips Penggunaan AR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTipItem('Arahkan kamera ke permukaan datar untuk hasil terbaik.', Colors.green),
                  const SizedBox(height: 8),
                  _buildTipItem('Gunakan di ruangan dengan pencahayaan yang cukup.', Colors.blue),
                  const SizedBox(height: 8),
                  _buildTipItem('Gerakkan perangkat perlahan untuk pemindaian optimal.', Colors.orange),
                  const SizedBox(height: 8),
                  _buildTipItem('Pastikan selalu ada pengawasan orang tua saat anak menggunakan AR.', Colors.red),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Mengerti', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTipItem(String text, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}