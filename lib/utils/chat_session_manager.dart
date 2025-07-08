import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/chat_session.dart';

class ChatSessionManager {
  static Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/chat_sessions.json';
  }

  static Future<List<ChatSession>> loadAllSessions() async {
    final path = await _getFilePath();
    final file = File(path);

    if (!file.existsSync()) return [];

    final raw = await file.readAsString();
    final data = json.decode(raw) as List;
    return data.map((e) => ChatSession.fromJson(e)).toList();
  }

  static Future<void> saveAllSessions(List<ChatSession> sessions) async {
    final path = await _getFilePath();
    final file = File(path);
    final jsonData = json.encode(sessions.map((s) => s.toJson()).toList());
    await file.writeAsString(jsonData);
  }

  static Future<void> deleteSession(String id) async {
    final sessions = await loadAllSessions();
    final updated = sessions.where((s) => s.id != id).toList();
    await saveAllSessions(updated);
  }

  static Future<void> saveSession(ChatSession session) async {
    final sessions = await loadAllSessions();
    final updated = sessions.where((s) => s.id != session.id).toList();
    updated.add(session);
    await saveAllSessions(updated);
  }
}
