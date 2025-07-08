import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String role;
  final String content;
  final bool isTyping;

  const MessageBubble({
    super.key,
    required this.role,
    required this.content,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = role == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser
              ? const Color.fromARGB(255, 255, 255, 255) // user = white bubble
              : const Color.fromARGB(
                  40,
                  255,
                  255,
                  255,
                ), // bot = semi-transparent white (dark bg)
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          content,
          style: TextStyle(
            fontSize: isTyping ? 28 : 16,
            fontWeight: isTyping ? FontWeight.w300 : FontWeight.normal,
            color: isUser
                ? const Color.fromARGB(255, 0, 0, 0) // user = black text
                : Colors.white, // bot = white text
          ),
        ),
      ),
    );
  }
}
