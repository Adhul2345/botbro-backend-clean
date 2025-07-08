import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // for kReleaseMode

class ChatService {
  static const String renderUrl = 'https://botbro-backend-clean.onrender.com/';
  static const String localUrl =
      'http://192.168.1.X:5000/chat'; // <-- replace X with your PC IP if needed

  // Smart switching
  static final String baseUrl = kReleaseMode ? renderUrl : localUrl;

  static Future<String> getBotReply(String message) async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? '🤖 No reply from bot.';
      } else {
        print('❌ Server Error: ${response.statusCode}');
        return '🚧 Bot is offline or busy. Try again later.';
      }
    } catch (e) {
      print('❌ Network error: $e');
      return '⚠️ Connection failed. Check your network.';
    }
  }
}
