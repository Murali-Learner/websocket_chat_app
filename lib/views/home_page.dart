// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/models/chat_message.dart';
import 'package:chat_app/proivders.dart';
import 'package:chat_app/services/hive_service.dart';
import 'package:chat_app/views/login_view.dart';
import 'package:chat_app/views/utils/extensions/context_extensions.dart';
import 'package:chat_app/views/utils/extensions/spacer_extension.dart';
import 'package:chat_app/views/widgets/chat_bubble.dart';
import 'package:chat_app/views/widgets/image_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messageProvider);
    final messageNotifier = ref.read(messageProvider.notifier);
    final uploadStatus = ref.watch(uploadStatusProvider);
    final image = ref.watch(imageProvider);
    final imageNotifier = ref.read(imageProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messages.isNotEmpty) _scrollToBottom();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${HiveService.userName}!"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await HiveService.clearDB();
              messageNotifier.disconnect();
              context.push(navigateTo: LoginPage());
            },
            icon: const Icon(Icons.logout),
          ),
          10.hSpace,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text("Messages Are Empty"),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ChatBubble(
                          chatMessage: message,
                        );
                      },
                    ),
            ),
            20.vSpace,
            uploadStatus // Check upload status
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator if uploading
                : Column(
                    children: [
                      if (image.isNotEmpty)
                        Stack(
                          children: [
                            Image.network(
                              image,
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error_outline),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  imageNotifier.state = '';
                                  ref
                                      .read(uploadStatusProvider.notifier)
                                      .state = false;
                                },
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  size: 30,
                                  color: Colors.amber,
                                ),
                              ),
                            )
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              // onSubmitted: (val) {
                              //   FocusManager.instance.primaryFocus?.unfocus();
                              //   if (val.isNotEmpty) {
                              //     ChatMessage message = ChatMessage(
                              //       imageUrl: image,
                              //       isMine: true,
                              //       message: val,
                              //     );
                              //     messageNotifier.send(message);
                              //     _messageController.clear();
                              //   }
                              // },
                              decoration: const InputDecoration(
                                labelText: 'Enter a message',
                              ),
                            ),
                          ),
                          20.hSpace,
                          ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) =>
                                    const ImagePickerBottomSheet(),
                              );
                            },
                            child: const Icon(Icons.upload),
                          ),
                          8.hSpace,
                          ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              final val = _messageController.text.trim();
                              if (val.isNotEmpty || uploadStatus) {
                                ChatMessage message = ChatMessage(
                                  imageUrl: image,
                                  isMine: true,
                                  message: val,
                                );
                                messageNotifier.send(message);
                                _messageController.clear();
                                imageNotifier.state = '';
                              }
                            },
                            child: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
