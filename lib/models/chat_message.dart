import 'package:hive/hive.dart';

part 'chat_message.g.dart'; // Generated file by Hive

@HiveType(typeId: 1)
class ChatMessage extends HiveObject {
  @HiveField(0)
  String message;

  @HiveField(1)
  bool isMine;

  @HiveField(2)
  String? imageUrl;

  ChatMessage({this.message = "", this.isMine = true, this.imageUrl});
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] ?? '',
      isMine: json['isMine'] ?? false,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'isMine': isMine,
      'imageUrl': imageUrl,
    };
  }
}
