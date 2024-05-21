import 'package:chat_app/models/chat_message.dart';
import 'package:chat_app/views/utils/extensions/spacer_extension.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage chatMessage;

  const ChatBubble({
    super.key,
    required this.chatMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          chatMessage.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: chatMessage.isMine ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: chatMessage.isMine
                ? const Radius.circular(20)
                : const Radius.circular(0),
            topRight: chatMessage.isMine
                ? const Radius.circular(0)
                : const Radius.circular(20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chatMessage.imageUrl != null &&
                chatMessage.imageUrl!.isNotEmpty)
              Image.network(
                chatMessage.imageUrl!,
                height: 120,
                width: 100,
                cacheHeight: 20,
                cacheWidth: 20,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error_outline),
              ),
            10.vSpace,
            Text(
              chatMessage.message,
              style: TextStyle(
                color: chatMessage.isMine ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
