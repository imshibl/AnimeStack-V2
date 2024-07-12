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
        title: Text('Stack - Otaku friend'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(builder: (context, ref, _) {
              final aiChat = ref.watch(aiChatProvider);
              return Stack(
                children: [
                  ListView.builder(
                    reverse: true,
                    itemCount: aiChat.messages.length,
                    itemBuilder: (context, index) {
                      final message = aiChat.messages.reversed.toList()[index];
                      return ChatMessageWidget(
                        chat: message,
                      );
                    },
                  ),
                  if (aiChat.messages.isEmpty)
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: 250,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          "Stack is getting ready, Please wait...",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                  if (aiChat.isLoading && aiChat.messages.isNotEmpty)
                    Positioned(
                      left: 16,
                      bottom: 10,
                      child: TypingIndicator(),
                    ),
                ],
              );
            }),
          ),
          ChatInputField(
            controller: chatTextController,
            sendMessage: () {
              if (chatTextController.text.isEmpty) return;
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
    return Align(
      alignment: !chat.isAi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: !chat.isAi
              ? EdgeInsets.only(right: 10, left: 60, top: 5, bottom: 5)
              : EdgeInsets.only(right: 60, left: 10, top: 5, bottom: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: !chat.isAi ? Colors.blueAccent : Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: buildRichText(context, chat.message)),
    );
  }

  Widget buildRichText(BuildContext context, String message) {
    String decodedText = utf8.decode(message.runes.toList()).trimRight();
    List<TextSpan> spans = [];
    RegExp exp = RegExp(r'\*\*(.*?)\*\*');
    Iterable<Match> matches = exp.allMatches(decodedText);

    if (matches.isEmpty) {
      // If there are no matches, return a simple Text widget
      return Text(
        decodedText,
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }

    int lastMatchEnd = 0;

    for (Match match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
            TextSpan(text: decodedText.substring(lastMatchEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < decodedText.length) {
      spans.add(TextSpan(text: decodedText.substring(lastMatchEnd)));
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: spans,
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
              maxLines: null,
              keyboardType: TextInputType.multiline,
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

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Padding(
                padding: EdgeInsets.only(right: 4),
                child: Opacity(
                  opacity: (index + 1) / 3 <= _controller.value ? 1.0 : 0.2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
