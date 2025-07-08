import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../services/chat_service.dart';
import '../utils/last_state_manager.dart';
import '../utils/shared_prefs_util.dart';
import '../models/chat_session.dart';
import '../utils/chat_session_manager.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _dotController;
  Timer? _typingTimer;

  String animatedReply = "";
  bool isTyping = false;

  ChatSession? currentChatSession;

  @override
  void initState() {
    super.initState();

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _startNewChat();

    LastStateManager.saveState({
      "last_screen": "chat_screen",
      "scroll_position": 0,
      "ui_theme": "dark",
      "current_user": "adhul",
      "model": "llama3-8b",
      "app_version": "v2.2",
    });

    SharedPrefsUtil.saveString("model", "llama3-8b");
  }

  @override
  void dispose() {
    _dotController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _startNewChat() {
    setState(() {
      currentChatSession = ChatSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "New Chat",
        messages: [],
      );
      animatedReply = "";
      isTyping = false;
    });
    _scrollToBottom();
  }

  void _loadChatSession(ChatSession session) {
    setState(() {
      currentChatSession = session;
      animatedReply = "";
      isTyping = false;
    });
    _scrollToBottom();
  }

  void sendMessage(String userMsg) async {
    if (currentChatSession == null) return;

    setState(() {
      currentChatSession!.messages.add({"role": "user", "content": userMsg});
      animatedReply = "";
      isTyping = true;
    });
    _scrollToBottom();

    SharedPrefsUtil.saveString("last_user_message", userMsg);

    if ((currentChatSession?.title == null ||
            currentChatSession!.title == "New Chat") &&
        currentChatSession!.messages.length == 1) {
      final titlePrompt =
          "Give a short 3-6 word title for this message:\n$userMsg";
      final title = await ChatService.getBotReply(titlePrompt);

      setState(() {
        currentChatSession = ChatSession(
          id: currentChatSession!.id,
          title: title.trim(),
          messages: currentChatSession!.messages,
        );
      });
    }

    final botReply = await ChatService.getBotReply(userMsg);
    int charIndex = 0;

    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (charIndex >= botReply.length) {
        timer.cancel();
        if (mounted) {
          setState(() {
            isTyping = false;
            currentChatSession!.messages.add({
              "role": "bot",
              "content": botReply,
            });
            animatedReply = "";
          });
        }
        ChatSessionManager.saveSession(currentChatSession!);
        _scrollToBottom();
      } else {
        setState(() {
          animatedReply = botReply.substring(0, charIndex + 1);
        });
        charIndex++;
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String getDots() {
    int dots = ((_dotController.value * 3) + 1).floor();
    return '.' * dots;
  }

  @override
  Widget build(BuildContext context) {
    final fullList = List<Map<String, dynamic>>.from(
      currentChatSession?.messages ?? [],
    );
    if (isTyping || animatedReply.isNotEmpty) {
      fullList.add({
        "role": "bot",
        "content": animatedReply.isNotEmpty ? animatedReply : getDots(),
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(
        onNewChat: _startNewChat,
        onChatSelected: _loadChatSession,
        activeChatId: currentChatSession?.id,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "BotBro",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: fullList.length,
              itemBuilder: (context, index) {
                final message = fullList[index];
                return MessageBubble(
                  role: message['role'],
                  content: message['content'],
                  isTyping:
                      (index == fullList.length - 1 &&
                      isTyping &&
                      animatedReply.isEmpty),
                );
              },
            ),
          ),
          ChatInputField(onSend: sendMessage),
        ],
      ),
    );
  }
}
