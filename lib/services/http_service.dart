import 'dart:convert';
import 'package:chat_app/services/hive_service.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static const String baseUrl = 'https://express-auth-3hav.onrender.com';

  static Future<http.Response> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );
      return response;
    } catch (e) {
      // print('Error: $e');
      return http.Response('{ "message": "Login Failed" }', 500);
    }
  }

  static Future<http.Response> register(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      return response;
    } catch (e) {
      // print('Error: $e');
      return http.Response('{ "message": "Registration Failed" }', 500);
    }
  }

  static Future<bool> logout() async {
    try {
      // Remove username from Hive
      await HiveService.clearDB();
      return true;
    } catch (e) {
      // print('Error: $e');
      return false;
    }
  }
}
