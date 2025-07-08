import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/chat_screen.dart';
import 'themes/dark_theme.dart';
import 'utils/last_state_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final lastState = await LastStateManager.loadState();

  runApp(BotBroWrapper(lastState: lastState));
}

class BotBroWrapper extends StatefulWidget {
  final Map<String, dynamic> lastState;
  const BotBroWrapper({super.key, required this.lastState});

  @override
  State<BotBroWrapper> createState() => _BotBroWrapperState();
}

class _BotBroWrapperState extends State<BotBroWrapper> {
  bool _isSplashShown = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BotBro',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: _isSplashShown
          ? _getScreenFromState(widget.lastState["last_screen"])
          : _buildSplashFirstTime(),
    );
  }

  Widget _buildSplashFirstTime() {
    _isSplashShown = true;
    return SplashScreen(
      onFinish: () {
        setState(() {}); // trigger rebuild to go to actual screen
      },
    );
  }

  Widget _getScreenFromState(String? screen) {
    switch (screen) {
      case 'chat_screen':
        return const ChatScreen();
      default:
        return const ChatScreen(); // fallback
    }
  }
}
