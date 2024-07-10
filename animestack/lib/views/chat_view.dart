// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final gemini = Gemini.instance;
  final TextEditingController chatTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    chatTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ChatMessage> messages = [];

    Future<String?> getInitalMessaeFromGemini() async {
      String? message = "";
      await gemini
          .text(
              "you are an AI bot named Stack, an expert in Japanese anime shows and movies. Your major capabilities are suggesting anime based on the user's needs and requirements, and conversing about user-specified anime shows and movies. You are not able to answer anything that is not related to anime. also, you are created and designed by Bilcodes, who is also the developer of Animestack an app that has 40k+ anime details with an offline watch list.")
          .then((value) {
        message = value!.output.toString();
      }).catchError((e) {
        message = e.toString();
      });

      return message;
    }

    void sendMessage({required String userMessage}) async {
      chatTextController.clear();
      setState(() {
        messages.add(ChatMessage(text: userMessage, isUser: true));
      });

      String? response;

      await gemini.text(userMessage).then((value) {
        response = value!.output.toString();
      }).catchError((e) {
        response = e.toString();
      });

      setState(() {
        messages.add(ChatMessage(text: response!, isUser: false));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Stack Bot'),
      ),
      body: FutureBuilder(
          future: getInitalMessaeFromGemini(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            messages.add(
              ChatMessage(text: snapshot.data!, isUser: false),
            );
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages.reversed.toList()[index];
                      return ChatMessageWidget(message: message);
                    },
                  ),
                ),
                ChatInputField(
                  controller: chatTextController,
                  sendMessage: () {
                    sendMessage(userMessage: chatTextController.text);
                  },
                ),
              ],
            );
          }),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: message.isUser ? Colors.white : Colors.black),
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
