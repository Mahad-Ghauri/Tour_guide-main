import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Controllers/chatbot/chatbot_controller.dart';

class ChatbotInterface extends StatelessWidget {
  const ChatbotInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatbotController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chatbot'),
          backgroundColor: Colors.teal,
        ),
        body: Consumer<ChatbotController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final isUserMessage = index % 2 == 0; // Alternate messages
                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? Colors.teal.shade100
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            controller.messages[index]['text'] ?? '',
                            style: TextStyle(
                              color: isUserMessage
                                  ? Colors.blue // Changed text color for user messages
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4.0,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(),
                          onSubmitted: (text) {
                            if (text.isNotEmpty) {
                              controller.addMessage(text);
                              final response = controller.getResponse(text);
                              controller.addMessage(response);
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.blue), // Changed input text color
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.teal),
                        onPressed: () {
                          // Add logic for sending messages
                        },
                      ),
                    ],
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