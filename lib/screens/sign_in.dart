import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signIn(WidgetRef ref, BuildContext context) {
    if (kDebugMode) {
      print('Sign In');
    }
    ref.read(authControllerProvider.notifier).signIn(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bulletproof Auth"),
        actions: [
          IconButton(
            onPressed: () => signIn(ref, context),
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
