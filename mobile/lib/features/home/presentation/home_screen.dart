import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../../services/api_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        debugPrint('Çekilen fotoğrafın yolu: ${image.path}');

        // API servisini çağır ve dönen JSON'daki 'machine' alanını yazdır
        final apiService = ApiService();
        final response = await apiService.detectMachine();
        if (response != null && response.containsKey('machine')) {
          debugPrint('Tespit edilen makine: ${response['machine']}');
        }
      } else {
        debugPrint('Fotoğraf çekme işlemi iptal edildi.');
      }
    } catch (e) {
      debugPrint('Kamera açılırken bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Gym Assistant')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AI Gym Assistant\'a Hoş Geldiniz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: _openCamera,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Makine Tara'),
            ),
          ],
        ),
      ),
    );
  }
}
