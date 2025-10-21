import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config.dart';
import '../models/message.dart';

class ApiClient {
  final String currentUserId;

  ApiClient(this.currentUserId);

  Future<bool> sendMessage({
    required String recipientId,
    required String text,
  }) async {
    final resp = await http.post(
      Uri.parse(AppConfig.messagesPost),
      headers: {
        'Content-Type': 'application/json',
        // Si después agregas auth, añade:
        // 'Authorization': 'Bearer TU_TOKEN',
      },
      body: jsonEncode({
        'senderId': currentUserId,
        'recipientId': recipientId,
        'text': text,
      }),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return true;
    } else {
      // Puedes imprimir resp.body para debug (evita logs de datos sensibles)
      return false;
    }
  }

  Future<List<ChatMessage>> fetchMessages({int limit = 50}) async {
    final url = AppConfig.messagesGet; // limit ya por defecto en backend
    final resp = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        // 'Authorization': 'Bearer TU_TOKEN',
      },
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        return data.map((e) => ChatMessage.fromJson(e)).toList();
      }
    }
    return [];
  }
}