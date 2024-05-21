import 'package:chat_app/services/enums.dart';
import 'package:chat_app/proivders.dart';
import 'package:chat_app/views/home_page.dart';
import 'package:chat_app/views/utils/extensions/context_extensions.dart';
import 'package:chat_app/views/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Register'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final authNotifier = ref.read(authProvider.notifier);

          final authState = ref.watch(authProvider);
          ref.listen<AuthStatus>(authProvider, (previousState, authState) {
            if (authState == AuthStatus.success) {
              context.push(navigateTo: const HomePage());
            }
          });
          return Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: (authState == AuthStatus.loading)
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              String userName = _usernameController.text.trim();
                              String password = _passwordController.text.trim();
                              if (userName.isEmpty || password.isEmpty) {
                                showErrorToast(
                                  message: "Please fill all fields",
                                );
                                return;
                              }

                              authNotifier.register(
                                username: _usernameController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            },
                            child: const Text('Register'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child:
                                const Text('Already have an account? Log in'),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
