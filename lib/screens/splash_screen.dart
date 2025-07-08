import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/last_state_manager.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;

  const SplashScreen({super.key, this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () async {
      await LastStateManager.saveState({
        "last_screen": "chat_screen",
        "scroll_position": 0,
        "ui_theme": "dark",
        "current_user": "adhul",
        "model": "llama3-8b",
        "app_version": "v2.1",
      });

      widget.onFinish?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BotBro',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 40, // about 1.5 cm on most phones
              height: 6,
              child: _AnimatedLineBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedLineBar extends StatefulWidget {
  @override
  State<_AnimatedLineBar> createState() => _AnimatedLineBarState();
}

class _AnimatedLineBarState extends State<_AnimatedLineBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        color: Colors.white24,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double width = 40;
            double position = (_controller.value * width);
            return Stack(
              children: [
                Positioned(
                  left: position - 10,
                  child: Container(
                    width: 20,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
