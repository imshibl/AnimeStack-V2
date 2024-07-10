// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:animestack/models/chat_model.dart';
import 'package:animestack/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final TextEditingController chatTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    chatTextController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stack Bot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(builder: (context, ref, _) {
              final aiChat = ref.watch(aiChatProvider);
              return aiChat.isEmpty
                  ? Container(
                      child: Text("Stack is getting ready, Please wait..."),
                    )
                  : ListView.builder(
                      reverse: true,
                      itemCount: aiChat.length,
                      itemBuilder: (context, index) {
                        final message = aiChat.reversed.toList()[index];
                        return ChatMessageWidget(chat: message);
                      },
                    );
            }),
          ),
          ChatInputField(
            controller: chatTextController,
            sendMessage: () {
              ref
                  .read(aiChatProvider.notifier)
                  .sendMessage(chatTextController.text);
              chatTextController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final ChatModel chat;

  const ChatMessageWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    String decodedText = utf8.decode(chat.message.runes.toList());

    return Align(
      alignment: !chat.isAi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: !chat.isAi
            ? EdgeInsets.only(right: 10, left: 20, top: 5, bottom: 5)
            : EdgeInsets.only(right: 20, left: 10, top: 5, bottom: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: !chat.isAi ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          decodedText,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField(
      {super.key, required this.controller, required this.sendMessage});

  final TextEditingController controller;
  final Function() sendMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
