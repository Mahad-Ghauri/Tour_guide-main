import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/Controllers/ChatBot%20Controller/chatbot_controller.dart'; // Fixed import
// import 'package:tour_guide_application/Theme/chatbot_theme.dart'; // Ensure this is correct

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch previous messages when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatbotController>(context, listen: false).fetchPreviousMessages();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(ChatbotController controller) {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    controller.fetchResponse(message);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatbotController>(
      builder: (context, controller, _) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF559CB2), Color(0xFF88D4E3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Custom App Bar
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: const BoxDecoration(
                      color: Color(0xFF559CB2),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Text(
                          'Travel Assistant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 48), // Placeholder for alignment
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: controller.messages.isEmpty
                                ? Center(
                                    child: Text(
                                      'Start chatting with your travel assistant!',
                                      style: GoogleFonts.outfit(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    controller: controller.scrollController,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: controller.messages.length,
                                    itemBuilder: (context, index) {
                                      final message = controller.messages[index];
                                      final isUser = message['sender'] == 'user';
                                      return Align(
                                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 4),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: isUser
                                                ? const Color(0xFF559CB2)
                                                : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            message['text']!,
                                            style: TextStyle(
                                              color: isUser ? Colors.white : Colors.black87,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          if (controller.isLoading)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _messageController,
                                    decoration: InputDecoration(
                                      hintText: 'Type your message...',
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onSubmitted: (_) => _sendMessage(controller),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _sendMessage(controller),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF559CB2),
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  child: const Icon(Icons.send, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}