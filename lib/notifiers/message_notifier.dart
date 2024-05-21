import 'dart:convert';

import 'package:chat_app/models/chat_message.dart';
import 'package:chat_app/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageNotifier extends StateNotifier<List<ChatMessage>> {
  WebSocketChannel? _socket;

  MessageNotifier() : super([]) {
    _connect();
  }

  void _connect() async {
    const String url = 'wss://echo.websocket.org';
    const String url1 = 'ws://192.168.24.159:8080';
    try {
      _socket = WebSocketChannel.connect(
        Uri.parse(url1),
      );

      // Load chat messages from local storage
      final List<ChatMessage> chatMessages =
          await HiveService.getChatMessages();
      state = chatMessages;

      _socket!.stream.listen((message) {
        final Map<String, dynamic> messageJson = jsonDecode(message);

        final chatMessage = ChatMessage(
            isMine: false,
            message: messageJson['message'],
            imageUrl: messageJson['imageUrl']);

        // final chatMessage = ChatMessage.fromJson(messageJson);

        // Save message to local storage and update state
        HiveService.saveChatMessage(chatMessage);
        state = [...state, chatMessage];
      });
    } catch (e) {
      debugPrint("get messages Error $e");
    }
  }

  // void _connect() async {
  //   _socket = WebSocketChannel.connect(
  //     Uri.parse(
  //         'wss://echo.websocket.org'),
  //   );

  //   final List<ChatMessage> chatMessages = await HiveService.getChatMessages();
  //   state = chatMessages;

  //   _socket!.stream.listen((message) {
  //     final Map<String, dynamic> messageJson = jsonDecode(message);
  //     final chatMessage = ChatMessage.fromJson(messageJson);
  //     HiveService.saveChatMessage(chatMessage);
  //     state = [...state, chatMessage];
  //   });
  // }

  void send(ChatMessage chatMessage) {
    // Convert the ChatMessage object to a JSON string
    final jsonData = jsonEncode(chatMessage.toJson());

    // Send the JSON string over WebSocket
    _socket!.sink.add(jsonData);

    // Save the message to local storage
    HiveService.saveChatMessage(chatMessage);
    state = [...state, chatMessage];
  }
  // void send(String message, String? image) {
  //   _socket!.sink.add(message);
  //   final chatMessage =
  //       ChatMessage(isMine: true, message: message, imageUrl: image);
  //   HiveService.saveChatMessage(chatMessage);
  //   state = [...state, chatMessage];
  // }

  void disconnect() {
    _socket!.sink.close();
  }
}
