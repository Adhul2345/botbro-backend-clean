import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class LastStateManager {
  static const String _fileName = 'last_state.json';

  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  static Future<void> saveState(Map<String, dynamic> state) async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      await file.writeAsString(jsonEncode(state));
      print('✅ State saved to $path');
    } catch (e) {
      print('❌ Failed to save state: $e');
    }
  }

  static Future<Map<String, dynamic>> loadState() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      if (await file.exists()) {
        final contents = await file.readAsString();
        print('✅ State loaded from $path');
        return jsonDecode(contents);
      } else {
        print('⚠️ State file not found. Returning defaults.');
        return _defaultState();
      }
    } catch (e) {
      print('❌ Failed to load state: $e');
      return _defaultState();
    }
  }

  static Map<String, dynamic> _defaultState() {
    return {
      "last_screen": "chat_screen",
      "scroll_position": 0,
      "ui_theme": "dark",
      "current_user": "guest",
      "model": "llama3-8b",
      "app_version": "1.0",
    };
  }
}
