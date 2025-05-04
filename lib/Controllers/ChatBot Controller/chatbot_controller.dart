import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatbotController extends ChangeNotifier {
  // Supabase client
  final SupabaseClient supabase = Supabase.instance.client;

  // API KEY and RESPONSE TEXT
  final String apiKey = 'AIzaSyBwEMqDZsa6oVX6PvEV_uRW2XwrytbvgL4'; // Move to secure storage

  String responseText = '';

  // LOADING VARIABLE
  bool isLoading = false;

  // SCROLL CONTROLLER
  final ScrollController scrollController = ScrollController();

  // LIST FOR MESSAGES
  List<Map<String, String>> messages = [];

  // METHOD TO SCROLL TO THE BOTTOM
  void scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // METHOD TO FETCH PREVIOUS MESSAGES FROM SUPABASE
  Future<void> fetchPreviousMessages() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        log('No user logged in');
        return;
      }

      final response = await supabase
          .from('chat_messages')
          .select('sender, message')
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      messages = response.map((msg) => {
            'sender': msg['sender'] as String,
            'text': msg['message'] as String,
          }).toList();

      notifyListeners();
      scrollToBottom();
    } catch (error) {
      log('Error fetching previous messages: $error');
    }
  }

  // METHOD TO SAVE MESSAGE TO SUPABASE
  Future<void> saveMessage(String sender, String message) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        log('No user logged in');
        return;
      }

      await supabase.from('chat_messages').insert({
        'user_id': userId,
        'sender': sender,
        'message': message,
      });
    } catch (error) {
      log('Error saving message: $error');
    }
  }

  // METHOD TO FETCH THE RESPONSE FROM GEMINI API
  Future<void> fetchResponse(String message) async {
    try {
      // Add user message to list and save to Supabase
      messages.add({'sender': 'user', 'text': message});
      isLoading = true;
      notifyListeners();
      scrollToBottom();

      // Save user message to Supabase
      await saveMessage('user', message);

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': message},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        responseText = data['candidates']?[0]['content']?['parts']?[0]['text'] ??
            'No response received';

        messages.add({'sender': 'bot', 'text': responseText});
        await saveMessage('bot', responseText);
      } else {
        responseText = 'Error: ${response.body}';
        messages.add({'sender': 'bot', 'text': responseText});
        await saveMessage('bot', responseText);
      }
    } catch (error) {
      responseText = 'Failed to connect. Please try again.';
      messages.add({'sender': 'bot', 'text': responseText});
      await saveMessage('bot', responseText);
      log('Error: $error');
    } finally {
      isLoading = false;
      notifyListeners();
      scrollToBottom();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void addMessage(String text) {}

  getResponse(String text) {}
}