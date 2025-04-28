import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/ChatbotModule/Controller/chatbot_controller.dart'; // Fixed import
import 'package:tour_guide_application/ChatbotModule/Theme/chatbot_theme.dart'; // Ensure this is correct

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
          appBar: AppBar(
            title: Text(
              'Travel Assistant',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
                color: AppColors.lightText, // Ensure AppColors is defined in themes.dart
              ),
            ),
            backgroundColor: AppColors.primaryPurple,
          ),
          body: Column(
            children: [
              Expanded(
                child: controller.messages.isEmpty
                    ? Center(
                        child: Text(
                          'Start chatting with your travel assistant!',
                          style: GoogleFonts.outfit(
                            color: AppColors.greyText,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.all(16),
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
                                color: isUser ? AppColors.primaryPurple : AppColors.lightCard,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                message['text']!,
                                style: GoogleFonts.outfit(
                                  color: isUser ? AppColors.lightText : AppColors.darkText,
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
                          fillColor: AppColors.lightCard,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(controller),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: AppColors.primaryPurple),
                      onPressed: () => _sendMessage(controller),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}