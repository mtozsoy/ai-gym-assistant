import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? detectedMachine;
  double? confidence;

  Future<void> _openCamera() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        debugPrint('Çekilen fotoğrafın yolu: ${image.path}');

        final apiService = ApiService();
        final response = await apiService.detectMachine(image);

        if (response != null && response.containsKey('detections')) {
          final detections = response['detections'] as List;

          if (detections.isNotEmpty) {
            final bestDetection = detections.reduce(
              (a, b) => a['confidence'] > b['confidence'] ? a : b,
            );

            setState(() {
              detectedMachine = bestDetection['name'];
              confidence = bestDetection['confidence'];
            });

            debugPrint(
              'Tespit edilen makine: $detectedMachine'
              ' | Güven: ${(confidence! * 100).toStringAsFixed(1)}%',
            );
          }
        }
      } else {
        debugPrint('Fotoğraf seçme işlemi iptal edildi.');
      }
    } catch (e) {
      debugPrint('Makine taranırken bir hata oluştu: $e');
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

            const SizedBox(height: 30),

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

            if (detectedMachine != null) ...[
              const SizedBox(height: 30),

              const Text(
                'Tespit Sonucu',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(detectedMachine!, style: const TextStyle(fontSize: 20)),

              Text(
                'Güven: ${(confidence! * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
