import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  print("BotBro started");
  runApp(const BotBroApp());
}

class BotBroApp extends StatelessWidget {
  const BotBroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BotBro 🧠💬',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
