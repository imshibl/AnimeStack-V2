class ChatModel {
  String message;
  bool isAi;

  ChatModel({required this.message, required this.isAi});

  // factory ChatModel.fromJson(Map<String, dynamic> json) {
  //   return ChatModel(
  //     message: json['message'],
  //     sender: json['sender'],
  //   );
  // }
}
