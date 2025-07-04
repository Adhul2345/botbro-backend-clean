import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl =
      'http://192.168.1.X:5000/chat'; // 🛑 Change this IP!

  static Future<String> getBotReply(String message) async {
    final url = Uri.parse('https://botbro-backend-clean.onrender.com/chat');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['reply'] ?? '🤖 No reply from bot.';
    } else {
      throw Exception('Server error');
    }
  }
}
