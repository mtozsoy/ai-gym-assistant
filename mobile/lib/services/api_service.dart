import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  // Base URL tek bir sabit değişkende tanımlandı
  static const String _baseUrl = 'http://10.0.2.2:8000';

  // POST /detect isteği için fotoğraf gönderen metot
  Future<Map<String, dynamic>?> detectMachine(XFile imageFile) async {
    try {
      final url = Uri.parse('$_baseUrl/detect');

      // Multipart/form-data isteği oluşturuluyor
      final request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // İsteği gönder ve yanıtı bekle
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        debugPrint('Sunucudan gelen başarılı cevap: $data');
        return data;
      } else {
        debugPrint('Sunucu hatası: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('API isteği gönderilirken hata oluştu: $e');
      return null;
    }
  }
}
