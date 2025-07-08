import 'package:flutter/material.dart';
import '../models/chat_session.dart'; // You’ll create this
import '../utils/chat_session_manager.dart'; // Handles loading/saving chats

class Sidebar extends StatefulWidget {
  final VoidCallback onNewChat;
  final Function(ChatSession) onChatSelected;
  final String? activeChatId;

  const Sidebar({
    super.key,
    required this.onNewChat,
    required this.onChatSelected,
    required this.activeChatId,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  List<ChatSession> chatSessions = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    final sessions = await ChatSessionManager.loadAllSessions();
    setState(() => chatSessions = sessions.reversed.toList()); // newest top
  }

  void _deleteChat(String id) async {
    await ChatSessionManager.deleteSession(id);
    _loadChats(); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Title
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "🧠 BotBro",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Divider(color: Colors.grey),

            // New Chat Button
            ListTile(
              leading: const Icon(Icons.add, color: Colors.white),
              title: const Text(
                "New Chat",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onNewChat();
              },
            ),
            const Divider(color: Colors.grey),

            // Chat History
            Expanded(
              child: chatSessions.isEmpty
                  ? const Center(
                      child: Text(
                        "No chats yet.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: chatSessions.length,
                      itemBuilder: (context, index) {
                        final session = chatSessions[index];
                        final isActive = session.id == widget.activeChatId;

                        return Dismissible(
                          key: Key(session.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) => _deleteChat(session.id),
                          child: ListTile(
                            tileColor: isActive
                                ? Colors.white10
                                : Colors.transparent,
                            title: Text(
                              session.title ?? "Untitled",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              widget.onChatSelected(session);
                            },
                          ),
                        );
                      },
                    ),
            ),

            // Footer
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "v2.1 • LLaMA-3",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
