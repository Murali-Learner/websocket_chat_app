import 'package:chat_app/models/chat_message.dart';
import 'package:chat_app/notifiers/message_notifier.dart';
import 'package:chat_app/services/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifiers/auth_notifier.dart';

final imageProvider = StateProvider<String>((ref) => '');

final uploadStatusProvider = StateProvider<bool>((ref) => false);

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthStatus>((ref) => AuthNotifier());
final messageProvider =
    StateNotifierProvider<MessageNotifier, List<ChatMessage>>(
        (ref) => MessageNotifier());
