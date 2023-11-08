import 'package:flutter/cupertino.dart';
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
    debugPrint("Log In");
    ref.read(authControllerProvider.notifier).signIn(
          email,
          password,
          context,
        );
  }

  void signUp(BuildContext context, WidgetRef ref) {
    debugPrint("Sign Up");
    ref.read(authControllerProvider.notifier).signUp(
          context,
          'test@test.com',
          'asdfasdf',
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
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: CupertinoButton.filled(
              onPressed: () => signIn(
                ref,
                context,
                email,
                password,
              ),
              child: const Text("Sign In C@C"),
            ),
          ),
          const Spacer(),
          Center(
            child: CupertinoButton.filled(
              onPressed: () => signUp(context, ref),
              child: const Text("Sign Up test@test"),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
