import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/enums.dart';
import 'package:chat_app/services/hive_service.dart';
import 'package:chat_app/services/http_service.dart';
import 'package:chat_app/views/utils/toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AuthNotifier extends StateNotifier<AuthStatus> {
  AuthNotifier() : super(AuthStatus.initial);

  Future<void> login(
      {required String username, required String password}) async {
    try {
      state = AuthStatus.loading;
      http.Response loginResponse = await HttpService.login(
        username,
        password,
      );

      Map body = jsonDecode(loginResponse.body);

      if (loginResponse.statusCode == 200) {
        await HiveService.saveUsername(User(username));

        state = AuthStatus.success;
        return;
      } else {
        showErrorToast(
          message: body["message"],
        );
        state = AuthStatus.error;
        return;
      }
    } catch (e) {
      state = AuthStatus.error;
    }
  }

  Future<void> register(
      {required String username, required String password}) async {
    try {
      state = AuthStatus.loading;
      http.Response registerResponse = await HttpService.register(
        username,
        password,
      );

      Map body = jsonDecode(registerResponse.body);
      log("register body $body");
      if (registerResponse.statusCode == 200) {
        await HiveService.saveUsername(User(username));

        state = AuthStatus.success;
        return;
      } else {
        state = AuthStatus.error;
        showErrorToast(
          message: body["message"],
        );
        return;
      }
    } catch (e) {
      state = AuthStatus.error;
    }
  }
}
