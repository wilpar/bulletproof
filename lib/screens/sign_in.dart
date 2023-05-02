import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signIn(
    WidgetRef ref,
    BuildContext context,
    String email,
    String password,
  ) {
    if (kDebugMode) {
      print('Sign In');
    }
    ref.read(authControllerProvider.notifier).signIn(
          email,
          password,
          context,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    // Hardcoded account data for demo purposes only.
    // You will need to add a user in your firebase console for testing.
    //
    const String email = "c@c.com";
    const String password = "asdfasdf";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bulletproof Auth"),
        actions: [
          IconButton(
            onPressed: () => signIn(
              ref,
              context,
              email,
              password,
            ),
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: const Center(
        child: Text("Sign In"),
      ),
    );
  }
}
