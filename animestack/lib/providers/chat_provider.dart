import 'dart:async';
import 'dart:convert';

import 'package:animestack/models/chat_model.dart';
import 'package:animestack/providers/helper_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends StateNotifier<ChatState> {
  ChatProvider({required this.baseUrl})
      : super(ChatState(messages: [], isLoading: false));

  final String baseUrl;

  Future<void> loadAiChat() async {
    state = ChatState(messages: state.messages, isLoading: true);

    final request = await http.get(Uri.parse(baseUrl));
    if (request.statusCode == 200) {
      final data = jsonDecode(request.body);

      ChatModel chat = ChatModel(message: data["response"], isAi: true);
      state = ChatState(messages: [...state.messages, chat], isLoading: false);
    } else {
      state = ChatState(messages: state.messages, isLoading: false);
    }
  }

  void sendMessage(String message) async {
    ChatModel userChat = ChatModel(message: message, isAi: false);
    state = ChatState(messages: [...state.messages, userChat], isLoading: true);

    Map<String, dynamic> requestData = {
      'message': message,
    };

    String url = "${baseUrl}chat/";

    try {
      final request = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );
      if (request.statusCode == 200) {
        final data = jsonDecode(request.body);

        ChatModel aiChat = ChatModel(message: data["response"], isAi: true);

        state =
            ChatState(messages: [...state.messages, aiChat], isLoading: false);
      } else {
        state = ChatState(messages: state.messages, isLoading: false);
      }
    } catch (e) {
      state = ChatState(messages: state.messages, isLoading: false);
    }
  }
}

final aiChatProvider = StateNotifierProvider<ChatProvider, ChatState>((ref) {
  final baseUrl = ref.read(aiChatBaseUrlProvider);
  return ChatProvider(baseUrl: baseUrl);
});

final chatLoadingProvider = StateProvider<bool>((ref) {
  return false;
});
