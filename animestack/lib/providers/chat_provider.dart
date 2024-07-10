import 'dart:async';
import 'dart:convert';

import 'package:animestack/models/chat_model.dart';
import 'package:animestack/providers/common_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends StateNotifier<List<ChatModel>> {
  ChatProvider({required this.baseUrl}) : super([]);

  final String baseUrl;

  Future<List<ChatModel>> loadAiChat() async {
    try {
      final request = await http.get(Uri.parse(baseUrl));
      if (request.statusCode == 200) {
        final data = jsonDecode(request.body);

        ChatModel chat = ChatModel(message: data["message"], isAi: true);
        state = [...state, chat];
      }
    } catch (e) {
      throw Exception(e);
    }

    return state;
  }

  void sendMessage(String message) async {
    ChatModel chat = ChatModel(message: message, isAi: false);
    state = [...state, chat];
    Map<String, dynamic> requestData = {
      'message': message,
    };
    try {
      String url = "${baseUrl}chat/";
      print(url);
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
        print(data);
        ChatModel chat = ChatModel(message: data["response"], isAi: true);
        print(chat.message);
        state = [...state, chat];
      } else {
        print(request.statusCode);
        print(request.body);
      }
    } catch (e) {
      print(e);
    }
  }
}

final aiChatProvider =
    StateNotifierProvider<ChatProvider, List<ChatModel>>((ref) {
  final baseUrl = ref.read(aiChatBaseUrlProvider);
  return ChatProvider(baseUrl: baseUrl);
});
