import 'package:chat_app/services/hive_service.dart';
import 'package:chat_app/views/home_page.dart';
import 'package:chat_app/views/login_view.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    if (HiveService.userName != null) {
      return const HomePage();
    } else {
      return LoginPage();
    }
  }
}
