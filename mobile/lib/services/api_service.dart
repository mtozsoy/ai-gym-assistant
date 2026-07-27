import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL tek bir sabit değişkende tanımlandı
  static const String _baseUrl = 'http://localhost:8000';

  // POST /detect isteği hazırlayan metot
  Future<Map<String, dynamic>?> detectMachine() async {
    try {
      final url = Uri.parse('$_baseUrl/detect');

      // Şimdilik fotoğraf gönderilmiyor, sadece istek yapısı hazırlandı
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'info': 'Fotoğraf verisi yakında eklenecek'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
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
