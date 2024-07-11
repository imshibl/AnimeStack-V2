class ChatState {
  final List<ChatModel> messages;
  final bool isLoading;

  ChatState({required this.messages, required this.isLoading});
}

class ChatModel {
  String message;
  bool isAi;

  ChatModel({required this.message, required this.isAi});
}
